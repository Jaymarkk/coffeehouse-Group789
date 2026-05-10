import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../cart_model.dart';

class DatabaseService {
  static DatabaseService? _instance;
  factory DatabaseService() => _instance ??= DatabaseService._internal();
  DatabaseService._internal();

  // Mock data stores
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _orders = [];
  List<Map<String, dynamic>> _profiles = [];
  List<Map<String, dynamic>> _wallets = [];
  List<Map<String, dynamic>> _favorites = [];
  List<Map<String, dynamic>> _reviews = [];

  static const String _productsKey = 'mock_products';
  static const String _ordersKey = 'mock_orders';
  static const String _profilesKey = 'mock_profiles';
  static const String _walletsKey = 'mock_wallets';
  static const String _favoritesKey = 'mock_favorites';
  static const String _reviewsKey = 'mock_reviews';

  Future<void> _init() async {
    await _loadMockData();
    _initMockProducts();
  }

  List<Map<String, dynamic>> _loadList(SharedPreferences prefs, String key) {
    final jsonList = prefs.getStringList(key) ?? [];
    return jsonList
        .map((json) => Map<String, dynamic>.from(jsonDecode(json)))
        .toList();
  }

  Future<void> _saveList(String key, List<Map<String, dynamic>> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList(key, jsonList);
  }

  Future<void> _loadMockData() async {
    final prefs = await SharedPreferences.getInstance();
    _products = _loadList(prefs, _productsKey);
    _orders = _loadList(prefs, _ordersKey);
    _profiles = _loadList(prefs, _profilesKey);
    _wallets = _loadList(prefs, _walletsKey);
    _favorites = _loadList(prefs, _favoritesKey);
    _reviews = _loadList(prefs, _reviewsKey);
  }

  void _initMockProducts() {
    if (_products.isEmpty) {
      _products = [
        {
          'id': '1',
          'name': 'Cappuccino',
          'price': 250.0,
          'stock': 45,
          'category': 'Coffee',
          'is_available': true,
        },
        {
          'id': '2',
          'name': 'Espresso',
          'price': 150.0,
          'stock': 67,
          'category': 'Coffee',
          'is_available': true,
        },
        {
          'id': '3',
          'name': 'Latte',
          'price': 280.0,
          'stock': 52,
          'category': 'Coffee',
          'is_available': true,
        },
        {
          'id': '4',
          'name': 'Croissant',
          'price': 150.0,
          'stock': 34,
          'category': 'Pastry',
          'is_available': true,
        },
        {
          'id': '5',
          'name': 'Muffin',
          'price': 180.0,
          'stock': 28,
          'category': 'Pastry',
          'is_available': true,
        },
      ];
      _saveList(_productsKey, _products);
    }
  }

  // Profiles
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    await _loadMockData();
    return {
      'id': 'user_1',
      'first_name': 'Coffee',
      'last_name': 'Enthusiast',
      'email': 'user@coffeehouse.com',
      'phone_number': '+63 912 345 6789',
    };
  }

  Future<void> createUserProfile({
    required String userId,
    required String firstName,
    required String lastName,
    String? middleName,
    String? phoneNumber,
  }) async {
    await _loadMockData();
    final profile = {
      'id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'middle_name': middleName,
      'phone_number': phoneNumber,
      'is_admin': false,
    };
    _profiles.add(profile);
    await _saveList(_profilesKey, _profiles);
  }

  Future<void> updateUserProfile({
    required String userId,
    String? firstName,
    String? lastName,
  }) async {
    await _loadMockData();
    final index = _profiles.indexWhere((p) => p['id'] == userId);
    if (index != -1) {
      if (firstName != null) _profiles[index]['first_name'] = firstName;
      if (lastName != null) _profiles[index]['last_name'] = lastName;
      await _saveList(_profilesKey, _profiles);
    }
  }

  // Products
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    await _loadMockData();
    return List.from(_products.where((p) => p['is_available'] == true));
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(
    String category,
  ) async {
    await _loadMockData();
    return List.from(_products.where((p) => p['category'] == category));
  }

  Future<Map<String, dynamic>?> getProductById(String id) async {
    await _loadMockData();
    try {
      return _products.firstWhere((p) => p['id'] == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    await _loadMockData();
    return List.from(
      _products.where(
        (p) => p['name'].toString().toLowerCase().contains(query.toLowerCase()),
      ),
    );
  }

  // Orders
  Future<String?> createOrder({
    required List<CartItem> items,
    required String paymentMethod,
    required String shippingAddress,
  }) async {
    await _loadMockData();
    double totalAmount = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final now = DateTime.now();
    final orderId = now.millisecondsSinceEpoch.toString();
    final orderNumber =
        'ORD-${(now.millisecondsSinceEpoch ~/ 1000).toString().substring(6)}';
    final dateStr = _formatDate(now);
    final estimatedDelivery = now.add(
      Duration(days: 1 + (now.millisecond % 3)),
    ); // 1-3 days random
    final estDateStr = _formatDate(estimatedDelivery);

    final itemsList = items
        .map(
          (item) => {
            'name': item.name,
            'image': item.image,
            'quantity': item.quantity,
            'price': double.parse(
              item.price.replaceAll('₱', '').replaceAll(',', ''),
            ),
          },
        )
        .toList();

    final order = {
      'id': orderId,
      'user_id': 'mock_user',
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'delivery_type': 'delivery',
      'shipping_address': shippingAddress,
      'order_status': 'pending',
      'order_number': orderNumber,
      'date': dateStr,
      'estimated_delivery_date': estDateStr,
      'actual_delivery_date': null,
      'items': itemsList,
      'statusColor': 'orange',
      'origin_address': 'Coffee House Main Branch',
      'destination_address': shippingAddress,
    };
    _orders.add(order);
    await _saveList(_ordersKey, _orders);
    return order['id'] as String?;
  }

  Future<List<Map<String, dynamic>>> getUserOrders() async {
    await _loadMockData();
    final rawOrders = List.from(
      _orders.where((o) => o['user_id'] == 'mock_user'),
    );
    return rawOrders
        .map(
          (order) => {
            'orderID': order['order_number'],
            'date': order['date'] ?? _formatDate(DateTime.now()),
            'estimated_delivery_date':
                order['estimated_delivery_date'] ?? 'N/A',
            'actual_delivery_date': order['actual_delivery_date'] ?? null,
            'estimatedTime': order['estimated_delivery_date'] ?? 'N/A',
            'actualTime': order['actual_delivery_date'] ?? null,
            'items': order['items'] ?? [],
            'total': order['total_amount'],
            'status': _getStatus(order['order_status']),
            'statusColor': order['statusColor'] ?? 'orange',
            'origin_address': order['origin_address'] ?? 'N/A',
            'destination_address':
                order['destination_address'] ??
                order['shipping_address'] ??
                'N/A',
            'address': order['shipping_address'] ?? 'N/A',
          },
        )
        .toList();
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    return '${months[date.month - 1]} ${date.day} at ${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}';
  }

  String _getStatus(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'preparing':
        return 'Preparing';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      default:
        return 'Pending';
    }
  }

  Future<Map<String, dynamic>?> getOrderById(String id) async {
    await _loadMockData();
    try {
      return _orders.firstWhere((o) => o['id'] == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateOrderDelivery(
    String orderId,
    String newStatus, {
    DateTime? actualDate,
  }) async {
    await _loadMockData();
    final index = _orders.indexWhere((o) => o['id'] == orderId);
    if (index != -1) {
      _orders[index]['order_status'] = newStatus;
      if (actualDate != null && newStatus == 'delivered') {
        _orders[index]['actual_delivery_date'] = _formatDate(actualDate);
        _orders[index]['statusColor'] = 'green';
      } else {
        _orders[index]['statusColor'] = newStatus == 'out_for_delivery'
            ? 'orange'
            : 'red';
      }
      await _saveList(_ordersKey, _orders);
    }
  }

  // Wallet
  Future<Map<String, dynamic>?> getUserWallet() async {
    await _loadMockData();
    return _wallets.isNotEmpty
        ? _wallets[0]
        : {'user_id': 'mock_user', 'balance': 0.0};
  }

  Future<void> createWallet(String userId) async {
    await _loadMockData();
    if (_wallets.every((w) => w['user_id'] != userId)) {
      _wallets.add({'user_id': userId, 'balance': 0.0});
      await _saveList(_walletsKey, _wallets);
    }
  }

  // Favorites
  Future<void> addToFavorites(String productId) async {
    await _loadMockData();
    final favorite = {'user_id': 'mock_user', 'product_id': productId};
    if (!_favorites.any(
      (f) =>
          f['user_id'] == favorite['user_id'] &&
          f['product_id'] == favorite['product_id'],
    )) {
      _favorites.add(favorite);
      await _saveList(_favoritesKey, _favorites);
    }
  }

  Future<bool> isFavorited(String productId) async {
    await _loadMockData();
    return _favorites.any(
      (f) => f['user_id'] == 'mock_user' && f['product_id'] == productId,
    );
  }

  Future<List<Map<String, dynamic>>> getUserFavorites() async {
    await _loadMockData();
    final favorites = _favorites
        .where((f) => f['user_id'] == 'mock_user')
        .toList();
    return favorites
        .map((f) {
          try {
            return _products.firstWhere((p) => p['id'] == f['product_id']);
          } catch (e) {
            return <String, dynamic>{};
          }
        })
        .where((p) => p.isNotEmpty)
        .toList();
  }

  // Reviews
  Future<void> addReview({
    required String productId,
    required int rating,
    String? reviewText,
  }) async {
    await _loadMockData();
    final review = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'product_id': productId,
      'user_id': 'mock_user',
      'rating': rating,
      'review_text': reviewText,
    };
    _reviews.add(review);
    await _saveList(_reviewsKey, _reviews);
  }

  Future<List<Map<String, dynamic>>> getProductReviews(String productId) async {
    await _loadMockData();
    return List.from(_reviews.where((r) => r['product_id'] == productId));
  }

  // Admin stats
  Future<int> getTotalOrdersCount() async {
    await _loadMockData();
    return _orders.length;
  }

  Future<double> getTotalRevenue() async {
    await _loadMockData();
    double total = 0.0;
    for (var order in _orders) {
      total += order['total_amount'] as double;
    }
    return total;
  }

  // Clear data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_productsKey);
    await prefs.remove(_ordersKey);
    await prefs.remove(_profilesKey);
    await prefs.remove(_walletsKey);
    await prefs.remove(_favoritesKey);
    await prefs.remove(_reviewsKey);
    _products.clear();
    _orders.clear();
    _profiles.clear();
    _wallets.clear();
    _favorites.clear();
    _reviews.clear();
  }
}
