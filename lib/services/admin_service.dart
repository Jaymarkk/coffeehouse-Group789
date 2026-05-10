// Admin Service - Singleton for managing admin data and statistics
class AdminService {
  static final AdminService _instance = AdminService._internal();

  factory AdminService() {
    return _instance;
  }

  AdminService._internal();

  // Admin credentials
  String adminEmail = 'admin@coffeehouse.com';
  String adminPassword = 'admin123';

  // Statistics
  int totalOrders = 0;
  int totalUsers = 0;
  int totalLogins = 0;
  double totalRevenue = 0.0;

  // Products Inventory - All products from the app
  List<Map<String, dynamic>> products = [
    // COFFEE PRODUCTS
    {
      'id': '1',
      'name': 'Espresso',
      'category': 'Coffee',
      'price': 99.00,
      'stock': 67,
      'image': '☕',
      'sales': 0,
    },
    {
      'id': '2',
      'name': 'Latte',
      'category': 'Coffee',
      'price': 150.00,
      'stock': 52,
      'image': '☕',
      'sales': 0,
    },
    {
      'id': '3',
      'name': 'Caffe Macchiato',
      'category': 'Coffee',
      'price': 150.00,
      'stock': 45,
      'image': '☕',
      'sales': 0,
    },
    {
      'id': '4',
      'name': 'Americano',
      'category': 'Coffee',
      'price': 150.00,
      'stock': 55,
      'image': '☕',
      'sales': 0,
    },
    {
      'id': '5',
      'name': 'Cortado',
      'category': 'Coffee',
      'price': 119.00,
      'stock': 48,
      'image': '☕',
      'sales': 0,
    },
    {
      'id': '6',
      'name': 'Mocha',
      'category': 'Coffee',
      'price': 155.00,
      'stock': 50,
      'image': '☕',
      'sales': 0,
    },
    // SNACKS
    {
      'id': '7',
      'name': 'Cookies',
      'category': 'Snacks',
      'price': 89.00,
      'stock': 75,
      'image': '🍪',
      'sales': 0,
    },
    {
      'id': '8',
      'name': 'Brownies',
      'category': 'Snacks',
      'price': 119.00,
      'stock': 62,
      'image': '🧁',
      'sales': 0,
    },
    {
      'id': '9',
      'name': 'Muffins',
      'category': 'Snacks',
      'price': 89.00,
      'stock': 58,
      'image': '🧁',
      'sales': 0,
    },
    {
      'id': '10',
      'name': 'Donut',
      'category': 'Snacks',
      'price': 119.00,
      'stock': 70,
      'image': '🍩',
      'sales': 0,
    },
    {
      'id': '11',
      'name': 'Croissants',
      'category': 'Snacks',
      'price': 89.00,
      'stock': 48,
      'image': '🥐',
      'sales': 0,
    },
    {
      'id': '12',
      'name': 'Scones',
      'category': 'Snacks',
      'price': 89.00,
      'stock': 54,
      'image': '🧁',
      'sales': 0,
    },
  ];

  // Verify admin login
  bool verifyAdminLogin(String email, String password) {
    return email == adminEmail && password == adminPassword;
  }

  // Get statistics
  Map<String, dynamic> getStatistics() {
    double avgOrderValue = totalRevenue / (totalOrders > 0 ? totalOrders : 1);
    int lowStockItems = products.where((p) => (p['stock'] as int) < 20).length;
    int totalProducts = products.length;
    String topProduct = products.isNotEmpty
        ? products.reduce(
                (a, b) => (a['sales'] as int) > (b['sales'] as int) ? a : b,
              )['id']
              as String
        : '0';

    return {
      'totalOrders': totalOrders,
      'totalUsers': totalUsers,
      'totalLogins': totalLogins,
      'totalRevenue': totalRevenue,
      'totalProducts': totalProducts,
      'avgOrderValue': avgOrderValue,
      'lowStockItems': lowStockItems,
      'topProduct': topProduct,
    };
  }

  // Update product stock
  void updateProductStock(String productId, int newStock) {
    final index = products.indexWhere((p) => p['id'] == productId);
    if (index != -1) {
      products[index]['stock'] = newStock;
    }
  }

  // Update product price
  void updateProductPrice(String productId, double newPrice) {
    final index = products.indexWhere((p) => p['id'] == productId);
    if (index != -1) {
      products[index]['price'] = newPrice;
    }
  }

  // Add new product
  void addProduct({
    required String name,
    required String category,
    required double price,
    required int stock,
    required String image,
  }) {
    products.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
      'image': image,
      'sales': 0,
    });
  }

  // Delete product
  void deleteProduct(String productId) {
    products.removeWhere((p) => p['id'] == productId);
  }

  // Update statistics
  void recordOrder() {
    totalOrders++;
  }

  void recordUserSignup() {
    totalUsers++;
  }

  void recordUserLogin() {
    totalLogins++;
    totalUsers++;
  }

  void updateRevenue(double amount) {
    totalRevenue += amount;
  }
}
