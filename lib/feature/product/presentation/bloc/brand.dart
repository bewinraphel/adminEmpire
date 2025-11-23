import 'dart:typed_data';

import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/usecase/adding_brand_usecase.dart';
import 'package:empire/feature/product/domain/usecase/get_brand_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class BrandEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BrandFetching extends BrandEvent {
  final String mainCategoryId;
  final String subCategoryId;
  BrandFetching({required this.mainCategoryId, required this.subCategoryId});

  @override
  List<Object> get props => [mainCategoryId, subCategoryId];
}

class BrandAddingEvent extends BrandEvent {
  final String mainCategoryId;
  final String subCategoryId;
  final Brand brand;
  final Uint8List? imageBytes;
  BrandAddingEvent({
    required this.mainCategoryId,
    this.imageBytes,
    required this.subCategoryId,
    required this.brand,
  });
  @override
  List<Object> get props => [mainCategoryId, subCategoryId];
}

class SelectBrandEvent extends BrandEvent {
  final Brand brand;
  SelectBrandEvent(this.brand);
  @override
  List<Object> get props => [brand];
}

abstract class BrandState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BrandLoading extends BrandState {}

class LoadedBrand extends BrandState {
  final List<Brand> brands;
  final Brand? selectedBrand;

  LoadedBrand({required this.brands, this.selectedBrand});

  @override
  List<Object?> get props => [brands, selectedBrand];
}

class BrandError extends BrandState {
  final String error;
  BrandError({required this.error});
  @override
  List<Object> get props => [error];
}

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final AddBrandUseCase addBrandUseCase;
  final GetBrandsUseCase getBrandsUseCase;

  BrandBloc(this.addBrandUseCase, this.getBrandsUseCase)
    : super(BrandLoading()) {
    on<BrandFetching>((event, emit) async {
      final result = await getBrandsUseCase(
        event.mainCategoryId,
        event.subCategoryId,
      );
      result.fold(
        (failure) => emit(BrandError(error: failure.message)),
        (result) => emit(LoadedBrand(brands: result)),
      );
    });
    on<BrandAddingEvent>((event, emit) {
      emit(BrandLoading());
      addBrandUseCase(
        event.mainCategoryId,
        event.subCategoryId,
        event.brand,
        event.imageBytes,
      );
    });
    on<SelectBrandEvent>((event, emit) {
      if (state is LoadedBrand) {
        final currentState = state as LoadedBrand;

        emit(
          LoadedBrand(brands: currentState.brands, selectedBrand: event.brand),
        );
      }
    });
  }
}
