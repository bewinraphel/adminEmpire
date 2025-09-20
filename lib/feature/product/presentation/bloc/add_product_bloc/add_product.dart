import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/domain/usecase/product/add_product_usecae.dart';

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
  List<Object?> get props => [product, uid, mainCtiegoryid];
}

class Productweight extends ProductEvent {
  final String productweight;
  Productweight(this.productweight);
  @override
  List<Object?> get props => [productweight];
}

class DeleteProductEvent extends ProductEvent {
  final String mainCategoryId;
  final String subcategoryId;
  final String productId;

  DeleteProductEvent(this.mainCategoryId, this.subcategoryId, this.productId);

  @override
  List<Object> get props => [mainCategoryId, subcategoryId, productId];
}

class UpdateProductEvent extends ProductEvent {
  final ProductEntity product;
  final String subcategoryId;
  final String mainCategoryId;
  final String productId;
  UpdateProductEvent({
    required this.product,
    required this.subcategoryId,
    required this.mainCategoryId,
    required this.productId,
  });

  @override
  List<Object?> get props => [product, subcategoryId, mainCategoryId];
}

@immutable
abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {}

class ProductDeleted extends ProductState {}

class SeletedState extends ProductState {
  final String productweight;
  SeletedState(this.productweight);
  @override
  List<Object?> get props => [productweight];
}

class ProductFailure extends ProductState {
  final String message;

  ProductFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final AddProductUseCase addProductUseCase;

  ProductBloc(this.addProductUseCase) : super(ProductInitial()) {
    on<AddProductEvent>(_onAddProduct);

    on<Productweight>((event, emit) {
      emit(SeletedState(event.productweight));
    });
    on<DeleteProductEvent>((event, emit) async {
      emit(ProductLoading());
      final result = await addProductUseCase.deleteProduct(
        event.mainCategoryId,
        event.subcategoryId,
        event.productId,
      );
      result.fold(
        (failure) => emit(ProductFailure(failure.toString())),
        (_) => emit(ProductDeleted()),
      );
    });
    on<UpdateProductEvent>(onUpdateProduct);
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

  Future<void> onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await addProductUseCase.updateProduct(
      productId: event.productId,
      product: event.product,
      subcategoryId: event.subcategoryId,
      mainCategoryId: event.mainCategoryId,
    );
    result.fold(
      (failure) => emit(ProductFailure(failure.toString())),
      (_) => emit(ProductSuccess()),
    );
  }
}
