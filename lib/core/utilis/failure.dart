import 'package:equatable/equatable.dart';

class CategoryFailure extends Equatable {
  final String message;
  final String type;

  const CategoryFailure._(this.message, this.type);

  const CategoryFailure.network(String message) : this._(message,'networ');
  const CategoryFailure.validation(String message)
    : this._(message, 'validation');
  const CategoryFailure.server(String message) : this._(message, 'server');

  @override
  List<Object?> get props => [message, type];
}
