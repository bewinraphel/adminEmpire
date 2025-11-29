import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/app_strings.dart';
import 'package:empire/core/utilis/layout_constants.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_gallery_usecase.dart';
import 'package:empire/feature/homepage/presentation/view/home_page.dart';
import 'package:empire/feature/product/domain/usecase/add_product_usecae.dart';
import 'package:empire/feature/product/domain/usecase/adding_brand_usecase.dart';
import 'package:empire/feature/product/domain/usecase/get_brand_usecase.dart';
import 'package:empire/feature/product/domain/usecase/get_default_usecase.dart';
import 'package:empire/feature/product/domain/usecase/vaidate_product_form.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_form_bloc/add_product_form_event.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_form_bloc/add_product_form_bloc.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_form_bloc/add_product_form_state.dart';
import 'package:empire/feature/product/presentation/bloc/varient_image_bloc.dart/vareint_Image_bloc.dart';
import 'package:empire/feature/product/presentation/bloc/brand.dart';
import 'package:empire/feature/product/presentation/bloc/product_image.dart';
import 'package:empire/feature/product/presentation/bloc/varient_image_bloc.dart/vareint_Image_state.dart';
import 'package:empire/feature/product/presentation/bloc/varient_image_bloc.dart/vareint_image_event.dart';
import 'package:empire/feature/product/presentation/views/add_product.dart/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductPageweb extends StatelessWidget {
  final String mainCategoryId;
  final String subcategoryId;
  final String mainCategoryName;
  final String subcategoryName;

  const AddProductPageweb({
    super.key,
    required this.mainCategoryId,
    required this.subcategoryId,
    required this.mainCategoryName,
    required this.subcategoryName,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AddProductFormBloc(
            validateProductFormUseCase: ValidateProductFormUseCase(),
            getDefaultVariantsUseCase: GetDefaultVariantsUseCase(),
            addProductUseCase: sl<AddProductUseCase>(),
          ),
        ),
        BlocProvider(
          create: (_) => ProductImageBloc(
            pickFromCamera: sl<PickImageFromCameraUsecase>(),
            pickFromGallery: sl<PickImageFromGalleryusecase>(),
          ),
        ),
        BlocProvider(
          create: (_) => VariantImageBloc(
            pickImageFromCameraUseCase: sl<PickImageFromCameraUsecase>(),
            pickImageFromGalleryUseCase: sl<PickImageFromGalleryusecase>(),
          ),
        ),

        BlocProvider(
          create: (_) =>
              BrandBloc(sl<AddBrandUseCase>(), sl<GetBrandsUseCase>())..add(
                BrandFetching(
                  mainCategoryId: mainCategoryId,
                  subCategoryId: subcategoryId,
                ),
              ),
        ),
      ],
      child: AddProductPagewebContent(
        mainCategoryId: mainCategoryId,
        subcategoryId: subcategoryId,
        mainCategoryName: mainCategoryName,
        subcategoryName: subcategoryName,
      ),
    );
  }
}

class AddProductPagewebContent extends StatelessWidget {
  final String mainCategoryId;
  final String subcategoryId;
  final String mainCategoryName;
  final String subcategoryName;

  const AddProductPagewebContent({
    super.key,
    required this.mainCategoryId,
    required this.subcategoryId,
    required this.mainCategoryName,
    required this.subcategoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text(AppStrings.addProduct), elevation: 0),
      body: MultiBlocListener(
        listeners: [
          BlocListener<VariantImageBloc, VariantImageState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) => {
              if (state is VariantImagesUpdated)
                {
                  context.read<AddProductFormBloc>().add(
                    UpdateVariantImageEvent(state.variantIndex, state.image),
                  ),
                },
            },
          ),

          BlocListener<AddProductFormBloc, AddProductFormState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: _handleFormStatusChange,
          ),
          BlocListener<ProductImageBloc, ProductImageState>(
            listener: _handleImagePicked,
          ),
        ],
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop =
                constraints.maxWidth > LayoutConstants.desktopBreakpoint;
            return _buildBody(context, constraints, isDesktop);
          },
        ),
      ),
    );
  }

  void _handleFormStatusChange(
    BuildContext context,
    AddProductFormState state,
  ) {
    if (state.status == FormStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.productAddedSuccess),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (_) => false,
      );
    } else if (state.status == FormStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage ?? 'An error occurred'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleImagePicked(BuildContext context, ProductImageState state) {
    if (state is ProductImagePicked && state.targetVariantIndex == null) {
      context.read<AddProductFormBloc>().add(
        AddProductImagesEvent(state.images),
      );
    } else if (state is ProductImagePicked &&
        state.targetVariantIndex != null) {
      context.read<AddProductFormBloc>().add(
        UpdateVariantImageEvent(state.targetVariantIndex!, state.images),
      );
      context.read<ProductImageBloc>().add(
        const ClearTargetVariantIndexEvent(),
      );
    }
  }

  Widget _buildBody(
    BuildContext context,
    BoxConstraints constraints,
    bool isDesktop,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: isDesktop ? 6 : 1,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(constraints.maxWidth * 0.04),
            child: _buildFormContent(context, constraints, isDesktop),
          ),
        ),
        if (isDesktop)
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.all(LayoutConstants.defaultPadding),
              padding: const EdgeInsets.all(LayoutConstants.sectionSpacing),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const ProductImagesSection(),
            ),
          ),
      ],
    );
  }

  Widget _buildFormContent(
    BuildContext context,
    BoxConstraints constraints,
    bool isDesktop,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isDesktop) ...[
          const ProductImagesSection(),
          const SizedBox(height: LayoutConstants.sectionSpacing),
        ],
        const ProductNameField(),
        const SizedBox(height: LayoutConstants.sectionSpacing),
        const ProductDescriptionField(),
        const SizedBox(height: LayoutConstants.sectionSpacing),
        const ProductTagsField(),
        const SizedBox(height: LayoutConstants.sectionSpacing),
        const ProductAvailabilitySwitch(),
        const SizedBox(height: LayoutConstants.sectionSpacing),
        const ProductCategoryDropdown(),
        const SizedBox(height: LayoutConstants.sectionSpacing),
        const ConditionalDimensionsSection(),
        const SizedBox(height: LayoutConstants.sectionSpacing),
        const ProductVariantsSection(),
        const SizedBox(height: LayoutConstants.sectionSpacing),
        const ProductBrandSection(),
        const SizedBox(height: 40),
        SubmitProductButton(
          mainCategoryId: mainCategoryId,
          subcategoryId: subcategoryId,
          mainCategoryName: mainCategoryName,
          subcategoryName: subcategoryName,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
