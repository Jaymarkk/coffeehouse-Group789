// User Data Service - Singleton for managing user data across the app
class UserDataService {
  static final UserDataService _instance = UserDataService._internal();

  factory UserDataService() {
    return _instance;
  }

  UserDataService._internal();

  // User Profile Data
  String userName = 'Coffee Enthusiast';
  String userEmail = 'user@coffeehouse.com';
  String userPhone = '+63 912 345 6789';
  String userCity = 'Manila, Philippines';

  // Wallet Data
  double walletBalance = 5250.50;

  // Selected Address
  String selectedAddressId = '';

  // Addresses
  List<Map<String, String>> addresses = [];

  // Orders
  List<Map<String, dynamic>> orders = [
    {
      'orderID': '#ORD-001',
      'date': 'Mar 5, 2026 at 2:30 PM',
      'items': [
        {'name': 'Cappuccino', 'quantity': 2, 'price': 250.00, 'image': '☕'},
        {'name': 'Croissant', 'quantity': 1, 'price': 150.00, 'image': '🥐'},
      ],
      'total': 650.00,
      'status': 'Delivered',
      'statusColor': 'green',
      'origin': 'Coffee House - Makati Branch',
      'origin_address': '456 Business Ave, Makati',
      'destination_address': '123 Coffee Street, Manila',
      'tracking_progress': 100,
      'estimatedTime': '2:45 PM',
      'actualTime': '2:42 PM',
      'trackingSteps': [
        {'step': 'Order Confirmed', 'time': '2:30 PM', 'completed': true},
        {'step': 'Preparing Your Order', 'time': '2:33 PM', 'completed': true},
        {'step': 'Out for Delivery', 'time': '2:38 PM', 'completed': true},
        {'step': 'Delivered', 'time': '2:42 PM', 'completed': true},
      ],
    },
    {
      'orderID': '#ORD-002',
      'date': 'Mar 3, 2026 at 7:15 PM',
      'items': [
        {'name': 'Espresso', 'quantity': 3, 'price': 100.00, 'image': '☕'},
        {
          'name': 'Chocolate Muffin',
          'quantity': 2,
          'price': 100.00,
          'image': '🧁',
        },
      ],
      'total': 500.00,
      'status': 'Delivered',
      'statusColor': 'green',
      'origin': 'Coffee House - Manila Branch',
      'origin_address': '123 Coffee Street, Manila',
      'destination_address': '456 Business Ave, Makati',
      'tracking_progress': 100,
      'estimatedTime': '7:35 PM',
      'actualTime': '7:32 PM',
      'trackingSteps': [
        {'step': 'Order Confirmed', 'time': '7:15 PM', 'completed': true},
        {'step': 'Preparing Your Order', 'time': '7:18 PM', 'completed': true},
        {'step': 'Out for Delivery', 'time': '7:25 PM', 'completed': true},
        {'step': 'Delivered', 'time': '7:32 PM', 'completed': true},
      ],
    },
    {
      'orderID': '#ORD-003',
      'date': 'Feb 28, 2026 at 10:45 AM',
      'items': [
        {'name': 'Latte Bundle', 'quantity': 1, 'price': 1200.00, 'image': '☕'},
        {'name': 'Cookies Box', 'quantity': 1, 'price': 200.00, 'image': '🍪'},
      ],
      'total': 1400.00,
      'status': 'Delivered',
      'statusColor': 'green',
      'origin': 'Coffee House - Quezon City Branch',
      'origin_address': '789 Premium St, Quezon City',
      'destination_address': '123 Coffee Street, Manila',
      'tracking_progress': 100,
      'estimatedTime': '11:15 AM',
      'actualTime': '11:08 AM',
      'trackingSteps': [
        {'step': 'Order Confirmed', 'time': '10:45 AM', 'completed': true},
        {'step': 'Preparing Your Order', 'time': '10:50 AM', 'completed': true},
        {'step': 'Out for Delivery', 'time': '11:00 AM', 'completed': true},
        {'step': 'Delivered', 'time': '11:08 AM', 'completed': true},
      ],
    },
  ];

  // Update profile
  void updateProfile({
    required String name,
    required String email,
    required String phone,
    required String city,
  }) {
    userName = name;
    userEmail = email;
    userPhone = phone;
    userCity = city;
  }

  // Top-up wallet
  void topUpWallet(double amount) {
    walletBalance += amount;
  }

  // Send money
  bool sendMoney(double amount, String recipientName) {
    if (amount <= walletBalance) {
      walletBalance -= amount;
      return true;
    }
    return false;
  }

  // Add address
  void addAddress({
    required String label,
    required String address,
    required String phone,
    required String city,
  }) {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    addresses.add({
      'id': newId,
      'label': label,
      'address': address,
      'phone': phone,
      'city': city,
    });
    if (selectedAddressId.isEmpty) {
      selectedAddressId = newId;
    }
  }

  // Update address
  void updateAddress({
    required String id,
    required String label,
    required String address,
    required String phone,
    required String city,
  }) {
    final index = addresses.indexWhere((addr) => addr['id'] == id);
    if (index != -1) {
      addresses[index] = {
        'id': id,
        'label': label,
        'address': address,
        'phone': phone,
        'city': city,
      };
    }
  }

  // Delete address
  void deleteAddress(String id) {
    addresses.removeWhere((addr) => addr['id'] == id);
    // If deleted address was selected, select first address
    if (selectedAddressId == id && addresses.isNotEmpty) {
      selectedAddressId = addresses[0]['id']!;
    }
  }

  // Set selected address
  void setSelectedAddress(String addressId) {
    if (addresses.any((addr) => addr['id'] == addressId)) {
      selectedAddressId = addressId;
    }
  }

  // Get selected address details
  Map<String, String>? getSelectedAddress() {
    try {
      return addresses.firstWhere((addr) => addr['id'] == selectedAddressId);
    } catch (e) {
      // If no selected address found, return first one
      return addresses.isNotEmpty ? addresses[0] : null;
    }
  }

  // Get selected address as formatted string
  String getSelectedAddressString() {
    final selected = getSelectedAddress();
    if (selected != null) {
      return selected['address'] ?? '';
    }
    return '';
  }

  // Add order
  void addOrder({
    required List<Map<String, dynamic>> items,
    required double total,
    required String address,
  }) {
    final orderId = '#ORD-${(orders.length + 1).toString().padLeft(3, '0')}';
    final now = DateTime.now();
    final dateStr =
        'Mar ${now.day}, 2026 at ${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';

    orders.insert(0, {
      'orderID': orderId,
      'date': dateStr,
      'items': items,
      'total': total,
      'status': 'Pending',
      'statusColor': 'orange',
      'address': address,
    });
  }
}
