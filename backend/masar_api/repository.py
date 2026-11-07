import hashlib
import secrets


WISE_UNIVERSITY_ID = 12


def token_digest(token):
    return hashlib.sha256(token.encode("utf-8")).hexdigest()


def create_session(cursor, user_id, remember_me=False):
    token = secrets.token_urlsafe(32)
    expires_in = (30 * 24 if remember_me else 8) * 60 * 60

    cursor.execute("""
        INSERT INTO auth_sessions (
            user_id,
            token_hash,
            remember_me,
            created_at,
            expires_at
        )
        VALUES (
            :user_id,
            :token_hash,
            :remember_me,
            LOCALTIMESTAMP,
            LOCALTIMESTAMP
                + NUMTODSINTERVAL(:expires_in, 'SECOND')
        )
    """,
        user_id=user_id,
        token_hash=token_digest(token),
        remember_me=int(remember_me),
        expires_in=expires_in,
    )

    cursor.execute("""
        UPDATE users
        SET last_login_at = LOCALTIMESTAMP
        WHERE user_id = :user_id
    """, user_id=user_id)

    return token, expires_in


def read_student(cursor, user_id):
    cursor.execute("""
        SELECT
            s.student_id,
            u.full_name,
            u.email,
            s.student_number,
            s.university_id,
            un.university_name,
            s.major,
            s.academic_year,
            s.career_path_id,
            s.profile_completed,
            s.profile_version,
            s.program_id,
            s.affiliation_status,
            u.full_name_en
        FROM students s
        JOIN users u
            ON u.user_id = s.user_id
        JOIN universities un
            ON un.university_id = s.university_id
        WHERE s.user_id = :user_id
    """, user_id=user_id)

    row = cursor.fetchone()

    if row is None:
        raise RuntimeError("Student record was not found.")

    student_id = int(row[0])

    profile = {
        "id": str(student_id),
        "name": row[1],
        "nameEn": row[13] or "",
        "email": row[2],
        "studentNumber": row[3],
        "universityId": str(row[4]),
        "university": row[5],
        "major": row[6] or "",
        "academicYear": row[7] or "",
        "careerPathId": (
            str(row[8]) if row[8] is not None else None
        ),
        "profileCompleted": bool(row[9]),
        "version": int(row[10]),
        "programId": (
            str(row[11]) if row[11] is not None else None
        ),
        "affiliationStatus": row[12],
        "skills": [],
        "softSkills": [],
        "certificates": [],
        "projects": [],
    }

    cursor.execute("""
        SELECT
            sk.skill_id,
            sk.skill_name,
            sk.skill_type,
            ss.self_reported_level
        FROM student_skills ss
        JOIN skills sk
            ON sk.skill_id = ss.skill_id
        WHERE ss.student_id = :student_id
        ORDER BY sk.skill_name
    """, student_id=student_id)

    for skill_id, name, skill_type, level in cursor.fetchall():
        item = {
            "id": str(skill_id),
            "name": name,
            "level": int(level) if level is not None else 0,
        }

        if skill_type == "SOFT":
            profile["softSkills"].append(item)
        else:
            item["status"] = "Not Assessed"
            profile["skills"].append(item)

    cursor.execute("""
        SELECT
            certificate_id,
            certificate_title,
            issuer,
            issue_date
        FROM certificates
        WHERE student_id = :student_id
        ORDER BY certificate_id
    """, student_id=student_id)

    for certificate_id, title, issuer, issue_date in cursor.fetchall():
        profile["certificates"].append({
            "id": str(certificate_id),
            "title": title,
            "issuer": issuer,
            "date": (
                issue_date.strftime("%Y-%m-%d")
                if issue_date else ""
            ),
        })

    cursor.execute("""
        SELECT
            p.project_id,
            pt.technology_name
        FROM projects p
        JOIN project_technologies pt
            ON pt.project_id = p.project_id
        WHERE p.student_id = :student_id
        ORDER BY p.project_id, pt.project_technology_id
    """, student_id=student_id)

    technologies = {}

    for project_id, name in cursor.fetchall():
        technologies.setdefault(int(project_id), []).append(name)

    cursor.execute("""
        SELECT
            project_id,
            project_name,
            description,
            github_url
        FROM projects
        WHERE student_id = :student_id
        ORDER BY project_id
    """, student_id=student_id)

    for project_id, name, description, github_url in cursor.fetchall():
        if hasattr(description, "read"):
            description = description.read()

        profile["projects"].append({
            "id": str(project_id),
            "name": name,
            "description": description or "",
            "githubUrl": github_url,
            "technologies": technologies.get(int(project_id), []),
        })

    return profile