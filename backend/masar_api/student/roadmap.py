from urllib.parse import urlsplit

from flask import jsonify, request

from . import student_bp
from .profile import (
    ProfileError,
    _id,
    _require_token,
    _require_user,
    _text,
)
from ..database import get_connection
from ..repository import WISE_UNIVERSITY_ID


STATUSES = {
    "NOT_STARTED",
    "IN_PROGRESS",
    "COMPLETED",
}


def _student(cursor, user_id, lock=False):
    query = """
        SELECT
            s.student_id,
            s.career_path_id,
            cp.path_name
        FROM students s
        LEFT JOIN career_paths cp
            ON cp.career_path_id = s.career_path_id
            AND cp.is_active = 1
        WHERE s.user_id = :user_id
          AND s.university_id = :university_id
    """

    if lock:
        query += " FOR UPDATE OF s.career_path_id"

    cursor.execute(
        query,
        user_id=user_id,
        university_id=WISE_UNIVERSITY_ID,
    )

    row = cursor.fetchone()

    if row is None:
        raise ProfileError(
            "ملف الطالب غير موجود.",
            404,
            "student_not_found",
        )

    if row[1] is None or row[2] is None:
        raise ProfileError(
            "اختاري مسارًا مهنيًا من الرئيسية أولًا.",
            422,
            "career_path_required",
        )

    return int(row[0]), int(row[1]), row[2]


def _body():
    payload = request.get_json(silent=True)

    if not isinstance(payload, dict):
        raise ProfileError(
            "بيانات الطلب غير صالحة.",
            400,
        )

    return payload


def _check_path(payload, path_id):
    submitted = _id(
        payload.get("careerPathId"),
        "المسار المهني",
    )

    if submitted != path_id:
        raise ProfileError(
            "تغيّر المسار المهني. أعيدي تحميل خارطة الطريق.",
            409,
            "roadmap_path_changed",
        )


def _status(payload):
    value = payload.get("status")

    if not isinstance(value, str) or value not in STATUSES:
        raise ProfileError(
            "حالة المهمة غير صالحة."
        )

    return value


def _lob_text(value):
    if hasattr(value, "read"):
        return value.read()

    return value or ""


def _resource_url(value):
    if not isinstance(value, str):
        return None

    try:
        parts = urlsplit(value)

        if (
            parts.scheme in ("http", "https")
            and parts.hostname
            and not parts.username
            and not parts.password
        ):
            return value

    except ValueError:
        pass

    return None


def _task_json(row):
    return {
        "id": str(row[0]),
        "title": row[1],
        "description": row[2] or "",
        "order": int(row[3]),
        "status": row[4],
        "roadmapItemId": (
            str(row[5])
            if row[5] is not None
            else None
        ),
    }


def _read_roadmap(cursor, student_id, path_id, path_name):
    cursor.execute("""
        SELECT
            ri.roadmap_item_id,
            ri.title,
            ri.description,
            ri.display_order,
            ri.estimated_hours,
            ri.skill_id,
            sk.skill_name,
            CASE
                WHEN EXISTS (
                    SELECT 1
                    FROM student_skills ss
                    WHERE ss.student_id = :student_id
                      AND ss.skill_id = ri.skill_id
                )
                THEN 1
                ELSE 0
            END
        FROM roadmap_items ri
        LEFT JOIN skills sk
            ON sk.skill_id = ri.skill_id
        WHERE ri.career_path_id = :path_id
          AND ri.is_active = 1
        ORDER BY
            ri.display_order,
            ri.roadmap_item_id
    """,
        student_id=student_id,
        path_id=path_id,
    )

    items = []

    for row in cursor.fetchall():
        items.append({
            "id": str(row[0]),
            "title": row[1],
            "description": _lob_text(row[2]),
            "order": int(row[3]),
            "estimatedHours": (
                float(row[4])
                if row[4] is not None
                else None
            ),
            "skillId": (
                str(row[5])
                if row[5] is not None
                else None
            ),
            "skillName": row[6],
            "selectedInProfile": bool(row[7]),
            "status": "NOT_STARTED",
            "resources": [],
        })

    by_id = {
        item["id"]: item
        for item in items
    }

    cursor.execute("""
        SELECT
            lr.resource_id,
            lr.roadmap_item_id,
            lr.title,
            lr.resource_type,
            lr.resource_url,
            lr.description
        FROM learning_resources lr
        JOIN roadmap_items ri
            ON ri.roadmap_item_id = lr.roadmap_item_id
        WHERE ri.career_path_id = :path_id
          AND ri.is_active = 1
          AND lr.is_active = 1
        ORDER BY
            lr.display_order,
            lr.resource_id
    """, path_id=path_id)

    for row in cursor.fetchall():
        item = by_id.get(str(row[1]))

        if item is not None:
            item["resources"].append({
                "id": str(row[0]),
                "title": row[2],
                "type": row[3],
                "url": _resource_url(row[4]),
                "description": row[5] or "",
            })

    cursor.execute("""
        SELECT
            task_id,
            title,
            description,
            display_order,
            progress_status,
            roadmap_item_id
        FROM student_roadmap_tasks
        WHERE student_id = :student_id
          AND career_path_id = :path_id
        ORDER BY display_order, task_id
    """,
        student_id=student_id,
        path_id=path_id,
    )

    personal_tasks = []
    linked_items = set()

    for row in cursor.fetchall():
        task = _task_json(row)
        item_id = task["roadmapItemId"]

        if item_id is None:
            personal_tasks.append(task)
            continue

        if item_id not in by_id:
            continue

        if item_id in linked_items:
            raise ProfileError(
                "توجد سجلات تقدّم مكررة لإحدى الخطوات.",
                409,
                "duplicate_roadmap_progress",
            )

        linked_items.add(item_id)
        by_id[item_id]["status"] = task["status"]

    completed = sum(
        item["status"] == "COMPLETED"
        for item in items
    )

    return {
        "studentId": str(student_id),
        "path": {
            "id": str(path_id),
            "title": path_name,
        },
        "items": items,
        "personalTasks": personal_tasks,
        "completedCount": completed,
        "totalCount": len(items),
        "progressPercentage": (
            round(completed / len(items) * 100, 2)
            if items
            else 0
        ),
    }


def _update_status(cursor, task_id, student_id, path_id, status):
    cursor.execute("""
        UPDATE student_roadmap_tasks
        SET progress_status = :status,
            started_at = CASE
                WHEN :status = 'NOT_STARTED'
                THEN NULL
                ELSE COALESCE(
                    started_at,
                    GREATEST(
                        LOCALTIMESTAMP,
                        created_at
                    )
                )
            END,
            completed_at = CASE
                WHEN :status = 'COMPLETED'
                THEN GREATEST(
                    LOCALTIMESTAMP,
                    created_at,
                    COALESCE(started_at, created_at)
                )
                ELSE NULL
            END,
            updated_at = LOCALTIMESTAMP
        WHERE task_id = :task_id
          AND student_id = :student_id
          AND career_path_id = :path_id
    """,
        status=status,
        task_id=task_id,
        student_id=student_id,
        path_id=path_id,
    )

    if cursor.rowcount != 1:
        raise ProfileError(
            "المهمة غير موجودة.",
            404,
            "task_not_found",
        )


@student_bp.get("/me/roadmap")
def get_my_roadmap():
    token = _require_token()

    with get_connection() as connection:
        with connection.cursor() as cursor:
            user_id = _require_user(cursor, token)

            student_id, path_id, path_name = _student(
                cursor,
                user_id,
            )

            data = _read_roadmap(
                cursor,
                student_id,
                path_id,
                path_name,
            )

    return jsonify({"data": data})


@student_bp.put("/me/roadmap/items/<int:item_id>")
def update_my_roadmap_item(item_id):
    token = _require_token()
    payload = _body()
    status = _status(payload)

    with get_connection() as connection:
        with connection.cursor() as cursor:
            user_id = _require_user(cursor, token)

            student_id, path_id, path_name = _student(
                cursor,
                user_id,
                lock=True,
            )

            _check_path(payload, path_id)

            cursor.execute("""
                SELECT title, display_order
                FROM roadmap_items
                WHERE roadmap_item_id = :item_id
                  AND career_path_id = :path_id
                  AND is_active = 1
            """,
                item_id=item_id,
                path_id=path_id,
            )

            item = cursor.fetchone()

            if item is None:
                raise ProfileError(
                    "هذه الخطوة غير متاحة في المسار الحالي.",
                    404,
                    "roadmap_item_not_found",
                )

            cursor.execute("""
                SELECT task_id
                FROM student_roadmap_tasks
                WHERE student_id = :student_id
                  AND career_path_id = :path_id
                  AND roadmap_item_id = :item_id
            """,
                student_id=student_id,
                path_id=path_id,
                item_id=item_id,
            )

            matches = cursor.fetchall()

            if len(matches) > 1:
                raise ProfileError(
                    "توجد سجلات تقدّم مكررة لهذه الخطوة.",
                    409,
                    "duplicate_roadmap_progress",
                )

            if matches:
                task_id = int(matches[0][0])

            else:
                task_id_out = cursor.var(int)

                cursor.execute("""
                    INSERT INTO student_roadmap_tasks (
                        student_id,
                        career_path_id,
                        roadmap_item_id,
                        title,
                        display_order
                    )
                    VALUES (
                        :student_id,
                        :path_id,
                        :item_id,
                        :title,
                        :display_order
                    )
                    RETURNING task_id INTO :task_id_out
                """,
                    student_id=student_id,
                    path_id=path_id,
                    item_id=item_id,
                    title=item[0],
                    display_order=int(item[1]),
                    task_id_out=task_id_out,
                )

                task_id = int(task_id_out.getvalue()[0])

            _update_status(
                cursor,
                task_id,
                student_id,
                path_id,
                status,
            )

            data = _read_roadmap(
                cursor,
                student_id,
                path_id,
                path_name,
            )

        connection.commit()

    return jsonify({"data": data})


@student_bp.post("/me/roadmap/tasks")
def create_my_roadmap_task():
    token = _require_token()
    payload = _body()
    title = _text(payload.get("title"), "اسم المهمة", 120)

    with get_connection() as connection:
        with connection.cursor() as cursor:
            user_id = _require_user(cursor, token)

            student_id, path_id, path_name = _student(
                cursor,
                user_id,
                lock=True,
            )

            _check_path(payload, path_id)

            cursor.execute("""
                SELECT
                    COUNT(*),
                    COALESCE(MAX(display_order), 0)
                FROM student_roadmap_tasks
                WHERE student_id = :student_id
                  AND career_path_id = :path_id
                  AND roadmap_item_id IS NULL
            """,
                student_id=student_id,
                path_id=path_id,
            )

            count, last_order = cursor.fetchone()

            if int(count) >= 100:
                raise ProfileError(
                    "الحد الأقصى 100 مهمة شخصية لكل مسار."
                )

            cursor.execute("""
                INSERT INTO student_roadmap_tasks (
                    student_id,
                    career_path_id,
                    title,
                    display_order
                )
                VALUES (
                    :student_id,
                    :path_id,
                    :title,
                    :display_order
                )
            """,
                student_id=student_id,
                path_id=path_id,
                title=title,
                display_order=int(last_order) + 1,
            )

            data = _read_roadmap(
                cursor,
                student_id,
                path_id,
                path_name,
            )

        connection.commit()

    return jsonify({"data": data}), 201


@student_bp.put("/me/roadmap/tasks/<int:task_id>")
def update_my_personal_roadmap_task(task_id):
    token = _require_token()
    payload = _body()
    status = _status(payload)

    with get_connection() as connection:
        with connection.cursor() as cursor:
            user_id = _require_user(cursor, token)

            student_id, path_id, path_name = _student(
                cursor,
                user_id,
                lock=True,
            )

            _check_path(payload, path_id)

            cursor.execute("""
                SELECT task_id
                FROM student_roadmap_tasks
                WHERE task_id = :task_id
                  AND student_id = :student_id
                  AND career_path_id = :path_id
                  AND roadmap_item_id IS NULL
            """,
                task_id=task_id,
                student_id=student_id,
                path_id=path_id,
            )

            if cursor.fetchone() is None:
                raise ProfileError(
                    "المهمة الشخصية غير موجودة.",
                    404,
                    "task_not_found",
                )

            _update_status(
                cursor,
                task_id,
                student_id,
                path_id,
                status,
            )

            data = _read_roadmap(
                cursor,
                student_id,
                path_id,
                path_name,
            )

        connection.commit()

    return jsonify({"data": data})