import 'dart:io';
import 'dart:typed_data';

import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_gallery_usecase.dart';
import 'package:empire/feature/auth/presentation/bloc/profile_image_bloc.dart';
import 'package:empire/feature/category/domain/usecase/categories/adding_subcategory_usecase.dart';
import 'package:empire/feature/category/presentation/bloc/category_bloc/adding_subcategory.dart';
import 'package:empire/feature/category/presentation/views/categories/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCategoryWidget extends StatefulWidget {
  String id;
  AddCategoryWidget({super.key, required this.id});

  @override
  _AddCategoryWidgetState createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  final TextEditingController _CategoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? imageFile;
  dynamic webImageBytes;

  @override
  void dispose() {
    _CategoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SubcategoryBloc>(
          create: (_) => SubcategoryBloc(sl<AddingSubcategoryUsecase>()),
        ),
        BlocProvider<ImageAuth>(
          create: (_) => ImageAuth(
            pickImageFromCameraUsecaseUseCase: sl<PickImageFromCameraUsecase>(),
            pickImageFromGalleryusecaseUseCase:
                sl<PickImageFromGalleryusecase>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Color(0xFF111418),
                  size: 24,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Add New subcategory',
                style: GoogleFonts.inter(
                  color: const Color(0xFF111418),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.015 * 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            body: BlocListener<SubcategoryBloc, SubcategoryState>(
              listener: (context, state) {
                if (state is AdddedSucess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('subcategory added successfully'),
                    ),
                  );
                  Navigator.pop(context);
                  imageFile = null;
                  context.read<ImageAuth>().add(ClearPickedImageEvent());
                  _CategoryController.clear();
                  _descriptionController.clear();
                } else if (state is ErroAdding) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isDeskdop = constraints.maxWidth > 1200;
                  final isWideScreen = constraints.maxWidth > 600;
                  final maxWidth = isWideScreen
                      ? 600.0
                      : constraints.maxWidth * 0.9;

                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsetsGeometry.only(
                        left: isDeskdop
                            ? constraints.maxWidth * 0.30
                            : constraints.maxWidth * 0.12,
                        right: isDeskdop
                            ? constraints.maxWidth * 0.30
                            : constraints.maxWidth * 0.12,
                      ),
                      color: const Color(0xFFF7F9FC),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<ImageAuth, ImagePickerState>(
                            builder: (context, state) {
                              if (state is ImagePickedSuccess) {
                                if (isDeskdop) {
                                  webImageBytes = state.image;
                                } else {
                                  imageFile = state.image;
                                }
                              }

                              return Container(
                                constraints: BoxConstraints(maxWidth: maxWidth),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 16),

                                    const SizedBox(height: 8),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: maxWidth,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xFFD5DBE2),
                                          width: 2,
                                          style: BorderStyle.solid,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 56,
                                        horizontal: 24,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (webImageBytes != null)
                                            buildImagePreview(webImageBytes)
                                          else
                                            Column(
                                              children: [
                                                Text(
                                                  'Upload Image',
                                                  style: GoogleFonts.inter(
                                                    color: const Color(
                                                      0xFF111418,
                                                    ),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: -0.015 * 18,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Click here to upload an image for the new subcategory.',
                                                  style: GoogleFonts.inter(
                                                    color: const Color(
                                                      0xFF111418,
                                                    ),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          const SizedBox(height: 24),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  ColoRs.elevatedButtonColor,
                                              foregroundColor:
                                                  ColoRs.whiteColor,
                                              textStyle: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.015 * 14,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 10,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              minimumSize: const Size(84, 40),
                                            ),
                                            onPressed: () {
                                              context.read<ImageAuth>().add(
                                                ChooseImageFromGalleryEvent(),
                                              );
                                            },
                                            child: const Text('Upload Image'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Catesubcategorygory Details Section
                                    Text(
                                      'subcategory Details',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF111418),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.015 * 18,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: maxWidth,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'subcategory Name',
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF111418),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: _CategoryController,
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Enter subcategory name',
                                              hintStyle: GoogleFonts.inter(
                                                color: const Color(0xFF5D7389),
                                                fontSize: 16,
                                              ),
                                              filled: true,
                                              fillColor: const Color(
                                                0xFFEAEDF1,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide.none,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(16),
                                            ),
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF111418),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: maxWidth,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Brief Description',
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF111418),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: _descriptionController,
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Enter a brief description for the subcategory',
                                              hintStyle: GoogleFonts.inter(
                                                color: const Color(0xFF5D7389),
                                                fontSize: 16,
                                              ),
                                              filled: true,
                                              fillColor: const Color(
                                                0xFFEAEDF1,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide.none,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(16),
                                            ),
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF111418),
                                              fontSize: 16,
                                            ),
                                            maxLines: 4,
                                            minLines: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          // Create Button
                          const SizedBox(height: 20),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final bool isDeskdop =
                                  constraints.maxWidth > 1200;
                              return Container(
                                padding: EdgeInsetsGeometry.only(
                                  left: isDeskdop
                                      ? constraints.maxWidth * 0.37
                                      : 20,
                                  right: isDeskdop
                                      ? constraints.maxWidth * 0.37
                                      : 20,
                                ),

                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColoRs.elevatedButtonColor,
                                    foregroundColor: ColoRs.whiteColor,
                                    textStyle: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.015 * 16,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    minimumSize: const Size(300, 48),
                                  ),
                                  onPressed: () async {
                                    if (_CategoryController.text.isNotEmpty) {
                                      if (kIsWeb) {
                                        context.read<SubcategoryBloc>().add(
                                          AddingSubcategory(
                                            _CategoryController.text,
                                            _descriptionController
                                                    .text
                                                    .isNotEmpty
                                                ? _descriptionController.text
                                                : '',
                                            widget.id,
                                            null,
                                            webImageBytes,
                                          ),
                                        );
                                      } else {
                                        context.read<SubcategoryBloc>().add(
                                          AddingSubcategory(
                                            _CategoryController.text,
                                            _descriptionController
                                                    .text
                                                    .isNotEmpty
                                                ? _descriptionController.text
                                                : '',
                                            widget.id,
                                            imageFile!.path,
                                            null,
                                          ),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please provide a subcategory name and image',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Create subcategory'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class Addingsubcategory extends StatelessWidget {
  Addingsubcategory({
    super.key,
    required this.categoryController,
    required this.imageFile,
    required this.descriptionController,
    required this.widget,
    required this.webimage,
  });

  TextEditingController categoryController;
  dynamic imageFile;
  TextEditingController descriptionController;
  AddCategoryWidget widget;
  Uint8List? webimage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDeskdop = constraints.maxWidth > 1200;
        return Container(
          padding: EdgeInsetsGeometry.only(
            left: isDeskdop ? constraints.maxWidth * 0.37 : 20,
            right: isDeskdop ? constraints.maxWidth * 0.37 : 20,
          ),

          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColoRs.elevatedButtonColor,
              foregroundColor: ColoRs.whiteColor,
              textStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.015 * 16,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(300, 48),
            ),
            onPressed: () async {
              if (categoryController.text.isNotEmpty) {
                if (kIsWeb) {
                  context.read<SubcategoryBloc>().add(
                    AddingSubcategory(
                      categoryController.text,
                      descriptionController.text.isNotEmpty
                          ? descriptionController.text
                          : '',
                      widget.id,
                      null,
                      webimage,
                    ),
                  );
                } else {
                  context.read<SubcategoryBloc>().add(
                    AddingSubcategory(
                      categoryController.text,
                      descriptionController.text.isNotEmpty
                          ? descriptionController.text
                          : '',
                      widget.id,
                      imageFile.path,
                      null,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a category name and image'),
                  ),
                );
              }
            },
            child: const Text('Create Category'),
          ),
        );
      },
    );
  }
}
