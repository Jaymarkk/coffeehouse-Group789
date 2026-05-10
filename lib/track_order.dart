import 'package:flutter/material.dart';
import 'services/user_data_service.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({Key? key}) : super(key: key);

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _markerController;
  late Animation<double> _markerAnimation;
  int currentStep = 1; // 0: Accepted, 1: Preparing, 2: On the way, 3: Delivered
  final UserDataService _userService = UserDataService();

  final List<TrackingStep> trackingSteps = [
    TrackingStep(
      title: 'Your order has been accepted',
      time: '2 min',
      isCompleted: true,
    ),
    TrackingStep(
      title: 'The restaurant is preparing your order',
      time: '5 min',
      isCompleted: true,
    ),
    TrackingStep(
      title: 'The delivery is on his way',
      time: '10 min',
      isCompleted: false,
    ),
    TrackingStep(
      title: 'Your order has been delivered',
      time: '8 min',
      isCompleted: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressController.forward();

    _markerController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _markerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _markerController, curve: Curves.easeInOut),
    );

    _markerController.forward();
    _advanceProgress();
  }

  void _advanceProgress() {
    Future.delayed(const Duration(seconds: 8), () {
      if (!mounted) return;
      if (currentStep < trackingSteps.length - 1) {
        setState(() {
          currentStep++;
          trackingSteps[currentStep].isCompleted = true;
          _progressController.reset();
          _progressController.forward();
        });
        _advanceProgress();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _markerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shippingAddress = _userService.getSelectedAddressString();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Color(0xFF6B5344),
            size: 28,
          ),
        ),
        title: const Text(
          'Delivery time',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B5344),
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map Section
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Stack(
                  children: [
                    // Simple map representation
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[100],
                      ),
                      child: Image.asset(
                        'assets/map_placeholder.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey[200],
                            ),
                          );
                        },
                      ),
                    ),
                    // Urdaneta City starting point
                    Positioned(
                      top: 60,
                      left: 20,
                      child: Column(
                        children: const [
                          Icon(
                            Icons.location_on,
                            size: 28,
                            color: Color(0xFF8B5A2B),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Urdaneta City',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B5344),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Delivery marker - animated movement toward your location
                    AnimatedBuilder(
                      animation: _markerAnimation,
                      builder: (context, child) {
                        final beginAlignment = Alignment(-0.9, -0.4);
                        final endAlignment = Alignment(0.8, -0.4);
                        final animatedAlignment = Alignment.lerp(
                          beginAlignment,
                          endAlignment,
                          _markerAnimation.value,
                        )!;

                        return Align(
                          alignment: animatedAlignment,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B35),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFFF6B35,
                                      ).withOpacity(0.4),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.local_shipping,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    // Your location destination
                    Positioned(
                      top: 60,
                      right: 40,
                      child: Column(
                        children: const [
                          Icon(
                            Icons.location_on,
                            size: 32,
                            color: Color(0xFFFF6B35),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Your location',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B5344),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Shipping Address Section
              const Text(
                'Shipping Address',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B5344),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellow[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.yellow[200]!, width: 1),
                ),
                child: Text(
                  shippingAddress.isNotEmpty
                      ? shippingAddress
                      : 'No shipping address set',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B5344),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Delivery Time Section
              const Text(
                'Delivery Time',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B5344),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Estimated Delivery',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B5344),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '25 mins',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B5344),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Tracking Timeline
              ...List.generate(trackingSteps.length, (index) {
                final step = trackingSteps[index];
                final isLast = index == trackingSteps.length - 1;
                return _buildTrackingStep(
                  index: index,
                  step: step,
                  isLast: isLast,
                  isActive: index <= currentStep,
                );
              }),
              const SizedBox(height: 32),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFFF6B35),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Return Home',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF6B35),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (currentStep == trackingSteps.length - 1 &&
                            trackingSteps.last.isCompleted) {
                          Navigator.pushNamed(context, '/delivery_complete');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Your order is still on the way.'),
                              backgroundColor: Color(0xFF6B5344),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Track Order',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingStep({
    required int index,
    required TrackingStep step,
    required bool isLast,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: step.isCompleted
                      ? const Color(0xFF00D084)
                      : (isActive ? const Color(0xFFFF6B35) : Colors.grey[300]),
                  boxShadow: step.isCompleted || isActive
                      ? [
                          BoxShadow(
                            color: step.isCompleted
                                ? const Color(0xFF00D084).withOpacity(0.3)
                                : const Color(0xFFFF6B35).withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: step.isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : (isActive
                            ? Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              )
                            : const SizedBox.shrink()),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: step.isCompleted
                      ? const Color(0xFF00D084)
                      : Colors.grey[300],
                  margin: const EdgeInsets.only(top: 4),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Step details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  step.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: step.isCompleted
                        ? const Color(0xFF6B5344)
                        : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrackingStep {
  final String title;
  final String time;
  bool isCompleted;

  TrackingStep({
    required this.title,
    required this.time,
    required this.isCompleted,
  });
}
