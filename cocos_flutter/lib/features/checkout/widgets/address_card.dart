import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: const ListTile(
        leading: Icon(Icons.location_on, color: Color.fromARGB(255, 94, 83, 193)),
        title: Text('Bintang Kresno', style: TextStyle(fontFamily: 'Unino', color: Colors.white)),
        subtitle: Text('Jl. Melati No. 123, Medan, North Sumatra', style: TextStyle(fontFamily: 'Unino', color: Colors.white70)),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}