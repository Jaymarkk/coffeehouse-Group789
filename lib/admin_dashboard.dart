import 'package:flutter/material.dart';
import 'services/admin_service.dart';
import 'admin_products.dart';
import 'admin_reports.dart';
import 'admin_login.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late AdminService _adminService;

  @override
  void initState() {
    super.initState();
    _adminService = AdminService();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xFF8B5A2B),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminLoginScreen(),
                ),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = _adminService.getStatistics();

    return Scaffold(
      backgroundColor: const Color(0xFFD4A574),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B5A2B),
        elevation: 0,
        title: const Text(
          '☕ Admin Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard(
                  title: 'Total Orders',
                  value: '${stats['totalOrders']}',
                  icon: Icons.shopping_bag,
                  color: const Color(0xFF6B4423),
                ),
                _buildStatCard(
                  title: 'Total Products',
                  value: '${stats['totalProducts']}',
                  icon: Icons.inventory,
                  color: const Color(0xFF8B6F47),
                ),
                _buildStatCard(
                  title: 'Total Users',
                  value: '${stats['totalUsers']}',
                  icon: Icons.people,
                  color: const Color(0xFF6B5344),
                ),
                _buildStatCard(
                  title: 'Total Revenue',
                  value:
                      '₱${(stats['totalRevenue'] as double).toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                  color: const Color(0xFF8B7355),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Key Metrics
            Container(
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
                    '📊 Key Metrics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMetricRow(
                    'Average Order Value',
                    '₱${(stats['avgOrderValue'] as double).toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 12),
                  _buildMetricRow(
                    'Low Stock Items',
                    '${stats['lowStockItems']} products',
                  ),
                  const SizedBox(height: 12),
                  _buildMetricRow(
                    'Total Products',
                    '${_adminService.products.length} items',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Top Selling Products
            Container(
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
                    '🏆 Top Selling Products',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...(() {
                    final topProducts = _adminService.products
                        .where((p) => (p['sales'] as int) > 100)
                        .toList();
                    topProducts.sort(
                      (a, b) =>
                          (b['sales'] as int).compareTo(a['sales'] as int),
                    );
                    return topProducts.take(5);
                  }()).map((product) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF6B4423),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Text(
                              product['image'],
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${product['sales']} sales',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '₱${(product['price'] as double).toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Management Buttons
            _buildManagementButton(
              label: '📦 Manage Products',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminProductsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildManagementButton(
              label: '📊 View Reports',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminReportsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF000000), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildManagementButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B5A2B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
