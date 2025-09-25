import 'package:empire/feature/product/domain/enities/product_entities.dart';

import 'package:empire/feature/product/domain/usecase/productcaliing_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class Productevent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductCallingEvent extends Productevent {
  final String mainCategoryId;
  final String subCategoryId;
  final String ?brand;
  ProductCallingEvent({
    required this.mainCategoryId,
    required this.subCategoryId,
    required this.brand,
  });
  @override
  List<Object?> get props => [mainCategoryId, subCategoryId];
}

@override
abstract class Productstate extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialProduct extends Productstate {}

class LoadingProduct extends Productstate {}

class Productfetched extends Productstate {
  final List<ProductEntity> products;
  Productfetched(this.products);
  @override
  List<Object?> get props => [products];
}

class ProductError extends Productstate {
  final String messange;
  ProductError(this.messange);
  @override
  List<Object?> get props => [messange];
}

class ProductcalingBloc extends Bloc<ProductCallingEvent, Productstate> {
  final ProductcallingUsecase productcaliingUsecase;

  ProductcalingBloc(this.productcaliingUsecase) : super(LoadingProduct()) {
    on<ProductCallingEvent>((event, emit) async {
      emit(LoadingProduct());
      final result = await productcaliingUsecase(
        event.mainCategoryId,
        event.subCategoryId,
        event.brand,
      );

      result.fold(
        (failure) => emit(ProductError(failure.toString())),
        (results) => emit(Productfetched(results)),
      );
    });
  }
}
