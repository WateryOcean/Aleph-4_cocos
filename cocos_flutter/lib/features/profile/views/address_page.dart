import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import 'edit_address_page.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List<Map<String, String>> addresses = [
    {"title": "Home", "detail": "6480 Sunbrook Park"},
    {"title": "Office", "detail": "6993 Meadow Valley"},
    {"title": "Apartment", "detail": "21833 Clyde"},
    {"title": "Parent's House", "detail": "5259 Blue Bill"},
  ];

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
            "Address",
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

            Expanded(
              child: ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final item = addresses[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [

                        const Icon(
                          Icons.location_on,
                          color: AppColors.deepPurple,
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"]!,
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                item["detail"]!,
                                style: GoogleFonts.nunito(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditAddressPage(
                                  title: item["title"]!,
                                  detail: item["detail"]!,
                                  index: index,
                                  isEdit: true,
                                ),
                              ),
                            );

                            if (result != null) {
                              setState(() {
                                addresses[index] = result;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepPurple,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditAddressPage(
                      title: "",
                      detail: "",
                      index: -1,
                      isEdit: false,
                    ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    addresses.add(result);
                  });
                }
              },
              child: Text(
                "Add New Address",
                style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}