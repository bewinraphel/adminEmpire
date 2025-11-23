import 'package:empire/feature/product/domain/enities/product_entities.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AddProductFormEvent extends Equatable {
  const AddProductFormEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProductNameEvent extends AddProductFormEvent {
  final String productName;

  const UpdateProductNameEvent(this.productName);

  @override
  List<Object> get props => [productName];
}

class UpdateDescriptionEvent extends AddProductFormEvent {
  final String description;

  const UpdateDescriptionEvent(this.description);

  @override
  List<Object> get props => [description];
}

class UpdatePriceEvent extends AddProductFormEvent {
  final double price;

  const UpdatePriceEvent(this.price);

  @override
  List<Object> get props => [price];
}

class UpdateQuantityEvent extends AddProductFormEvent {
  final int quantity;

  const UpdateQuantityEvent(this.quantity);

  @override
  List<Object> get props => [quantity];
}

class UpdateTagsEvent extends AddProductFormEvent {
  final List<String> tags;

  const UpdateTagsEvent(this.tags);

  @override
  List<Object> get props => [tags];
}

class UpdateInStockEvent extends AddProductFormEvent {
  final bool inStock;

  const UpdateInStockEvent(this.inStock);

  @override
  List<Object> get props => [inStock];
}

class UpdateTaxRateEvent extends AddProductFormEvent {
  final double taxRate;

  const UpdateTaxRateEvent(this.taxRate);

  @override
  List<Object> get props => [taxRate];
}

class UpdateFilterTagsEvent extends AddProductFormEvent {
  final List<String> filterTags;

  const UpdateFilterTagsEvent(this.filterTags);

  @override
  List<Object> get props => [filterTags];
}

class UpdateCategoryEvent extends AddProductFormEvent {
  final String category;

  const UpdateCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class UpdateDimensionsEvent extends AddProductFormEvent {
  final double? weight;
  final double? length;
  final double? width;
  final double? height;

  const UpdateDimensionsEvent({
    this.weight,
    this.length,
    this.width,
    this.height,
  });

  @override
  List<Object?> get props => [weight, length, width, height];
}

class UpdateVariantsEvent extends AddProductFormEvent {
  final List<Variant> variants;

  const UpdateVariantsEvent(this.variants);

  @override
  List<Object> get props => [variants];
}

class AddVariantEvent extends AddProductFormEvent {
  final String variantName;

  const AddVariantEvent(this.variantName);

  @override
  List<Object> get props => [variantName];
}

class UpdateVariantImageEvent extends AddProductFormEvent {
  final int variantIndex;
  final String imagePath;
 

  const UpdateVariantImageEvent(this.variantIndex, this.imagePath, );

  @override
  List<Object> get props => [variantIndex, imagePath];
}

class UpdateVariantPriceEvent extends AddProductFormEvent {
  final int variantIndex;
  final double regularPrice;
  final double salePrice;

  const UpdateVariantPriceEvent({
    required this.variantIndex,
    required this.regularPrice,
    required this.salePrice,
  });

  @override
  List<Object> get props => [variantIndex, regularPrice, salePrice];
}

class UpdateVariantQuantityEvent extends AddProductFormEvent {
  final int variantIndex;
  final int quantity;

  const UpdateVariantQuantityEvent(this.variantIndex, this.quantity);

  @override
  List<Object> get props => [variantIndex, quantity];
}

class AddProductImagesEvent extends AddProductFormEvent {
  final List<dynamic> imagePaths;

  const AddProductImagesEvent(this.imagePaths);

  @override
  List<Object> get props => [imagePaths];
}

class RemoveProductImageEvent extends AddProductFormEvent {
  final int imageIndex;

  const RemoveProductImageEvent(this.imageIndex);

  @override
  List<Object> get props => [imageIndex];
}

class AddCategoryEvent extends AddProductFormEvent {
  final String category;

  const AddCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

abstract class AddProductFormState extends Equatable {
  const AddProductFormState();

  @override
  List<Object> get props => [];
}

class AddProductFormInitial extends AddProductFormState {}

class AddProductFormUpdated extends AddProductFormState {
  final String productName;
  final String description;
  final double price;
  final int quantity;
  final List<String> tags;
  final bool inStock;
  final double taxRate;
  final List<String> filterTags;
  final String category;
  final double weight;
  final double length;
  final double width;
  final double height;
  final List<Variant> variants;
  final List<dynamic> productImages;
  final List<String> availableCategories;

  const AddProductFormUpdated({
    this.productName = '',
    this.description = '',
    this.price = 0.0,
    this.quantity = 0,
    this.tags = const [],
    this.inStock = true,
    this.taxRate = 0.0,
    this.filterTags = const [],
    this.category = '',
    this.weight = 0.0,
    this.length = 0.0,
    this.width = 0.0,
    this.height = 0.0,
    this.variants = const [],
    this.productImages = const [],
    this.availableCategories = const [
      'dress',
      'Drinks',
      'electronics',
      'accessories',
    ],
  });

  AddProductFormUpdated copyWith({
    String? productName,
    String? description,
    double? price,
    int? quantity,
    List<String>? tags,
    bool? inStock,
    double? taxRate,
    List<String>? filterTags,
    String? category,
    double? weight,
    double? length,
    double? width,
    double? height,
    List<Variant>? variants,
    List<dynamic>? productImages,
    List<String>? availableCategories,
  }) {
    return AddProductFormUpdated(
      productName: productName ?? this.productName,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      tags: tags ?? this.tags,
      inStock: inStock ?? this.inStock,
      taxRate: taxRate ?? this.taxRate,
      filterTags: filterTags ?? this.filterTags,
      category: category ?? this.category,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      variants: variants ?? this.variants,
      productImages: productImages ?? this.productImages,
      availableCategories: availableCategories ?? this.availableCategories,
    );
  }

  @override
  List<Object> get props => [
    productName,
    description,
    price,
    quantity,
    tags,
    inStock,
    taxRate,
    filterTags,
    category,
    weight,
    length,
    width,
    height,
    variants,
    productImages,
    availableCategories,
  ];
}

class AddProductFormBloc
    extends Bloc<AddProductFormEvent, AddProductFormState> {
  AddProductFormBloc() : super(const AddProductFormUpdated()) {
    on<UpdateProductNameEvent>(_onUpdateProductName);
    on<UpdateDescriptionEvent>(_onUpdateDescription);
    on<UpdatePriceEvent>(_onUpdatePrice);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<UpdateTagsEvent>(_onUpdateTags);
    on<UpdateInStockEvent>(_onUpdateInStock);
    on<UpdateTaxRateEvent>(_onUpdateTaxRate);
    on<UpdateFilterTagsEvent>(_onUpdateFilterTags);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<UpdateDimensionsEvent>(_onUpdateDimensions);
    on<UpdateVariantsEvent>(_onUpdateVariants);
    on<AddVariantEvent>(_onAddVariant);
    on<UpdateVariantImageEvent>(_onUpdateVariantImage);
    on<UpdateVariantPriceEvent>(_onUpdateVariantPrice);
    on<UpdateVariantQuantityEvent>(_onUpdateVariantQuantity);
    on<AddProductImagesEvent>(_onAddProductImages);
    on<RemoveProductImageEvent>(_onRemoveProductImage);
    on<AddCategoryEvent>(_onAddCategory);
  }

  void _onUpdateProductName(
    UpdateProductNameEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      emit(currentState.copyWith(productName: event.productName));
    } else {
      emit(AddProductFormUpdated(productName: event.productName));
    }
  }

  void _onUpdateDescription(
    UpdateDescriptionEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      emit(currentState.copyWith(description: event.description));
    }
  }

  void _onUpdatePrice(
    UpdatePriceEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      emit(currentState.copyWith(price: event.price));
    }
  }

  void _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      emit(currentState.copyWith(quantity: event.quantity));
    }
  }

  void _onUpdateTags(UpdateTagsEvent event, Emitter<AddProductFormState> emit) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      emit(currentState.copyWith(tags: event.tags));
    }
  }

  void _onUpdateInStock(
    UpdateInStockEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      emit(currentState.copyWith(inStock: event.inStock));
    }
  }

  void _onUpdateTaxRate(
    UpdateTaxRateEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      emit(currentState.copyWith(taxRate: event.taxRate));
    }
  }

  void _onUpdateFilterTags(
    UpdateFilterTagsEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      emit(currentState.copyWith(filterTags: event.filterTags));
    }
  }

  void _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;

      // Update variants based on category
      List<Variant> newVariants = _getDefaultVariantsForCategory(
        event.category,
      );

      // This emission is correct and will trigger the rebuild
      emit(
        currentState.copyWith(category: event.category, variants: newVariants),
      );
    }
  }

  void _onUpdateDimensions(
    UpdateDimensionsEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      emit(
        currentState.copyWith(
          weight: event.weight,
          length: event.length,
          width: event.width,
          height: event.height,
        ),
      );
    }
  }

  void _onUpdateVariants(
    UpdateVariantsEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      emit(currentState.copyWith(variants: event.variants));
    }
  }

  void _onAddVariant(AddVariantEvent event, Emitter<AddProductFormState> emit) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      final newVariant = Variant(name: event.variantName);
      final updatedVariants = List<Variant>.from(currentState.variants)
        ..add(newVariant);
      emit(currentState.copyWith(variants: updatedVariants));
    }
  }

  void _onUpdateVariantImage(
    UpdateVariantImageEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      final updatedVariants = List<Variant>.from(currentState.variants);
      if (event.variantIndex < updatedVariants.length) {
        updatedVariants[event.variantIndex] = Variant(
          name: updatedVariants[event.variantIndex].name,
          image: event.imagePath,
          regularPrice: updatedVariants[event.variantIndex].regularPrice,
          salePrice: updatedVariants[event.variantIndex].salePrice,
          quantity: updatedVariants[event.variantIndex].quantity,
        );
        emit(currentState.copyWith(variants: updatedVariants));
      }
    }
  }

  void _onUpdateVariantPrice(
    UpdateVariantPriceEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      final updatedVariants = List<Variant>.from(currentState.variants);
      if (event.variantIndex < updatedVariants.length) {
        updatedVariants[event.variantIndex] = Variant(
          name: updatedVariants[event.variantIndex].name,
          image: updatedVariants[event.variantIndex].image,
          regularPrice: event.regularPrice,
          salePrice: event.salePrice,
          quantity: updatedVariants[event.variantIndex].quantity,
        );
        emit(currentState.copyWith(variants: updatedVariants));
      }
    }
  }

  void _onUpdateVariantQuantity(
    UpdateVariantQuantityEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      final updatedVariants = List<Variant>.from(currentState.variants);
      if (event.variantIndex < updatedVariants.length) {
        updatedVariants[event.variantIndex] = Variant(
          name: updatedVariants[event.variantIndex].name,
          image: updatedVariants[event.variantIndex].image,
          regularPrice: updatedVariants[event.variantIndex].regularPrice,
          salePrice: updatedVariants[event.variantIndex].salePrice,
          quantity: event.quantity,
        );
        emit(currentState.copyWith(variants: updatedVariants));
      }
    }
  }

  void _onAddProductImages(
    AddProductImagesEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      final updatedImages = List<dynamic>.from(currentState.productImages)
        ..addAll(event.imagePaths);
      emit(currentState.copyWith(productImages: updatedImages));
    }
  }

  void _onRemoveProductImage(
    RemoveProductImageEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      final updatedImages = List<dynamic>.from(currentState.productImages);
      if (event.imageIndex < updatedImages.length) {
        updatedImages.removeAt(event.imageIndex);
        emit(currentState.copyWith(productImages: updatedImages));
      }
    }
  }

  void _onAddCategory(
    AddCategoryEvent event,
    Emitter<AddProductFormState> emit,
  ) {
    if (state is AddProductFormUpdated) {
      final currentState = state as AddProductFormUpdated;
      final updatedCategories = List<String>.from(
        currentState.availableCategories,
      )..add(event.category);
      emit(currentState.copyWith(availableCategories: updatedCategories));
    }
  }

  List<Variant> _getDefaultVariantsForCategory(String category) {
    switch (category) {
      case 'dress':
        return [
          const Variant(name: 'S'),
          const Variant(name: 'M'),
          const Variant(name: 'L'),
          const Variant(name: 'XL'),
        ];
      case 'Drinks':
        return [
          const Variant(name: '250l'),
          const Variant(name: '500l'),
          const Variant(name: '1l'),
        ];
      case 'electronics':
        return [
          const Variant(name: 'black'),
          const Variant(name: 'silver'),
          const Variant(name: 'white'),
        ];
      case 'accessories':
        return [const Variant(name: 'small'), const Variant(name: 'large')];
      default:
        return [];
    }
  }
}
