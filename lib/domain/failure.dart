enum FailureKind {
  network,
  timeout,
  rateLimited,
  server,
  credentials,
  balance,
  invalidRequest,
  invalidResponse,
  storage,
  speech,
  cancelled,
}

class AppFailure implements Exception {
  const AppFailure(
    this.kind,
    this.message, {
    this.status,
    this.retryAfter,
    this.requestId,
  });
  final FailureKind kind;
  final String message;
  final int? status;
  final Duration? retryAfter;
  final String? requestId;
  bool get retryable => {
    FailureKind.network,
    FailureKind.timeout,
    FailureKind.rateLimited,
    FailureKind.server,
  }.contains(kind);
  bool get needsUser => {
    FailureKind.credentials,
    FailureKind.balance,
    FailureKind.invalidRequest,
  }.contains(kind);
  @override
  String toString() => message;
}
