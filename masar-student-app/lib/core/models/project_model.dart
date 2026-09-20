class Project {
  final String id;
  final String name;
  final String description;
  final List<String> technologies;
  final String? githubUrl;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.technologies,
    this.githubUrl,
  });
}