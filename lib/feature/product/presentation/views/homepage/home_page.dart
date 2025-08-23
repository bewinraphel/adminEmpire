import 'package:empire/feature/product/presentation/views/categories/category_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,

              // BoxShadow for subtle elevation
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  offset: const Offset(0, 4),
                  blurRadius: 18,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hamburger menu
                IconButton(
                  icon: const Icon(Icons.menu, size: 28),
                  onPressed: () {},
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome Admin', // Capitalized
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 18),
                // Search bar
                Container(
                  height: 50,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.black54, size: 22),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'Search for ...',
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Buttons Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 1.1,
                  children: [
                    _DashboardButton(
                      title: 'Category',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return CategoryScreen();
                          },
                        ));
                      },
                    ),
                    _DashboardButton(
                      title: 'Order',
                      onTap: () {},
                    ),
                    _DashboardButton(
                      title: 'Sales',
                      onTap: () {},
                    ),
                    _DashboardButton(
                      title: 'Edit',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable dashboard button widget
class _DashboardButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DashboardButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF2F5F8),
      borderRadius: BorderRadius.circular(20),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.09),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}
