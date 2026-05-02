import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_appbar.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkSlate,
      appBar: const CustomAppBar(title: "Address"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _card("Home", "Jl Mawar No 1"),
            _card("Office", "Jl Melati No 2"),
            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AddAddressPage()));
              },
              child: const Text("Add New Address"),
            )
          ],
        ),
      ),
    );
  }

  Widget _card(String title, String sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.location_on, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(sub, style: const TextStyle(color: Colors.white70)),
      ),
    );
  }
}

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkSlate,
      appBar: const CustomAppBar(title: "Add Address"),
      body: const Center(
        child: Text("Add Address Page"),
      ),
    );
  }
}