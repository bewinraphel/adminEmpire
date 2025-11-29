class ValidationError {
  final String field;
  final String message;

  const ValidationError({
    required this.field,
    required this.message,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationError &&
          field == other.field &&
          message == other.message;

  @override
  int get hashCode => field.hashCode ^ message.hashCode;
}