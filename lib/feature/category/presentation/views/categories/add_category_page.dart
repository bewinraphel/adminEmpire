import 'dart:io';

import 'package:empire/core/utilis/commonvalidator.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/core/utilis/widgets.dart';

import 'package:empire/feature/category/presentation/bloc/category_bloc/adding_category.dart';
import 'package:empire/feature/category/presentation/bloc/category_bloc/category_image.dart';

import 'package:empire/feature/category/presentation/views/categories/category_page.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCategory extends StatelessWidget {
  AddCategory({super.key});
  TextEditingController category = TextEditingController();
  TextEditingController description = TextEditingController();
  final GlobalKey<FormState> categorykey = GlobalKey<FormState>();

  String? images;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocConsumer<AddingcategoryEventBloc, CategoryState>(
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
              const SnackBar(content: Text('Category added Successfuly')),
            );
            context.read<CategoryImageBloc>().add(ClearPickedImageEvent());
            category.clear();
            description.clear();
            images = null;
          }
        },
        builder: (context, state) {
          return state is CategoryAddingloading
              ? const SizedBox(
                  height: 60,
                  width: 30,
                  child: Center(child: CircularProgressIndicator()),
                )
              : SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      bottom: 20,
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onPressed: () async {
                        if (categorykey.currentState!.validate() &&
                            images != null) {
                          context.read<AddingcategoryEventBloc>().add(
                            AddingCategory(
                              category: category.text,
                              image: images ?? "",
                              description: description.text,
                            ),
                          );
                        }
                      },
                      label: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
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
          padding: const EdgeInsets.all(24.0),
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
                                      leading: const Icon(Icons.camera_alt),
                                      title: const Text('Take a picture'),
                                      onTap: () {
                                        context.read<CategoryImageBloc>().add(
                                          CategoryImageFromCameraEvent(),
                                        );
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo_library),
                                      title: const Text('Pick from gallery'),
                                      onTap: () {
                                        context.read<CategoryImageBloc>().add(
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
                            width: images == null ? double.infinity : 200,
                            decoration: const BoxDecoration(
                              border: Border(),
                              borderRadius: BorderRadius.all(
                                Radius.circular(13),
                              ),
                              color: Color.fromARGB(139, 223, 227, 233),
                            ),
                            child: images == null
                                ? const Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                          fontFamily: Fonts.ralewaySemibold,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Click here for upload cover photo',
                                        style: TextStyle(
                                          fontFamily: Fonts.ralewaySemibold,
                                        ),
                                      ),
                                      SizedBox30(),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(13),
                                    ),
                                    child: images == 'assets/images/default.jpg'
                                        ? Image.asset(
                                            images.toString(),
                                            fit: BoxFit.cover,
                                            height: 200,
                                            width: 300,
                                          )
                                        : kIsWeb
                                        ? Image.network(images.toString())
                                        : Image.file(
                                            File(images.toString()),
                                            fit: BoxFit.cover,
                                          ),
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
                  validator: (value) =>
                      Validators.validateString(value ?? "", "Add category"),
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
    );
  }
}
