import 'package:flutter/material.dart';
import 'my_wallet.dart';
import 'edit_profile.dart';
import 'shipping_address.dart';
import 'order_history.dart';
import 'faqs.dart';
import 'services/authentication_service.dart';
import 'services/user_data_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showAboutApp = false;
  bool _isLoadingProfile = true;
  late UserDataService _userService;

  @override
  void initState() {
    super.initState();
    _userService = UserDataService();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final authService = AuthenticationService();
    authService.init();

    try {
      final profile = await authService.getUserProfile();
      if (profile != null) {
        final firstName = profile['first_name']?.toString() ?? '';
        final lastName = profile['last_name']?.toString() ?? '';
        final middleName = profile['middle_name']?.toString() ?? '';
        final fullName = [
          firstName,
          middleName,
          lastName,
        ].where((part) => part.isNotEmpty).join(' ');
        final email =
            profile['email']?.toString() ??
            authService.currentUser?.email ??
            _userService.userEmail;
        final phone =
            profile['phone_number']?.toString() ?? _userService.userPhone;
        final city = profile['city']?.toString() ?? _userService.userCity;

        _userService.updateProfile(
          name: fullName.isNotEmpty ? fullName : _userService.userName,
          email: email,
          phone: phone,
          city: city,
        );
      }
    } catch (e) {
      print('⚠️  Failed to load user profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingProfile = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4A574),
      body: _showAboutApp
          ? _buildAboutAppContent()
          : (_isLoadingProfile
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF6B4423),
                      ),
                    ),
                  )
                : _buildProfileContent()),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/home'),
                    child: const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF8B5A2B),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF000000), width: 2),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFF8B5A2B),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userService.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _userService.userEmail,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF8B5A2B),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF000000), width: 2),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Info',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userService.userPhone,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userService.userCity,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildMenuItem(
            Icons.credit_card,
            'My Wallet',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyWalletScreen()),
              );
            },
          ),
          _buildMenuItem(
            Icons.edit,
            'Edit Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              ).then((_) {
                setState(() {});
              });
            },
          ),
          _buildMenuItem(
            Icons.location_on,
            'Shipping Address',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShippingAddressScreen(),
                ),
              );
            },
          ),
          _buildMenuItem(
            Icons.shopping_bag,
            'Order History',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryScreen(),
                ),
              );
            },
          ),
          _buildMenuItem(
            Icons.help,
            'FAQs',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQsScreen()),
              );
            },
          ),
          _buildMenuItem(
            Icons.info,
            'About Coffee House',
            onTap: () {
              setState(() {
                _showAboutApp = true;
              });
            },
          ),
          _buildMenuItem(
            Icons.logout,
            'Logout',
            onTap: () {
              _showLogoutDialog();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAboutAppContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'About Coffee House',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showAboutApp = false;
                      });
                    },
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF8B5A2B),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF000000), width: 2),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '☕ Coffee House',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Your Ultimate Coffee Experience',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Version: 1.0.0',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Created: march 2026',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF8B5A2B),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF000000), width: 2),
              ),
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Coffee House is a premium coffee delivery application designed to bring the finest coffee experience to your doorstep. From artisan blends to classic favorites, we offer an extensive selection of high-quality coffee products and pastries.\n\nOur mission is to make exceptional coffee accessible to everyone, whether you\'re a casual coffee drinker or a true connoisseur.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.6,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Key Features',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildFeatureItem(
            'Shopping',
            'Browse and order from our extensive coffee menu',
          ),
          _buildFeatureItem(
            'Delivery',
            'Quick and reliable delivery to your location',
          ),
          _buildFeatureItem(
            'Payment',
            'Safe payment options for your peace of mind',
          ),
          _buildFeatureItem('Tracking', 'Real-time tracking of your orders'),
          _buildFeatureItem(
            'Quality',
            'Only the finest coffee beans and pastries',
          ),
          _buildFeatureItem('Rewards', 'Earn points on every purchase'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF8B5A2B),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF000000), width: 2),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Developed By',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Jaymark Alano',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Flutter Developer',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  SizedBox(height: 12),
                  Divider(color: Colors.white30),
                  SizedBox(height: 12),
                  Text(
                    'App Creation Date: march 2026',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Last Updated: March 2026',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF8B5A2B),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF000000), width: 2),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Need Help?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Email: support@coffeehouse.ph',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Phone: +639937109251',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Website: www.coffeehouse.ph',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF8B5A2B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF000000), width: 1),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
