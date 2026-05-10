import 'package:flutter/material.dart';

class FAQsScreen extends StatefulWidget {
  const FAQsScreen({Key? key}) : super(key: key);

  @override
  State<FAQsScreen> createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _expandedIndex = -1;
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, dynamic>> _chatMessages = [];

  final List<Map<String, String>> faqs = [
    {
      'question': 'What are the delivery hours?',
      'answer':
          'We deliver from 8:00 AM to 10:00 PM, Monday to Sunday. Standard delivery takes 30-45 minutes depending on your location.',
    },
    {
      'question': 'How can I track my order?',
      'answer':
          'After placing an order, you can track it in real-time through our app. Simply go to Order History and select the order to view the delivery status.',
    },
    {
      'question': 'What if I have an issue with my order?',
      'answer':
          'If you encounter any issues, please contact our customer support team immediately. We offer a 100% satisfaction guarantee and will resolve any problems.',
    },
    {
      'question': 'Are there any delivery fees?',
      'answer':
          'Delivery fees depend on your location. Orders above ₱500 qualify for free delivery in selected areas. Check during checkout for exact fees.',
    },
    {
      'question': 'Can I cancel or modify my order?',
      'answer':
          'You can cancel or modify your order within 5 minutes of placing it. After that, the order enters preparation and cannot be changed.',
    },
    {
      'question': 'What payment methods do you accept?',
      'answer':
          'We accept credit/debit cards, digital wallets, and cash on delivery. You can also pay using your Coffee House wallet balance.',
    },
    {
      'question': 'How do I earn rewards points?',
      'answer':
          'Every purchase earns you points equal to 5% of your order total. Accumulate points to unlock discounts and exclusive offers!',
    },
    {
      'question': 'Is there a minimum order value?',
      'answer':
          'The minimum order value is ₱150. Orders below this amount may incur an additional charge or may not be accepted.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _chatMessages.add({
      'isUser': false,
      'message':
          'Hey there! 👋 I\'m your Coffee House AI Assistant. Ask me anything about coffee, our products, or the app!',
      'timestamp': DateTime.now(),
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  String _generateAIResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    // Coffee type questions
    if (lowerMessage.contains('espresso') || lowerMessage.contains('shot')) {
      return 'Espresso is a concentrated coffee made by forcing hot water through finely-ground coffee beans. We offer premium espresso shots that are rich and bold! Would you like to know more about our espresso-based drinks?';
    }
    if (lowerMessage.contains('cappuccino') ||
        lowerMessage.contains('cappucino')) {
      return 'A cappuccino is a classic Italian coffee drink made with espresso, steamed milk, and milk foam in equal parts. Our cappuccinos are creamy and perfect for any time of day!';
    }
    if (lowerMessage.contains('latte')) {
      return 'A latte is a smooth and creamy coffee drink made with espresso and steamed milk, with just a hint of foam. It\'s our most popular drink among customers!';
    }
    if (lowerMessage.contains('americano')) {
      return 'An Americano is a simple yet delicious drink made by adding hot water to espresso shots. It has a bold flavor similar to drip coffee but with more depth!';
    }
    if (lowerMessage.contains('macchiato')) {
      return 'A macchiato is espresso "marked" with just a small amount of milk foam. It\'s stronger than a latte and perfect for espresso lovers!';
    }
    if (lowerMessage.contains('mocha') || lowerMessage.contains('chocolate')) {
      return 'A mocha combines espresso, steamed milk, and chocolate. It\'s a delightful choice if you love both coffee and chocolate!';
    }

    // Coffee origin/bean questions
    if (lowerMessage.contains('arabica')) {
      return 'Arabica beans are the most popular coffee beans, known for their smooth, mild flavor with fruity and floral notes. They make up about 60% of the world\'s coffee production!';
    }
    if (lowerMessage.contains('robusta')) {
      return 'Robusta beans have a stronger, more bitter taste and higher caffeine content than arabica. They\'re often used in espresso blends for a rich crema!';
    }
    if (lowerMessage.contains('origin') ||
        lowerMessage.contains('bean') ||
        lowerMessage.contains('beans')) {
      return 'We source premium coffee beans from various origins including Colombia, Ethiopia, Vietnam, and Brazil. Each origin has unique flavor characteristics! Ask about specific origins if you\'re interested!';
    }

    // Brewing/preparation questions
    if (lowerMessage.contains('brew') || lowerMessage.contains('brewing')) {
      return 'Coffee brewing is both an art and a science! Different methods like pour-over, French press, and espresso machines each produce unique flavors. Our baristas are trained to brew each cup to perfection!';
    }
    if (lowerMessage.contains('grind') || lowerMessage.contains('ground')) {
      return 'Grind size is crucial for coffee! Fine grinds work best for espresso, medium for drip coffee, and coarse for French press. Our coffee is always ground fresh for maximum flavor!';
    }
    if (lowerMessage.contains('temperature') ||
        lowerMessage.contains('hot') ||
        lowerMessage.contains('cold')) {
      return 'The ideal water temperature for brewing coffee is between 195-205°F (90-96°C). We also offer refreshing cold brew and iced coffee options!';
    }

    // Health/caffeine questions
    if (lowerMessage.contains('caffeine')) {
      return 'A cup of espresso contains about 75mg of caffeine, while a regular coffee cup has about 95mg. Our decaf options have 2-5mg of caffeine if you prefer less!';
    }
    if (lowerMessage.contains('health') || lowerMessage.contains('benefit')) {
      return 'Coffee can have several health benefits including improved alertness, antioxidants, and potential metabolism boost. Of course, moderation is key!';
    }

    // FAQ-like questions
    if (lowerMessage.contains('delivery') || lowerMessage.contains('when')) {
      return 'We deliver from 8:00 AM to 10:00 PM daily! Standard delivery takes 30-45 minutes. Orders above ₱500 get free delivery in select areas!';
    }
    if (lowerMessage.contains('price') ||
        lowerMessage.contains('cost') ||
        lowerMessage.contains('how much')) {
      return 'Our prices vary by product, from ₱85 for a regular coffee to ₱250+ for specialty drinks. Check our menu for detailed pricing!';
    }
    if (lowerMessage.contains('recommend') ||
        lowerMessage.contains('suggestion') ||
        lowerMessage.contains('suggest')) {
      return 'I recommend trying our signature Cappuccino or the Ethiopian Pour-Over if you love rich flavors. If you\'re new, the Classic Latte Bundle is a great starting point!';
    }

    // Default response
    return 'That\'s a great question! I\'m still learning about that topic. Feel free to ask about our coffee types (cappuccino, latte, espresso, etc.), brewing methods, coffee origins, or cafes details. You can also visit our FAQ section!';
  }

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;

    final userMessage = _chatController.text.trim();

    setState(() {
      _chatMessages.add({
        'isUser': true,
        'message': userMessage,
        'timestamp': DateTime.now(),
      });
      _chatController.clear();
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final aiResponse = _generateAIResponse(userMessage);
        setState(() {
          _chatMessages.add({
            'isUser': false,
            'message': aiResponse,
            'timestamp': DateTime.now(),
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4A574),
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'FAQs & Support',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'FAQs'),
              Tab(text: 'AI Chat'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // FAQs Tab
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: const Text(
                          'Common Questions About Coffee House',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ),
                      ...List.generate(faqs.length, (index) {
                        final faq = faqs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _expandedIndex = _expandedIndex == index
                                    ? -1
                                    : index;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5A2B),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF000000),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            faq['question']!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          _expandedIndex == index
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_expandedIndex == index)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF6B4423),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(14),
                                      child: Text(
                                        faq['answer']!,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5A2B),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF000000),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Still have questions?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Try our AI Chat tab for instant answers about coffee and our products!',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Or contact our support:',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Email: support@coffeehouse.ph',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Phone: +63 2 1234 5678',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // AI Chat Tab
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: _chatMessages.length,
                        itemBuilder: (context, index) {
                          final messageIndex = _chatMessages.length - 1 - index;
                          final message = _chatMessages[messageIndex];
                          final isUser = message['isUser'] as bool;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.75,
                                ),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? const Color(0xFF6B4423)
                                      : const Color(0xFF8B5A2B),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF000000),
                                    width: 1,
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: isUser
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message['message'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isUser ? 'You' : '☕ AI Assistant',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5A2B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _chatController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText:
                                    'Ask about coffee, products, or the app...',
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: _sendMessage,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
