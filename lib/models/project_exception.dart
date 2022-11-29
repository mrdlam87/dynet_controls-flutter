class ProjectException implements Exception {
  final String message;

  ProjectException(this.message);

  @override
  String toString() {
    return message;
  }
}
