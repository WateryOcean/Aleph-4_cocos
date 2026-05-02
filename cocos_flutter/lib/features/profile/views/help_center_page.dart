import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  String selectedCategory = "General";

  final List<String> categories = [
    "General",
    "Account",
    "Service",
    "Payment",
  ];

  final List<Map<String, String>> faqList = [
    {
      "category": "General",
      "q": "What is CoCos?",
      "a":
          "CoCos is a modern e-commerce platform focused on custom cosplay products. "
          "Users can explore a wide range of items, personalize their designs, and place orders easily. "
          "The platform is designed to provide a seamless experience for both beginners and professional cosplayers."
    },
    {
      "category": "General",
      "q": "Is CoCos free to use?",
      "a":
          "Yes, CoCos is completely free to use. You can browse products, explore features, "
          "and customize items without any cost. Payments are only required when you place an order."
    },
    {
      "category": "General",
      "q": "Where can I access CoCos?",
      "a":
          "CoCos can be accessed anytime through the mobile application. "
          "It is designed to provide a smooth and responsive experience across different devices."
    },

    {
      "category": "Account",
      "q": "How do I create an account?",
      "a":
          "To create an account, simply register using your email and password. "
          "After registration, you can complete your profile and start using all available features."
    },
    {
      "category": "Account",
      "q": "How do I reset my password?",
      "a":
          "If you forget your password, you can use the 'Forgot Password' option on the login page. "
          "Follow the instructions sent to your email to reset your password securely."
    },
    {
      "category": "Account",
      "q": "Can I update my personal information?",
      "a":
          "Yes, you can update your personal details such as name, email, and phone number "
          "through the profile settings at any time."
    },

    {
      "category": "Service",
      "q": "How do I customize a product?",
      "a":
          "You can customize products by selecting an item and choosing the available customization options. "
          "This includes size, color, and specific design preferences before placing your order."
    },
    {
      "category": "Service",
      "q": "How long does production take?",
      "a":
          "Production time usually takes between 3 to 7 working days depending on the complexity of the product. "
          "You will receive updates as your order progresses."
    },
    {
      "category": "Service",
      "q": "Can I track my order?",
      "a":
          "Yes, order tracking is available in the order section. "
          "You can monitor the progress from processing, production, until delivery."
    },

    {
      "category": "Payment",
      "q": "What payment methods are available?",
      "a":
          "We support multiple payment methods including bank transfers, e-wallets, and other secure payment options "
          "to ensure a convenient checkout experience."
    },
    {
      "category": "Payment",
      "q": "Is my payment secure?",
      "a":
          "Yes, all transactions are protected using secure encryption systems. "
          "Your payment information is handled safely and confidentially."
    },
    {
      "category": "Payment",
      "q": "Can I use promo codes?",
      "a":
          "Yes, you can apply promo codes during checkout to receive discounts. "
          "Make sure the code is valid before completing your payment."
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFaq = faqList
        .where((item) => item["category"] == selectedCategory)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.darkSlate,

      /// APPBAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            "Help Center",
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final isActive = cat == selectedCategory;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = cat;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.deepPurple
                                : AppColors.cardDark,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            cat,
                            style: GoogleFonts.nunito(
                              color:
                                  isActive ? Colors.white : Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// FAQ LIST
            Expanded(
              child: ListView.builder(
                itemCount: filteredFaq.length,
                itemBuilder: (context, index) {
                  final item = filteredFaq[index];
                  return _FaqItem(
                    question: item["q"]!,
                    answer: item["a"]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqItem({
    required this.question,
    required this.answer,
  });

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [

          ListTile(
            title: Text(
              widget.question,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(
              isOpen
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.white70,
            ),
            onTap: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
          ),

          if (isOpen)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.answer,
                textAlign: TextAlign.left, 
                style: GoogleFonts.nunito(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),
        ],
      ),
    );
  }
}