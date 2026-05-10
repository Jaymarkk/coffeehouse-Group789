class CartItem {
  final String name;
  final String image;
  final String price;
  final String description;
  final String ingredients;
  final double rating;
  final int reviews;
  int quantity;
  final DateTime addedAt;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.ingredients,
    required this.rating,
    required this.reviews,
    required this.quantity,
    required this.addedAt,
  });

  double get totalPrice {
    double priceValue = double.parse(
      price.replaceAll('₱', '').replaceAll(',', ''),
    );
    return priceValue * quantity;
  }
}

class CartManager {
  static final CartManager _instance = CartManager._internal();

  factory CartManager() {
    return _instance;
  }

  CartManager._internal();

  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addItem(Map<String, dynamic> product, int quantity) {
    // Check if item already exists
    final existingIndex = _cartItems.indexWhere(
      (item) => item.name == product['name'],
    );

    if (existingIndex >= 0) {
      // Update quantity if item exists
      _cartItems[existingIndex].quantity += quantity;
    } else {
      // Add new item
      _cartItems.add(
        CartItem(
          name: product['name'],
          image: product['image'],
          price: product['price'],
          description: product['description'],
          ingredients: product['ingredients'],
          rating: product['rating'],
          reviews: product['reviews'],
          quantity: quantity,
          addedAt: DateTime.now(),
        ),
      );
    }
  }

  void removeItem(String productName) {
    _cartItems.removeWhere((item) => item.name == productName);
  }

  void updateQuantity(String productName, int newQuantity) {
    final index = _cartItems.indexWhere((item) => item.name == productName);
    if (index >= 0) {
      if (newQuantity > 0) {
        _cartItems[index].quantity = newQuantity;
      } else {
        _cartItems.removeAt(index);
      }
    }
  }

  double get subtotal {
    return _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee => 50.0;

  double get total => subtotal + deliveryFee;

  void clearCart() {
    _cartItems.clear();
  }

  int get itemCount => _cartItems.length;
}
