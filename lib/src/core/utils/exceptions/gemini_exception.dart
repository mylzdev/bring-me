class GeminiRepositoryException implements Exception {
  const GeminiRepositoryException([this.message = 'Unknown problem']);

  final String message;

  @override
  String toString() => 'GeminiRepositoryException: $message';
}
