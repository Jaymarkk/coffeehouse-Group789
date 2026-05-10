import 'package:flutter/material.dart';
import 'services/admin_service.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({Key? key}) : super(key: key);

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  late AdminService _adminService;

  @override
  void initState() {
    super.initState();
    _adminService = AdminService();
  }

  @override
  Widget build(BuildContext context) {
    final stats = _adminService.getStatistics();

    return Scaffold(
      backgroundColor: const Color(0xFFD4A574),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B5A2B),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          '📊 Business Reports',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Sales Report
            _buildReportCard(
              title: '☕ Sales Report',
              children: [
                _buildReportRow(
                  label: 'Total Orders',
                  value: '${stats['totalOrders']} orders',
                  icon: '📦',
                ),
                _buildReportRow(
                  label: 'Total Revenue',
                  value:
                      '₱${(stats['totalRevenue'] as double).toStringAsFixed(2)}',
                  icon: '💰',
                ),
                _buildReportRow(
                  label: 'Avg Order Value',
                  value:
                      '₱${(stats['avgOrderValue'] as double).toStringAsFixed(2)}',
                  icon: '📈',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Product Sales Report
            _buildReportCard(
              title: '🏆 Top Selling Products',
              children: [
                ...(() {
                  final topProducts = _adminService.products
                      .where((p) => (p['sales'] as int) > 0)
                      .toList();
                  topProducts.sort(
                    (a, b) => (b['sales'] as int).compareTo(a['sales'] as int),
                  );
                  return topProducts.take(5);
                }()).map((product) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B4423),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${product['image']} ${product['name']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${product['sales']} sold • ₱${(product['price'] as double).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₱${((product['price'] as double) * (product['sales'] as int)).toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
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
            const SizedBox(height: 16),

            // Inventory Report
            _buildReportCard(
              title: '📦 Inventory Report',
              children: [
                _buildReportRow(
                  label: 'Total Products',
                  value: '${_adminService.products.length} items',
                  icon: '☕',
                ),
                _buildReportRow(
                  label: 'Low Stock Items',
                  value: '${stats['lowStockItems']} ⚠️',
                  icon: '⚠️',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Stock Details:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ..._adminService.products.map((product) {
                  final isLowStock = (product['stock'] as int) < 20;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product['image']} ${product['name']}',
                          style: TextStyle(
                            color: isLowStock ? Colors.orange : Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${product['stock']} units ${isLowStock ? '⚠️' : '✓'}',
                          style: TextStyle(
                            color: isLowStock ? Colors.orange : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

            // Customer Report
            _buildReportCard(
              title: '👥 Customer Report',
              children: [
                _buildReportRow(
                  label: 'Total Users',
                  value: '${stats['totalUsers']} users',
                  icon: '👥',
                ),
                _buildReportRow(
                  label: 'Active Users Today',
                  value: '${stats['totalLogins']} logins',
                  icon: '✅',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Category Breakdown
            _buildReportCard(
              title: '📂 Category Breakdown',
              children: [
                ..._getCategoryReport().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B4423),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${entry.value['count']} products',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${entry.value['sales']} sales',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '₱${entry.value['revenue'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

            // Performance Metrics
            _buildReportCard(
              title: '📊 Performance Metrics',
              children: [
                _buildMetricBar(
                  label: 'Best Selling Category',
                  value: _getBestCategory(),
                  percentage: 100,
                ),
                const SizedBox(height: 12),
                _buildMetricBar(
                  label: 'Inventory Efficiency',
                  value:
                      'Low Stock: ${stats['lowStockItems']}/${_adminService.products.length}',
                  percentage: 85,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getCategoryReport() {
    final Map<String, dynamic> categoryReport = {};

    for (var product in _adminService.products) {
      final category = product['category'] as String;
      if (!categoryReport.containsKey(category)) {
        categoryReport[category] = {'count': 0, 'sales': 0, 'revenue': 0.0};
      }
      categoryReport[category]['count']++;
      categoryReport[category]['sales'] += product['sales'] as int;
      categoryReport[category]['revenue'] +=
          (product['price'] as double) * (product['sales'] as int);
    }

    return categoryReport;
  }

  String _getBestCategory() {
    final report = _getCategoryReport();
    String bestCategory = 'N/A';
    int maxSales = 0;

    report.forEach((category, data) {
      if ((data['sales'] as int) > maxSales) {
        maxSales = data['sales'];
        bestCategory = category;
      }
    });

    return bestCategory;
  }

  Widget _buildReportCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF8B5A2B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF000000), width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildReportRow({
    required String label,
    required String value,
    required String icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBar({
    required String label,
    required String value,
    required int percentage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8,
            backgroundColor: const Color(0xFF6B4423),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ),
      ],
    );
  }
}
