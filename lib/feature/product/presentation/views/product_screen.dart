import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/constants.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/feature/category/presentation/views/add_product.dart/add_product.dart';
import 'package:empire/feature/product/domain/repository/prodcuct_call.dart';
import 'package:empire/feature/product/domain/usecase/productcaliing_usecase.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc.dart';
import 'package:empire/feature/product/presentation/views/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatelessWidget {
  String? mainCategoryId;
  String? subcategory;
  ProductScreen({super.key, this.subcategory, this.mainCategoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColoRs.elevatedButtonColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AddProdutsPage(
                    mainCategoryId: mainCategoryId,
                    id: subcategory,
                  );
                },
              ),
            );
          },
          child: const Text(
            'Add prodcut',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: ColoRs.whiteColor,
              fontFamily: Fonts.raleway,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        title: const Text('', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) =>
            ProductcalingBloc(ProductcaliingUsecase(sl<ProdcuctsRepository>()))
              ..add(
                ProductCallingEvent(
                  mainCategoryId: mainCategoryId!,
                  subCategoryId: subcategory!,
                ),
              ),

        child: SingleChildScrollView(
          reverse: true,
          child: BlocBuilder<ProductcalingBloc, Productstate>(
            builder: (context, state) {
              if (state is ProductError) {
                return Center(child: Text(state.messange));
              }
              if (state is Productfetched) {
                return Container(
                  margin: const EdgeInsets.only(left: 9, right: 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.tune, color: Colors.white),
                              onPressed: () {},
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF3F4F6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      // Brand Icons
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        height: 80,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            const BrandIcon(
                              imageUrl:
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCd8blTYwudo8a3rKCe98fS0gOfP4BHWVHOUls-Wa3EyOJw0w351TbIJXp74WEEYb8EbnJN_c95rs5V8BTUIkDyT8lLzZL9GjToa8Ktn4KK3upnaEhR9ufFzWgkFeIY7re8qzVudLMc4JK_5iKUOh_E0dgXTIISH_lLJZuqWE3m-xMcQLSUNxFuTqFIf3h2My90EvfzyRZMOswnjU3B-ktQP69o764xTSbaGRn2XZSvCeNjn2c7StMGe9OQA7q_O4yO3BYv9Qz1kBw',
                              label: 'Nike',
                              isActive: true,
                            ),
                            const BrandIcon(
                              imageUrl:
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuC04AclBdjz99tsM5kY_6u6pqJDEx9o9jdf6TM_1AgyVAzkUyHo7bh9N0ktcCVgdIuq_Bz6izfJu92EoEobQwaibP2ewyJE-LIqAM0AuIum0hSpaJlNSzf_uUCISZGSKzMssB11PyNtI9O7lAdqMOs6Ykl1PrdVxEqS5zjgXXtclMboSSgEBKu0OY5rFSa_PQZ-JtpAe04IIev8fjqlhFXbJHsbZs8hVyBSLs987LIZe5k48GiCvkywlZDLQY0N0Fwyt4kNnOGSukQ',
                              label: 'Puma',
                            ),
                            const BrandIcon(
                              imageUrl:
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAsH2B69AzShXh-ws4KXXx2xW2qb6y1bR1t7prWq6Yh4GXZZneauX8TojYgCRsY0sRj7UcWUqijHk_tzOF-QJ6CIDyrc7hD508mWTC-O3aQ1BUY2viuhPo5yxp7rFzfO284aybeHCrnmtJHRv-LRPCQzyJ2orPLMaSAJbOWTRBKOeJXkPB54dotd0xFFBQujnyaD9l5_kTr1HUOVpkER7Zkp2G30wNXsMLg3E5TyO-q8btKYDqcnIty59DO_XuQLzh3GF-FX-gPT_0',
                              label: 'Reebok',
                            ),
                            const BrandIcon(
                              imageUrl:
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBwylofnzPRi_Hce_cARd18LV1Pf2apqH8Jtjt9-GucSJ1ToPrTj9N3pdVeIlok3LE_6d4vq-uVFMhXEztnBWm2eduE_yDp9GfxDd5bWQ8X5JjqMeIrcI6TkAKaxU7COTzo0eVG5x9CffcvwkjRZ0GIvMbw5H-6qDY01-Kea552jHmH4TolrVvGQuZHlDUQt-xA3rn0ZIxjOTZRMPrguFYGHm9m5BIm3_W9JNQ0tqHjA7RAWeml7wZ-d4mxWOqffSB7-DBU8Fya090',
                              label: 'Adidas',
                            ),
                            const BrandIcon(
                              imageUrl:
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuA2Ma-j6RJclm274lW5MoOqqT6hF5U5c_PowpYdy_sie80Srtki3ts_HKirkI3rl2JWHFEpjeIBMKbtfaJVs9fEBabFnpLTR_vlIfQrqJIX8DQ1esyxIomLz7ezynDbyHytRZ5h3IXG_n0Xxnia8JZZr2G-wfy5a6ea1vspwNKmhOev5Hop2s_b0SYpEPHv6fNOX0imNU8Hfr3xEyPN5G6J5h8RKsPiyh1C6AWOe9B80bJMj_uazobNSUC3MEhPCVEdCEQ2gtV0yz4',
                              label: 'Fila',
                            ),
                          ],
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'New Product',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      state.products.isEmpty
                          ? const SizedBox()
                          : GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 2.0,
                                    crossAxisSpacing: 1.0,
                                    childAspectRatio: 2,
                                  ),
                              itemCount: state.products.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ProductDetailsPage(
                                            product: state.products[index],
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: ProductCard(
                                    imageUrl:
                                        state.products[index].images.first == []
                                        ? null
                                        : state.products[index].images.first,
                                    title: state.products[index].name,
                                    discount: state
                                        .products[index]
                                        .discountPrice
                                        .toString(),
                                    price: state.products[index].price,
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class BrandIcon extends StatelessWidget {
  final String imageUrl;
  final String label;
  final bool isActive;

  const BrandIcon({
    super.key,
    required this.imageUrl,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? Colors.black : const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Image.network(
              imageUrl,
              height: 24,
              color: isActive ? Colors.white : null,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium!.copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String discount;
  final double price;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.discount,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(5, 5),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Colors.white70,
              offset: Offset(-5, -5),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl == null
                  ? const Icon(Icons.error)
                  : CachedNetworkImage(
                      fit: BoxFit.fill,
                      height: 100,
                      width: 100,
                      placeholder: (BuildContext context, String url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                      imageUrl: imageUrl!,
                    ),
            ),
            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70,
                  child: Text(
                    limitWords(title, 6),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\u0025${discount.toString()}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  "\u{20B9}${price.toString()}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
