import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/domain/usecase/add_product_usecae.dart';
import 'package:empire/feature/product/domain/usecase/get_default_usecase.dart';
import 'package:empire/feature/product/domain/usecase/vaidate_product_form.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_form_bloc/add_product_form_event.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_form_bloc/add_product_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductFormBloc
    extends Bloc<AddProductFormEvent, AddProductFormState> {
  final ValidateProductFormUseCase _validateProductFormUseCase;
  final GetDefaultVariantsUseCase _getDefaultVariantsUseCase;
  final AddProductUseCase _addProductUseCase;

  AddProductFormBloc({
    required ValidateProductFormUseCase validateProductFormUseCase,
    required GetDefaultVariantsUseCase getDefaultVariantsUseCase,
    required AddProductUseCase addProductUseCase,
  }) : _validateProductFormUseCase = validateProductFormUseCase,
       _getDefaultVariantsUseCase = getDefaultVariantsUseCase,
       _addProductUseCase = addProductUseCase,
       super(const AddProductFormState()) {
    on<InitializeFormEvent>(_onInitialize);
    on<UpdateProductNameEvent>(_onUpdateProductName);
    on<UpdateDescriptionEvent>(_onUpdateDescription);
    on<UpdateTagsEvent>(_onUpdateTags);
    on<UpdateInStockEvent>(_onUpdateInStock);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<UpdateDimensionsEvent>(_onUpdateDimensions);
    on<AddVariantEvent>(_onAddVariant);
    on<UpdateVariantImageEvent>(_onUpdateVariantImage);
    on<UpdateVariantPriceEvent>(_onUpdateVariantPrice);
    on<UpdateVariantQuantityEvent>(_onUpdateVariantQuantity);
    on<AddProductImagesEvent>(_onAddProductImages);
    on<AddVarientImagesEvent>(_onAddVarientProductImages);
    on<RemovevarientProductImageEvent>(_onRemoveVArientProductImage);
    on<RemoveProductImageEvent>(_onRemoveProductImage);
    on<ValidateFormEvent>(_onValidateForm);
    on<SubmitFormEvent>(_onSubmitForm);
  }

  void _onInitialize(
    InitializeFormEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    emit(const AddProductFormState());
  }

  void _onUpdateProductName(
    UpdateProductNameEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    emit(state.copyWith(productName: event.productName));
  }

  void _onUpdateDescription(
    UpdateDescriptionEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onUpdateTags(UpdateTagsEvent event, Emitter<AddProductFormState> emit) {
    emit(state.copyWith(tags: event.tags));
  }

  void _onUpdateInStock(
    UpdateInStockEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    emit(state.copyWith(inStock: event.inStock));
  }

  void _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    final newVariants = _getDefaultVariantsUseCase(event.category);
    emit(state.copyWith(category: event.category, variants: newVariants));
  }

  void _onUpdateDimensions(
    UpdateDimensionsEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    emit(
      state.copyWith(
        weight: event.weight ?? state.weight,
        length: event.length ?? state.length,
        width: event.width ?? state.width,
        height: event.height ?? state.height,
      ),
    );
  }

  void _onAddVariant(AddVariantEvent event, Emitter<AddProductFormState> emit) {
    final newVariant = Variant(name: event.variantName);
    final updatedVariants = List<Variant>.from(state.variants)..add(newVariant);
    emit(state.copyWith(variants: updatedVariants));
  }

  void _onUpdateVariantImage(
    UpdateVariantImageEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (event.variantIndex >= state.variants.length) return;

    final updatedVariants = List<Variant>.from(state.variants);
    final currentVariant = updatedVariants[event.variantIndex];

    updatedVariants[event.variantIndex] = Variant(
      name: currentVariant.name,
      imageweb: event.imagePath,
      regularPrice: currentVariant.regularPrice,
      salePrice: currentVariant.salePrice,
      quantity: currentVariant.quantity,
    );

    emit(state.copyWith(variants: updatedVariants));
  }

  void _onUpdateVariantPrice(
    UpdateVariantPriceEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (event.variantIndex >= state.variants.length) return;

    final updatedVariants = List<Variant>.from(state.variants);
    final currentVariant = updatedVariants[event.variantIndex];

    updatedVariants[event.variantIndex] = Variant(
      name: currentVariant.name,
      imageweb: currentVariant.imageweb,
      regularPrice: event.regularPrice,
      salePrice: event.salePrice,
      quantity: currentVariant.quantity,
    );

    emit(state.copyWith(variants: updatedVariants));
  }

  void _onUpdateVariantQuantity(
    UpdateVariantQuantityEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (event.variantIndex >= state.variants.length) return;

    final updatedVariants = List<Variant>.from(state.variants);
    final currentVariant = updatedVariants[event.variantIndex];

    updatedVariants[event.variantIndex] = Variant(
      name: currentVariant.name,
      imageweb: currentVariant.imageweb,
      regularPrice: currentVariant.regularPrice,
      salePrice: currentVariant.salePrice,
      quantity: event.quantity,
    );

    emit(state.copyWith(variants: updatedVariants));
  }

  void _onAddProductImages(
    AddProductImagesEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    final updatedImages = List<dynamic>.from(state.productImages)
      ..addAll(event.imagePaths);
    emit(state.copyWith(productImages: updatedImages));
  }

  void _onRemoveProductImage(
    RemoveProductImageEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (event.imageIndex >= state.productImages.length) return;

    final updatedImages = List<dynamic>.from(state.productImages)
      ..removeAt(event.imageIndex);
    emit(state.copyWith(productImages: updatedImages));
  }

  void _onAddVarientProductImages(
    AddVarientImagesEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    final updatedImages = List<dynamic>.from(state.productImages)
      ..addAll(event.imagePaths);
    emit(state.copyWith(productImages: updatedImages));
  }

  void _onRemoveVArientProductImage(
    RemovevarientProductImageEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (event.imageIndex >= state.productImages.length) return;

    final updatedImages = List<dynamic>.from(state.productImages)
      ..removeAt(event.imageIndex);
    emit(state.copyWith(productImages: updatedImages));
  }

  void _onValidateForm(
    ValidateFormEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    emit(state.copyWith(status: FormStatus.validating));

    final validationResult = _validateProductFormUseCase(
      productName: state.productName,
      description: state.description,
      images: state.productImages,
      category: state.category,
      brandLabel: null,
    );

    emit(
      state.copyWith(
        validationResult: validationResult,
        status: validationResult.isValid
            ? FormStatus.valid
            : FormStatus.invalid,
      ),
    );
  }

  Future<void> _onSubmitForm(
    SubmitFormEvent event,
    Emitter<AddProductFormState> emit,
  ) async {
    // Validate before submission
    final validationResult = _validateProductFormUseCase(
      productName: state.productName,
      description: state.description,
      images: state.productImages,
      category: state.category,
      brandLabel: event.selectedBrandLabel,
    );

    if (!validationResult.isValid) {
      emit(
        state.copyWith(
          validationResult: validationResult,
          status: FormStatus.invalid,
        ),
      );
      return;
    }

    emit(state.copyWith(status: FormStatus.submitting));

    final product = ProductEntity(
      mainCategoryId: event.mainCategoryId,
      subcategoryId: event.subcategoryId,
      name: state.productName,
      description: state.description,
      mainCategoryName: event.mainCategoryName,
      subcategoryName: event.subcategoryName,
      tags: state.tags,
      length: state.length,
      width: state.width,
      height: state.height,
      category: state.category,
      filterTags: const [],
      weight: state.weight,
      inStock: state.inStock,
      images: state.productImages,
      variantDetails: state.variants,
      brand: event.selectedBrandLabel ?? '',
    );
 
    final result = await _addProductUseCase(
      product,
      event.mainCategoryId,
      event.subcategoryId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FormStatus.error,
          errorMessage: failure.toString(),
        ),
      ),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }
}
