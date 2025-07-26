// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:empire/core/utilis/commonvalidator.dart';
import 'package:empire/core/utilis/fonts.dart';

import 'package:empire/core/utilis/widgets.dart';
import 'package:empire/presentation/views/homepage/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final ValueNotifier<String?> image = ValueNotifier(null);

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final globalKey = GlobalKey<FormState>();

  final stepskey = GlobalKey<FormState>();
  final categoryKey = GlobalKey<FormState>();

  final foodName = TextEditingController();
  final categorycontroller = TextEditingController();
  final descriptionName = TextEditingController();
  final timeToCook = TextEditingController();
  final itemName = TextEditingController();
  final itemquantity = TextEditingController();
  final selectCuisence = TextEditingController();
  final addSteps = TextEditingController();
  final star = TextEditingController();
  ValueNotifier<double> ratingvalue = ValueNotifier(0.0);

  final ValueNotifier<String> category = ValueNotifier<String>('');
  List<dynamic> stepdAdding = [];
  List<dynamic> steps = [];
  List<dynamic> varients = ['200ml', '1l'];
  List<dynamic> categoryList = ['dress', 'food'];
  Map<TextEditingController, TextEditingController> listofStep = {};
  @override
  void dispose() {
    image.value = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ImageUpload(),
                const SizedBox20(),

                ////name//////////////////

                const Titles(
                  nametitle: 'Name',
                ),
                const SizedBox10(),

                Fields(
                    controller: foodName,
                    hintText: 'name',
                    validator: (value) =>
                        Validators.validateStrting(value ?? "", "food name")),
                const SizedBox20(),

                /////Description//////////////////////////
                const Titles(
                  nametitle: 'Description',
                ),
                const SizedBox20(),
                Fields(
                    controller: descriptionName,
                    hintText: 'Description',
                    validator: (value) =>
                        Validators.validateStrting(value ?? "", "Description")),
                const SizedBox20(),

                /////Time To Cook'////////////////
                const Titles(
                  nametitle: 'Rate',
                ),
                const SizedBox10(),
                Fields(
                    controller: timeToCook,
                    hintText: 'Time',
                    validator: (value) =>
                        Validators.validateStrting(value ?? "", "Rate")),
                const SizedBox20(),
                /////Select Cuisine/////////////
                const Titles(
                  nametitle: 'Category ',
                ),
                const SizedBox10(),
                category_list(),
                ///////star///////////////
                const SizedBox20(),

                /////Sub Ingredients//////////////
                const Titles(
                  nametitle: 'Varients',
                ),
                const SizedBox10(),
                vatients_list(),
                const SizedBox20(),

                const SizedBox20(),

                ///////Steps//////////////////
                const SizedBox20(),

                const SizedBox10(),

                const SizedBox20(),
                //////doneButton/////////////

                doneButton(context),
                const SizedBox20(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputField Time() {
    return InputField(
      controller: timeToCook,
      hintText: 'Time',
      validator: (value) => Validators.validateUsername(value ?? ''),
    );
  }

  InputField description() {
    return InputField(
      controller: descriptionName,
      hintText: 'Description',
      validator: (value) => Validators.validateUsername(value ?? ''),
    );
  }

  // InputField itemname() {
  //   return Fields(foodName: foodName);
  // }

  Center doneButton(BuildContext context) {
    return Center(
      child: GreenElevatedButton(
        height: 50,
        width: 300,
        text: 'Done',
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          ));
        },
      ),
    );
  }

  Row category_list() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            height: 40,
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: const Color.fromARGB(255, 229, 234, 236)),
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: Center(
                  child: Text(categoryList[0]),
                ),
              ),
            )),
        const SizedBox(
          width: 2,
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border:
                  Border.all(color: const Color.fromARGB(255, 201, 206, 207))),
          child: IconButton(
            alignment: Alignment.center,
            color: const Color.fromARGB(255, 108, 111, 112),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            const Titles(
                              nametitle: 'category',
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              height: 200,
                              width: MediaQuery.of(context).size.width - 30,
                              child: GridView.builder(
                                itemCount: categoryList.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 9,
                                  crossAxisSpacing: 5,
                                  childAspectRatio: 2.0,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // AddRecipesControllers()
                                          //     .removecategory(
                                          //         listofCategory[
                                          //                 index]
                                          //             .id!);
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 4),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            color: Color.fromARGB(
                                                255, 229, 234, 236),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(11.0),
                                              child: Text(
                                                categoryList[0],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Top-right close icon
                                      Positioned(
                                        top: -8,
                                        right: -5,
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,

                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              // White background for better visibility
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.black,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            const SizedBox(height: 30),
                            Form(
                              key: categoryKey,
                              child: InputField(
                                controller: categorycontroller,
                                hintText: ' addd Category',
                                validator: (value) =>
                                    Validators.validateStrting(
                                        value ?? 'null', 'category'),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GreenElevatedButton(
                            text: 'Add Cuisine',
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ),
      ],
    );
  }

  Row vatients_list() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            height: 40,
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: const Color.fromARGB(255, 229, 234, 236)),
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: Center(
                  child: Text(varients[0]),
                ),
              ),
            )),
        const SizedBox(
          width: 2,
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border:
                  Border.all(color: const Color.fromARGB(255, 201, 206, 207))),
          child: IconButton(
            alignment: Alignment.center,
            color: const Color.fromARGB(255, 108, 111, 112),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            const Titles(
                              nametitle: 'varients',
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              height: 200,
                              width: MediaQuery.of(context).size.width - 30,
                              child: GridView.builder(
                                itemCount: varients.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 9,
                                  crossAxisSpacing: 5,
                                  childAspectRatio: 2.0,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 4),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            color: Color.fromARGB(
                                                255, 229, 234, 236),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(11.0),
                                              child: Text(
                                                varients[0],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Top-right close icon
                                      Positioned(
                                        top: -8,
                                        right: -5,
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,

                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              // White background for better visibility
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.black,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            const SizedBox(height: 30),
                            Form(
                              key: categoryKey,
                              child: InputField(
                                controller: categorycontroller,
                                hintText: ' addd varients',
                                validator: (value) =>
                                    Validators.validateStrting(
                                        value ?? 'null', 'varients'),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GreenElevatedButton(
                            text: 'Add varients',
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ),
      ],
    );
  }

  AppBar appbar() {
    return AppBar(
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.white,
      title: const Text(
        'Add product',
      ),
      centerTitle: true,
    );
  }
}

class Fields extends StatefulWidget {
  const Fields({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;
  @override
  State<Fields> createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  @override
  Widget build(BuildContext context) {
    return InputField(
      controller: widget.controller,
      hintText: widget.hintText,
      validator: widget.validator,
    );
  }
}

class ImageUpload extends StatefulWidget {
  const ImageUpload({
    super.key,
  });

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: image,
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () async {},
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
                border: Border(),
                borderRadius: BorderRadius.all(Radius.circular(13)),
                color: Color.fromARGB(139, 223, 227, 233)),
            child: image.value == null
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
                        style: TextStyle(fontFamily: Fonts.ralewaySemibold),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        'Click here for upload cover photo',
                        style: TextStyle(fontFamily: Fonts.ralewaySemibold),
                      )
                    ],
                  )
                : ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(13)),
                    child: image == 'assets/images/default.jpg'
                        ? Image.asset(
                            image.value.toString(),
                            fit: BoxFit.cover,
                          )
                        : kIsWeb
                            ? Image.network(image.value.toString())
                            : Image.file(
                                File(image.value.toString()),
                                fit: BoxFit.cover,
                              ),
                  ),
          ),
        );
      },
    );
  }
}
