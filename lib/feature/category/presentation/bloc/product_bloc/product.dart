import 'package:empire/feature/category/domain/entities/product_entities.dart';
import 'package:empire/feature/category/domain/usecase/product/product_usecae.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddProductEvent extends ProductEvent {
  final ProductEntity product;
  final String uid;
  final String mainCtiegoryid;
  AddProductEvent(this.product, this.uid, this.mainCtiegoryid);

  @override
  List<Object?> get props => [product, uid,mainCtiegoryid];
}

@immutable
abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {}

class ProductFailure extends ProductState {
  final String message;

  ProductFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final AddProduct addProductUseCase;

  ProductBloc(this.addProductUseCase) : super(ProductInitial()) {
    on<AddProductEvent>(_onAddProduct);
  }

  Future<void> _onAddProduct(
    AddProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await addProductUseCase(
      event.product,
      event.uid,
      event.mainCtiegoryid,
    );
    result.fold(
      (failure) => emit(ProductFailure(failure.toString())),
      (_) => emit(ProductSuccess()),
    );
  }
}
