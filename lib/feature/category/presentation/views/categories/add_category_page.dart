import 'dart:io';

import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/commonvalidator.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/core/utilis/widgets.dart';
import 'package:empire/feature/category/domain/usecase/categories/category_image_camera.dart';
import 'package:empire/feature/category/domain/usecase/categories/catgeroyimgae_gallery.dart';

import 'package:empire/feature/category/presentation/bloc/category_bloc/adding_category.dart';
import 'package:empire/feature/category/presentation/bloc/category_bloc/category_image.dart';

import 'package:empire/feature/category/presentation/views/categories/category_page.dart';
import 'package:empire/feature/category/presentation/views/categories/widgets.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class AddCategory extends StatelessWidget {
  AddCategory({super.key});
  TextEditingController category = TextEditingController(
    text: 'Home application',
  );
  TextEditingController description = TextEditingController(
    text: 'This is Home Application category have wide variety product ',
  );
  final GlobalKey<FormState> categorykey = GlobalKey<FormState>();

  dynamic images;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryImageBloc(
        sl<CategoryImageCamera>(),
        sl<CategoryImagegallery>(),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDeskdop = constraints.maxWidth > 1200;
          return Padding(
            padding: EdgeInsetsGeometry.only(
              left: isDeskdop ? constraints.maxWidth * 0.30 : 0,
              right: isDeskdop ? constraints.maxWidth * 0.30 : 0,
            ),
            child: Scaffold(
              bottomNavigationBar:
                  BlocConsumer<AddingcategoryEventBloc, CategoryState>(
                    listener: (context, state) {
                      if (state is CategoryAddedSuceess) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const CategoryScreen();
                            },
                          ),
                          (route) => false,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Category added Successfuly'),
                          ),
                        );
                        context.read<CategoryImageBloc>().add(
                          ClearPickedImageEvent(),
                        );
                        category.clear();
                        description.clear();
                        images = null;
                      }
                    },
                    builder: (context, state) {
                      return state is CategoryAddingloading
                          ? SizedBox(
                              height: 8.h,
                              width: 8.w,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : SizedBox(
                              height: 8.h,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 8.w,
                                  right: 8.w,
                                  bottom: 2.h,
                                ),
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (categorykey.currentState!.validate() &&
                                        images != null) {
                                      if (kIsWeb) {
                                        context
                                            .read<AddingcategoryEventBloc>()
                                            .add(
                                              AddingCategory(
                                                category: category.text,
                                                image: '',
                                                imageBytes: images,
                                                description: description.text,
                                              ),
                                            );
                                      } else {
                                        context
                                            .read<AddingcategoryEventBloc>()
                                            .add(
                                              AddingCategory(
                                                category: category.text,
                                                image: images ?? "",
                                                description: description.text,
                                              ),
                                            );
                                      }
                                    }
                                  },
                                  label: Text(
                                    'Done',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Fonts.raleway,
                                    ),
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Form(
                    key: categorykey,
                    child: Column(
                      children: [
                        BlocBuilder<CategoryImageBloc, ImagePickercategory>(
                          builder: (context, state) {
                            if (state is ImagePickedSuccess) {
                              images = state.image;
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (_) => SafeArea(
                                        child: Wrap(
                                          children: [
                                            ListTile(
                                              leading: const Icon(
                                                Icons.camera_alt,
                                              ),
                                              title: const Text(
                                                'Take a picture',
                                              ),
                                              onTap: () {
                                                context
                                                    .read<CategoryImageBloc>()
                                                    .add(
                                                      CategoryImageFromCameraEvent(),
                                                    );
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                Icons.photo_library,
                                              ),
                                              title: const Text(
                                                'Pick from gallery',
                                              ),
                                              onTap: () {
                                                context
                                                    .read<CategoryImageBloc>()
                                                    .add(
                                                      CategoryImageFromGalleryEvent(),
                                                    );
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: images == null
                                        ? double.infinity
                                        : 200,
                                    decoration: const BoxDecoration(
                                      border: Border(),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(13),
                                      ),
                                      color: Color.fromARGB(139, 223, 227, 233),
                                    ),
                                    child: images == null
                                        ? const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 30),
                                              Icon(
                                                Icons.cloud_upload_outlined,
                                                size: 50,
                                              ),
                                              Text(
                                                'Upload Cover',
                                                style: TextStyle(
                                                  fontFamily:
                                                      Fonts.ralewaySemibold,
                                                ),
                                              ),
                                              SizedBox(height: 6),
                                              Text(
                                                'Click here for upload cover photo',
                                                style: TextStyle(
                                                  fontFamily:
                                                      Fonts.ralewaySemibold,
                                                ),
                                              ),
                                              SizedBox30(),
                                            ],
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                  Radius.circular(13),
                                                ),
                                            child: images == null
                                                ? buildPlaceholder()
                                                : buildImagePreview(images),
                                          ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox20(),

                        ////name//////////////////
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Category',
                            style: TextStyle(
                              fontFamily: Fonts.ralewayBold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox10(),

                        Fields(
                          controller: category,
                          hintText: 'category',
                          validator: (value) => Validators.validateString(
                            value ?? "",
                            "Add category",
                          ),
                        ),

                        const SizedBox20(),

                        const SizedBox20(),
                        const SizedBox20(),

                        ////name//////////////////
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Description',
                            style: TextStyle(
                              fontFamily: Fonts.ralewayBold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox10(),

                        TextFormField(
                          controller: description,

                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.trim().isEmpty || value == 'null') {
                              return 'Please enter description';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 229, 234, 236),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),

                            hintText: 'description',
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox20(),

                        const SizedBox20(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
