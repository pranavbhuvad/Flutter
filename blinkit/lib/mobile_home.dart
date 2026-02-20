import 'package:blinkit/searchfield.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({super.key});

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  int activeIndex = 0;

  final List<String> banners = [
    "assets/banner_img.png",
    "assets/promo1.png",
    "assets/promo2.png",
  ];

  final List<String> products = [
    "assets/products/dairy_products.png",
    "assets/products/drinks_juice.png",
    "assets/products/fruit_veggies.png",
    "assets/products/pan_corner.png",
    "assets/products/breakfast_food.png",
    "assets/products/sweet_tooth.png",
    "assets/products/bakery_biscuit.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= TOP SECTION =================
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Logo + Cart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        Text(
                          "blinkit",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xfff6c800),
                          ),
                        ),
                        Icon(Icons.shopping_cart_outlined),
                      ],
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Delivery in 12 minutes",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const Text(
                      "Pune Railway Station, Pune",
                      style: TextStyle(fontSize: 13),
                    ),

                    const SizedBox(height: 12),

                    /// 🔥 Animated Search Bar
                    BlinkitMobileSearchField(),
                    // Container(
                    //   height: 45,
                    //   padding: const EdgeInsets.symmetric(horizontal: 12),
                    //   decoration: BoxDecoration(
                    //     color: const Color(0xfff1f1f1),
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       const Icon(Icons.search, size: 20),
                    //       const SizedBox(width: 10),
                    //       Expanded(
                    //         child: DefaultTextStyle(
                    //           style: const TextStyle(
                    //             fontSize: 14,
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //           child: AnimatedTextKit(
                    //             repeatForever: true,
                    //             animatedTexts: [
                    //               FadeAnimatedText(
                    //                 'Search "milk"',
                    //                 textStyle:
                    //                     const TextStyle(color: Colors.green),
                    //               ),
                    //               FadeAnimatedText(
                    //                 'Search "chocolate"',
                    //                 textStyle:
                    //                     const TextStyle(color: Colors.orange),
                    //               ),
                    //               FadeAnimatedText(
                    //                 'Search "fruits"',
                    //                 textStyle:
                    //                     const TextStyle(color: Colors.blue),
                    //               ),
                    //               FadeAnimatedText(
                    //                 'Search "snacks"',
                    //                 textStyle:
                    //                     const TextStyle(color: Colors.red),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              /// ================= HERO SLIDER =================
              CarouselSlider.builder(
                itemCount: banners.length,
                options: CarouselOptions(
                  height: 170,
                  viewportFraction: 0.9,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  onPageChanged: (index, reason) {
                    setState(() => activeIndex = index);
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      banners[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: activeIndex,
                  count: banners.length,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 6,
                    dotWidth: 6,
                    activeDotColor: Colors.green,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ================= PROMO ROW =================
              SizedBox(
                height: 130,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        banners[index],
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),

              /// ================= PRODUCTS =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  "Best Sellers",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 200,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 140,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              products[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
