class FirebaseResult<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? code;
  final Object? exception;
  final StackTrace? stackTrace;

  const FirebaseResult({
    required this.success,
    this.data,
    this.message,
    this.code,
    this.exception,
    this.stackTrace,
  });

  bool get isSuccess => success;
  bool get isFailure => !success;
  bool get hasData => data != null;

  factory FirebaseResult.success({
    T? data,
    String? message,
    String? code,
  }) {
    return FirebaseResult<T>(
      success: true,
      data: data,
      message: message,
      code: code,
    );
  }

  factory FirebaseResult.failure({
    String? message,
    String? code,
    Object? exception,
    StackTrace? stackTrace,
    T? data,
  }) {
    return FirebaseResult<T>(
      success: false,
      data: data,
      message: message,
      code: code,
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  FirebaseResult<T> copyWith({
    bool? success,
    T? data,
    String? message,
    String? code,
    Object? exception,
    StackTrace? stackTrace,
    bool keepCurrentData = true,
    bool keepCurrentException = true,
    bool keepCurrentStackTrace = true,
  }) {
    return FirebaseResult<T>(
      success: success ?? this.success,
      data: keepCurrentData ? (data ?? this.data) : data,
      message: message ?? this.message,
      code: code ?? this.code,
      exception:
          keepCurrentException ? (exception ?? this.exception) : exception,
      stackTrace:
          keepCurrentStackTrace ? (stackTrace ?? this.stackTrace) : stackTrace,
    );
  }

  R when<R>({
    required R Function(T? data, String? message, String? code) success,
    required R Function(
      String? message,
      String? code,
      Object? exception,
      StackTrace? stackTrace,
      T? data,
    ) failure,
  }) {
    if (this.success) {
      return success(data, message, code);
    }

    return failure(message, code, exception, stackTrace, data);
  }

  @override
  String toString() {
    return 'FirebaseResult<$T>(success: $success, message: $message, code: $code, data: $data)';
  }
}
