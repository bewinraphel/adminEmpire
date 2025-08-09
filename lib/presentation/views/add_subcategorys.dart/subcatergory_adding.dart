import 'dart:io';

import 'package:empire/presentation/bloc/auth/profile_image_bloc.dart';
import 'package:empire/presentation/bloc/category_bloc/adding_subcategory.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCategoryWidget extends StatefulWidget {
  String id;
  AddCategoryWidget({super.key, required this.id});

  @override
  _AddCategoryWidgetState createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Container(
          child: Text(
            'Add New Category',
            style: GoogleFonts.inter(
              color: const Color(0xFF111418),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.015 * 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: BlocListener<SubcategoryBloc, SubcategoryState>(
        listener: (context, state) {
          if (state is AdddedSucess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Category added successfully')),
            );
            Navigator.pop(context);
          } else if (state is ErroAdding) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error adding category')),
            );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWideScreen = constraints.maxWidth > 600;
            final maxWidth = isWideScreen ? 480.0 : constraints.maxWidth * 0.9;

            return SingleChildScrollView(
              child: Container(
                color: const Color(0xFFF7F9FC),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<ImageAuth, ImagePickerState>(
                      builder: (context, state) {
                        if (state is ImagePickedSucess) {
                          _imageFile = File(state.image);
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),

                            Text(
                              'Upload Category Image',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF111418),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.015 * 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFD5DBE2),
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 56, horizontal: 24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_imageFile != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        _imageFile!,
                                        width: 380,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  else
                                    Column(
                                      children: [
                                        Text(
                                          'Upload Image',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF111418),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -0.015 * 18,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Click here to upload an image for the new category.',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF111418),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEAEDF1),
                                      foregroundColor: const Color(0xFF111418),
                                      textStyle: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.015 * 14,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      minimumSize: const Size(84, 40),
                                    ),
                                    onPressed: () {
                                      context
                                          .read<ImageAuth>()
                                          .add(ChooseImagFromCameraeEvent());
                                    },
                                    child: const Text('Upload Image'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Category Details Section
                            Text(
                              'Category Details',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF111418),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.015 * 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Category Name',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF111418),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter category name',
                                      hintStyle: GoogleFonts.inter(
                                        color: const Color(0xFF5D7389),
                                        fontSize: 16,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFEAEDF1),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.all(16),
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
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          'Enter a brief description for the category',
                                      hintStyle: GoogleFonts.inter(
                                        color: const Color(0xFF5D7389),
                                        fontSize: 16,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFEAEDF1),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.all(16),
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
                        );
                      },
                    ),
                    // Create Button
                    Container(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDDE8F3),
                          foregroundColor: const Color(0xFF111418),
                          textStyle: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.015 * 16,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: () async {
                          if (_nameController.text.isNotEmpty &&
                              _imageFile != null) {
                            context.read<SubcategoryBloc>().add(
                                  AddingSubcategory(
                                    _nameController.text,
                                    _descriptionController.text.isNotEmpty
                                        ? _descriptionController.text
                                        : '',
                                    widget.id,
                                    _imageFile!.path,
                                  ),
                                );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please provide a category name and image')),
                            );
                          }
                        },
                        child: const Text('Create Category'),
                      ),
                    ),
                    const SizedBox(height: 20), // Bottom padding
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
