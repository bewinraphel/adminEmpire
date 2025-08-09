 
import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/fonts.dart';
 
import 'package:empire/presentation/views/add_subcategorys.dart/subcatergory_adding.dart';
 
import 'package:flutter/material.dart';
 
import 'package:google_fonts/google_fonts.dart';

class ProductCatalogScreen extends StatelessWidget {
  String id;
  ProductCatalogScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoRs.whiteColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        title: Text(
          'Products',
          style: GoogleFonts.inter(
            color: const Color(0xFF111418),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.015 * 18,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: ColoRs.elevatedButtonColor,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return AddCategoryWidget(
                    id: id,
                  );
                },
              ));
            },
            child: const Text(
              ' Add categroy',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: ColoRs.whiteColor,
                  fontFamily: Fonts.raleway),
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search products',
                  hintStyle: GoogleFonts.inter(
                    color: const Color(0xFF5D7389),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF5D7389),
                    size: 24,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFEAEDF1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Categories',
                style: GoogleFonts.inter(
                  color: const Color(0xFF111418),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.015 * 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
