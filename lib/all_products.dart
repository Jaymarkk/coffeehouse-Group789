import 'package:flutter/material.dart';
import 'cart_model.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  int _selectedCategory = 0;
  late TextEditingController _searchController;
  List<Map<String, dynamic>> _filteredItems = [];

  final List<String> categories = ['ALL PRODUCTS', 'COFFEE', 'SNACKS'];

  final List<Map<String, String>> categoryItems = [
    {'name': 'All Products', 'image': 'assets/all_coffee.png'},
    {'name': 'COFFEE', 'image': 'assets/coffee.png'},
    {'name': 'SNACKS', 'image': 'assets/snacks.png'},
  ];

  final List<Map<String, dynamic>> menuItems = [
    // SNACKS
    {
      'name': 'COOKIES',
      'image': 'assets/cookies.png',
      'price': '₱89.00',
      'category': 'SNACKS',
      'description': 'Fresh and delicious chocolate chip cookies',
      'ingredients':
          'Flour, Butter, Sugar, Chocolate Chips, Eggs, Vanilla Extract',
      'rating': 4.5,
      'reviews': 128,
    },
    {
      'name': 'BROWNIES',
      'image': 'assets/brownies.png',
      'price': '₱119.00',
      'category': 'SNACKS',
      'description': 'Rich and fudgy chocolate brownies',
      'ingredients': 'Cocoa Powder, Butter, Sugar, Eggs, Flour, Dark Chocolate',
      'rating': 4.8,
      'reviews': 156,
    },
    {
      'name': 'MUFFINS',
      'image': 'assets/muffins.png',
      'price': '₱89.00',
      'category': 'SNACKS',
      'description': 'Soft and fluffy blueberry muffins',
      'ingredients': 'Flour, Blueberries, Sugar, Eggs, Milk, Baking Powder',
      'rating': 4.3,
      'reviews': 95,
    },
    {
      'name': 'DONUT',
      'image': 'assets/donut.png',
      'price': '₱119.00',
      'category': 'SNACKS',
      'description': 'Glazed donuts with a light and airy texture',
      'ingredients': 'Flour, Sugar, Eggs, Milk, Yeast, Vegetable Oil, Glaze',
      'rating': 4.6,
      'reviews': 142,
    },
    {
      'name': 'CROISSANTS',
      'image': 'assets/croissants.png',
      'price': '₱89.00',
      'category': 'SNACKS',
      'description': 'Buttery and layered French croissants',
      'ingredients': 'Flour, Butter, Sugar, Salt, Yeast, Water',
      'rating': 4.7,
      'reviews': 167,
    },
    {
      'name': 'SCONES',
      'image': 'assets/scones.png',
      'price': '₱89.00',
      'category': 'SNACKS',
      'description': 'Traditional cream scones perfect for tea time',
      'ingredients': 'Flour, Butter, Sugar, Eggs, Cream, Baking Powder',
      'rating': 4.4,
      'reviews': 118,
    },
    // COFFEE
    {
      'name': 'ESPRESSO',
      'image': 'assets/espresso.png',
      'price': '₱99.00',
      'category': 'COFFEE',
      'description': 'Strong and bold espresso shot',
      'ingredients': 'Premium Arabica Beans, Hot Water',
      'rating': 4.9,
      'reviews': 284,
    },
    {
      'name': 'LATTE',
      'image': 'assets/latte.png',
      'price': '₱150.00',
      'category': 'COFFEE',
      'description': 'Creamy latte with smooth milk texture',
      'ingredients': 'Espresso, Steamed Milk, Milk Foam',
      'rating': 4.7,
      'reviews': 312,
    },
    {
      'name': 'CAFFE MACCHIATO',
      'image': 'assets/caffe_macchiato.png',
      'price': '₱150.00',
      'category': 'COFFEE',
      'description': 'Espresso marked with a small amount of foam',
      'ingredients': 'Espresso, Steamed Milk, Milk Foam',
      'rating': 4.6,
      'reviews': 201,
    },
    {
      'name': 'AMERICANO',
      'image': 'assets/americano.png',
      'price': '₱150.00',
      'category': 'COFFEE',
      'description': 'Smooth espresso diluted with hot water',
      'ingredients': 'Espresso, Hot Water',
      'rating': 4.5,
      'reviews': 276,
    },
    {
      'name': 'CORTADO',
      'image': 'assets/cortado.png',
      'price': '₱119.00',
      'category': 'COFFEE',
      'description': 'Perfect balance of espresso and steamed milk',
      'ingredients': 'Espresso, Steamed Milk',
      'rating': 4.6,
      'reviews': 189,
    },
    {
      'name': 'MOCHA',
      'image': 'assets/mocha.png',
      'price': '₱155.00',
      'category': 'COFFEE',
      'description': 'Delicious blend of espresso, chocolate, and milk',
      'ingredients': 'Espresso, Steamed Milk, Chocolate, Whipped Cream',
      'rating': 4.8,
      'reviews': 298,
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = menuItems;
    _filterByCategory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterByCategory() {
    if (_selectedCategory == 0) {
      // All Products
      _filteredItems = menuItems;
    } else if (_selectedCategory == 1) {
      // COFFEE
      _filteredItems = menuItems
          .where((item) => item['category'] == 'COFFEE')
          .toList();
    } else if (_selectedCategory == 2) {
      // SNACKS
      _filteredItems = menuItems
          .where((item) => item['category'] == 'SNACKS')
          .toList();
    }
  }

  void _filterSearchResults(String query) {
    _filterByCategory();
    if (query.isNotEmpty) {
      _filteredItems = _filteredItems
          .where(
            (item) => item['name'].toString().toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
    }
    setState(() {});
  }

  void _showProductDetails(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailModal(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4B896),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4B896),
        elevation: 0,
        leading: Container(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF6B5344),
              size: 28,
            ),
          ),
        ),
        title: const Text(
          'COFFEE',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B5344),
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/cart'),
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                child: const Icon(
                  Icons.shopping_cart,
                  color: Color(0xFF6B5344),
                  size: 26,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding for header content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Icon(Icons.search, color: Color(0xFF6B5344)),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterSearchResults,
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4B896),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: Color(0xFF6B5344),
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Category Buttons
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryItems.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == categoryItems.length - 1 ? 0 : 16,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = index;
                                _filterByCategory();
                                _searchController.clear();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedCategory == index
                                    ? const Color(0xFF6B5344)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: _selectedCategory != index
                                    ? Border.all(
                                        color: Colors.white.withOpacity(0.5),
                                      )
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  categoryItems[index]['name']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _selectedCategory == index
                                        ? Colors.white
                                        : const Color(0xFF6B5344),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Menu Items Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showProductDetails(_filteredItems[index]),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF0E6),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Product Image
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                _filteredItems[index]['image']!,
                                width: 90,
                                height: 90,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.coffee,
                                    size: 60,
                                    color: const Color(
                                      0xFF6B5344,
                                    ).withOpacity(0.5),
                                  );
                                },
                              ),
                            ),
                          ),
                          // Product Info
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                              bottom: 12,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _filteredItems[index]['name']!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF999999),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _filteredItems[index]['price']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6B5344),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class ProductDetailModal extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailModal({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailModal> createState() => _ProductDetailModalState();
}

class _ProductDetailModalState extends State<ProductDetailModal> {
  int quantity = 1;

  void _addToCart() {
    CartManager().addItem(widget.product, quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.product['name']} x$quantity added to cart!',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6B5344),
        duration: const Duration(seconds: 1),
      ),
    );
    Navigator.pop(context);
    Navigator.pushNamed(context, '/cart');
  }

  void _buyNow() {
    CartManager().addItem(widget.product, quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Proceeding to checkout with ${widget.product['name']} x$quantity',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6B5344),
        duration: const Duration(seconds: 1),
      ),
    );
    Navigator.pop(context);
    Navigator.pushNamed(context, '/checkout');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4B896),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFF6B5344),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Product Image
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF0E6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    widget.product['image']!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.coffee,
                        size: 100,
                        color: const Color(0xFF6B5344).withOpacity(0.5),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Product Name
              Text(
                widget.product['name']!,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B5344),
                ),
              ),
              const SizedBox(height: 12),
              // Rating and Reviews
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.product['rating']} (${widget.product['reviews']} reviews)',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Price
              Text(
                widget.product['price']!,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B5344),
                ),
              ),
              const SizedBox(height: 20),
              // Description
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B5344),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.product['description']!,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Color(0xFF999999),
                ),
              ),
              const SizedBox(height: 20),
              // Ingredients
              const Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B5344),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF0E6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.product['ingredients']!,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Color(0xFF999999),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Quantity Selector
              Row(
                children: [
                  const Text(
                    'Quantity:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B5344),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (quantity > 1) quantity--;
                      });
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF6B5344),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          '-',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B5344),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 50,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF0E6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        quantity.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B5344),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF6B5344),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          '+',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B5344),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _addToCart,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF6B5344),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6B5344),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: _buyNow,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6B5344),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Buy Now',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
