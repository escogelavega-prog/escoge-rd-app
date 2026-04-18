enum AppFeedbackType {
  success,
  error,
  warning,
  info,
}

class AppFeedbackModel {
  final AppFeedbackType type;
  final String message;
  final String? code;
  final Object? exception;
  final StackTrace? stackTrace;

  const AppFeedbackModel({
    required this.type,
    required this.message,
    this.code,
    this.exception,
    this.stackTrace,
  });

  bool get isSuccess => type == AppFeedbackType.success;
  bool get isError => type == AppFeedbackType.error;
  bool get isWarning => type == AppFeedbackType.warning;
  bool get isInfo => type == AppFeedbackType.info;

  factory AppFeedbackModel.success(
    String message, {
    String? code,
  }) {
    return AppFeedbackModel(
      type: AppFeedbackType.success,
      message: message,
      code: code,
    );
  }

  factory AppFeedbackModel.error(
    String message, {
    String? code,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    return AppFeedbackModel(
      type: AppFeedbackType.error,
      message: message,
      code: code,
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  factory AppFeedbackModel.warning(
    String message, {
    String? code,
  }) {
    return AppFeedbackModel(
      type: AppFeedbackType.warning,
      message: message,
      code: code,
    );
  }

  factory AppFeedbackModel.info(
    String message, {
    String? code,
  }) {
    return AppFeedbackModel(
      type: AppFeedbackType.info,
      message: message,
      code: code,
    );
  }

  AppFeedbackModel copyWith({
    AppFeedbackType? type,
    String? message,
    String? code,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    return AppFeedbackModel(
      type: type ?? this.type,
      message: message ?? this.message,
      code: code ?? this.code,
      exception: exception ?? this.exception,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }

  @override
  String toString() {
    return 'AppFeedbackModel(type: $type, message: $message, code: $code)';
  }
}
