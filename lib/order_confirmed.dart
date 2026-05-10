import 'package:flutter/material.dart';

class OrderConfirmedScreen extends StatefulWidget {
  const OrderConfirmedScreen({Key? key}) : super(key: key);

  @override
  State<OrderConfirmedScreen> createState() => _OrderConfirmedScreenState();
}

class _OrderConfirmedScreenState extends State<OrderConfirmedScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFFD4B896),
        appBar: AppBar(
          backgroundColor: const Color(0xFFD4B896),
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            },
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF6B5344),
              size: 28,
            ),
          ),
          title: const Text(
            '',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B5344),
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Success Animation
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF00D084),
                        width: 4,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        size: 80,
                        color: Color(0xFF00D084),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Success Message
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: Column(
                    children: [
                      const Text(
                        'Order Confirmed!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B5344),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your order has been placed\nsuccessfully',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF6B5344).withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Order Details Box
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Order ID',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B5344),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '#ORD-2026-9876',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6B5344),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Colors.white30, thickness: 1),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Delivery by',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B5344),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Thu, 2nd, 4:00 PM',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6B5344),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Track Order Button
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/track_order');
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Track my order',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B5344),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                // Support Message
                Text(
                  'If you have any questions, please reach out\ndirectly to our customer support',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF6B5344).withOpacity(0.6),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
