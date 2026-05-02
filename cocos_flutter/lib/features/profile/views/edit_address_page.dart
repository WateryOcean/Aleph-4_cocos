import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';

class EditAddressPage extends StatefulWidget {
  final String title;
  final String detail;
  final int index;
  final bool isEdit;

  const EditAddressPage({
    super.key,
    required this.title,
    required this.detail,
    required this.index,
    required this.isEdit,
  });

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  late TextEditingController titleController;
  late TextEditingController detailController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    detailController = TextEditingController(text: widget.detail);
  }

  void _saveData() {
    Navigator.pop(context, {
      "title": titleController.text,
      "detail": detailController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkSlate,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            widget.isEdit ? "Edit Address" : "Add New Address",
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Stack(
        children: [

          SizedBox(
            height: 320,
            width: double.infinity,
            child: Stack(
              children: [

                Positioned.fill(
                  child: Image.asset(
                    "assets/logo_images/map_placeholder.png",
                    fit: BoxFit.cover,
                  ),
                ),

                Center(
                  child: Transform.translate(
                    offset: const Offset(0, -55), 
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_pin,
                        size: 36,
                        color: AppColors.deepPurple,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.darkSlate,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Center(
                        child: Text(
                          "Address Details",
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Name Address",
                        style: GoogleFonts.nunito(color: Colors.white70),
                      ),
                      const SizedBox(height: 6),
                      _input(titleController),

                      const SizedBox(height: 16),

                      Text(
                        "Address Details",
                        style: GoogleFonts.nunito(color: Colors.white70),
                      ),
                      const SizedBox(height: 6),
                      _input(detailController, hasIcon: true),

                      const SizedBox(height: 30),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deepPurple,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _saveData,
                        child: Text(
                          widget.isEdit ? "Apply" : "Add",
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _input(TextEditingController controller, {bool hasIcon = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (hasIcon)
            const Icon(
              Icons.location_on,
              color: AppColors.deepPurple,
            ),
          if (hasIcon) const SizedBox(width: 8),

          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.nunito(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}