import 'package:flutter/material.dart';
import 'dart:async';
import 'all_products.dart';
import 'coffee_products.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  int _bottomNavIndex = 0;
  int _currentOfferIndex = 0;
  late Timer _offerTimer;

  // Add your offer images here - Replace with your image paths
  final List<String> offerImages = [
    'assets/offer1.png',
    'assets/offer2.png',
    'assets/offer3.png',
    'assets/offer4.png',
  ];

  final List<String> categories = ['ALL', 'Capucino', 'Espresso', 'Latte'];

  final List<Map<String, String>> categoryItems = [
    {'name': 'ALL', 'image': 'assets/all_coffee.png'},
    {'name': 'Capucino', 'image': 'assets/capucino.png'},
    {'name': 'Espresso', 'image': 'assets/espresso.png'},
    {'name': 'Latte', 'image': 'assets/latte.png'},
  ];

  final List<Map<String, dynamic>> menuItems = [
    {'name': 'COOKIES', 'image': 'assets/cookies.png', 'price': '₱89.00'},
    {'name': 'BROWNIES', 'image': 'assets/brownies.png', 'price': '₱119.00'},
    {'name': 'MUFFINS', 'image': 'assets/muffins.png', 'price': '₱89.00'},
    {'name': 'DONUT', 'image': 'assets/donut.png', 'price': '₱119.00'},
    {'name': 'CROISSANTS', 'image': 'assets/croissants.png', 'price': '₱89.00'},
    {'name': 'SCONES', 'image': 'assets/scones.png', 'price': '₱89.00'},
  ];

  final List<Map<String, String>> popularItems = [
    {'name': 'Creamy\nLatte', 'image': 'assets/creamy_latte.png'},
    {'name': 'Cappucino\nLatte', 'image': 'assets/cappucino_latte.png'},
  ];

  @override
  void initState() {
    super.initState();
    // Start auto-scrolling timer for offers
    _offerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentOfferIndex = (_currentOfferIndex + 1) % offerImages.length;
      });
    });
  }

  @override
  void dispose() {
    _offerTimer.cancel();
    super.dispose();
  }

  void _showAllMenuItems(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllProductsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4B896),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              color: const Color(0xFFD4B896),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Menu Title and Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B5344),
                        ),
                      ),
                      // Logo
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.home,
                              color: Color(0xFF6B5344),
                              size: 30,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF6B5344),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Category Buttons
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryItems.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == categoryItems.length - 1 ? 0 : 12,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedCategory = index);
                              // Navigate to COFFEE products when selected
                              if (index == 1) {
                                // Capucino/COFFEE category
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CoffeeProductsScreen(),
                                  ),
                                );
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: _selectedCategory == index
                                        ? const Color(0xFF6B5344)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      categoryItems[index]['image']!,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Center(
                                              child: Icon(
                                                Icons.coffee,
                                                color:
                                                    _selectedCategory == index
                                                    ? Colors.white
                                                    : const Color(0xFF6B5344),
                                                size: 40,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  categoryItems[index]['name']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _selectedCategory == index
                                        ? const Color(0xFF6B5344)
                                        : const Color(0xFF999999),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // Today's Offer - Professional Carousel
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    // Background Image with gradient
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentOfferIndex =
                              (_currentOfferIndex + 1) % offerImages.length;
                        });
                      },
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6B5344),
                          image: DecorationImage(
                            image: AssetImage(offerImages[_currentOfferIndex]),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {},
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF6B5344).withOpacity(0.7),
                                const Color(0xFF8B6F47).withOpacity(0.9),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'TODAY\'S OFFER',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white70,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Free Bottle Of Coffee Latte',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'on all orders above Php.500.000',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white70,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Image.asset(
                                        offerImages[_currentOfferIndex],
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.local_cafe,
                                                size: 60,
                                                color: Colors.white70,
                                              );
                                            },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Slide Indicators at bottom
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          offerImages.length,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() => _currentOfferIndex = index);
                            },
                            child: Container(
                              width: _currentOfferIndex == index ? 24 : 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _currentOfferIndex == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Popular Section with View All
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B5344),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showAllMenuItems(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B5344).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF6B5344),
                          width: 1.5,
                        ),
                      ),
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B5344),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Popular Items Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: popularItems.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          popularItems[index]['image']!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.local_cafe,
                              size: 60,
                              color: const Color(0xFF6B5344).withOpacity(0.5),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          popularItems[index]['name']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B5344),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _bottomNavIndex,
          selectedItemColor: const Color(0xFF6B5344),
          unselectedItemColor: const Color(0xFFAAAAAA),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          iconSize: 24,
          onTap: (index) {
            setState(() => _bottomNavIndex = index);
            if (index == 2) {
              Navigator.pushNamed(context, '/cart');
            } else if (index == 3) {
              Navigator.pushNamed(context, '/profile');
            } else if (index == 1) {
              Navigator.pushNamed(context, '/all_products');
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: _bottomNavIndex == 0 ? 28 : 24),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: _bottomNavIndex == 1 ? 28 : 24),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                size: _bottomNavIndex == 2 ? 28 : 24,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: _bottomNavIndex == 3 ? 28 : 24),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
