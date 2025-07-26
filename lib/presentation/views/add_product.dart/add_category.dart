import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/core/utilis/commonvalidator.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/core/utilis/widgets.dart';
import 'package:empire/presentation/bloc/auth/profile_image.dart';
import 'package:empire/presentation/views/add_product.dart/add_product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Add_Category extends StatelessWidget {
  Add_Category({super.key});
  TextEditingController category = TextEditingController();

  String? images;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              onPressed: () async {
                await addCategoryToFirestore(category, images);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return AddPage();
                  },
                ));
              },
              label: const Text(
                'Done',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: Fonts.raleway),
              )),
        ),
      ),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ImageAuth, ImagePickerState>(
                builder: (context, state) {
                  if (state is ImagePickedSucess) {
                    images = state.image;
                  }
                  return GestureDetector(
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
                                  context
                                      .read<ImageAuth>()
                                      .add(ChooseImagFromCameraeEvent());
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text('Pick from gallery'),
                                onTap: () {
                                  context
                                      .read<ImageAuth>()
                                      .add(ChooseImagFromGalleryEvent());
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          border: Border(),
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                          color: Color.fromARGB(139, 223, 227, 233)),
                      child: images == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 50,
                                ),
                                Text(
                                  'Upload Cover',
                                  style: TextStyle(
                                      fontFamily: Fonts.ralewaySemibold),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  'Click here for upload cover photo',
                                  style: TextStyle(
                                      fontFamily: Fonts.ralewaySemibold),
                                )
                              ],
                            )
                          : ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(13)),
                              child: images == 'assets/images/default.jpg'
                                  ? Image.asset(
                                      images.toString(),
                                      fit: BoxFit.cover,
                                    )
                                  : kIsWeb
                                      ? Image.network(images.toString())
                                      : Image.file(
                                          File(images.toString()),
                                          fit: BoxFit.cover,
                                        ),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox20(),

              ////name//////////////////

              const Titles(
                nametitle: 'category',
              ),
              const SizedBox10(),

              Fields(
                  controller: category,
                  hintText: 'category',
                  validator: (value) =>
                      Validators.validateStrting(value ?? "", "Add category")),
              const SizedBox20(),

              const SizedBox20(),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> addCategoryToFirestore(
    TextEditingController category, String? imges) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    // You could generate your own ID or use auto-id
    await firestore.collection('category').add({
      'name': category.text,
      'imgae': imges,
      'createdAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print(e);
  }
}
