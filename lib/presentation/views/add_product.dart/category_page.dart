import 'package:empire/presentation/views/add_product.dart/add_category.dart';
import 'package:flutter/material.dart';

class CategoryProductScreen extends StatefulWidget {
  const CategoryProductScreen({super.key});

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  // Category IDs (for simplicity using string, you can use enum or int)
  static const String categoryAdd = 'add';
  static const String categoryBreakfast = 'breakfast';
  static const String categoryVegetable = 'vegetable';
  static const String categoryMedicine = 'medicine';
  static const String categoryDrinks = 'drinks';

  // Currently chosen category
  String selectedCategory = categoryBreakfast;

  // Map category to icon and label
  final Map<String, Map<String, dynamic>> categories = {
    categoryBreakfast: {
      'label': 'BreakFast',
      'icon': Icons.free_breakfast,
      'image': 'assets/White tea pot with cup.png',
    },
    categoryVegetable: {
      'label': 'vegetable',
      'icon': Icons.eco,
      'image': 'assets/burlap bags with vegetables.png',
    },
    categoryMedicine: {
      'label': 'Medicine',
      'icon': Icons.medical_services,
      'image': 'assets/blue capsule with granules.png',
    },
    categoryDrinks: {
      'label': 'Drinks',
      'icon': Icons.local_drink,
      'image': 'assets/milkshake.png',
    }
  };

  @override
  Widget build(BuildContext context) {
    // Responsive max width with padding
    final double maxWidth = MediaQuery.of(context).size.width < 450
        ? MediaQuery.of(context).size.width * 0.92
        : 400;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            width: maxWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Back button and title
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 24),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Category/product',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Add_Category();
                        },
                      ));
                    },
                    child: Container(
                      width: 2000,
                      height: 190,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.black38,
                          style: BorderStyle.solid,
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, size: 38, color: Colors.black45),
                          SizedBox(height: 6),
                          Text(
                            'Category',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 14,
                  runSpacing: 14,
                  children: categories.entries.map((entry) {
                    final key = entry.key;
                    final label = entry.value['label'] as String;
                    final iconData = entry.value['icon'] as IconData;

                    final bool isSelected = selectedCategory == key;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = key;
                        });
                      },
                      child: Container(
                        width: 180,
                        height: 130,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.yellow[700] : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(3, 3),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('${entry.value['image']}'),
                            const SizedBox(height: 16),
                            Text(
                              label,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 14,
                                color: isSelected
                                    ? Colors.black87
                                    : Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
