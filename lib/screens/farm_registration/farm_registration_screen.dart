import 'package:flutter/material.dart';
import '../../services/storage_service.dart';

class FarmRegistrationScreen extends StatefulWidget {
  const FarmRegistrationScreen({super.key});

  @override
  State<FarmRegistrationScreen> createState() =>
      _FarmRegistrationScreenState();
}

class _FarmRegistrationScreenState
    extends State<FarmRegistrationScreen> {
  final farmNameController = TextEditingController();
  final areaController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();

  DateTime? sowingDate;

  String selectedCrop = "Wheat";
  String selectedIrrigation = "Drip";

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        sowingDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F8F2),

      appBar: AppBar(
        title: const Text("Farm Registration"),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Image.asset(
              "assets/images/logo.png",
              height: 90,
            ),

            const SizedBox(height: 20),

            TextField(
              controller: farmNameController,
              decoration: InputDecoration(
                labelText: "Farm Name",
                prefixIcon: const Icon(Icons.agriculture),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: areaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Farm Area (Hectares)",
                prefixIcon: const Icon(Icons.square_foot),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: selectedCrop,

              decoration: InputDecoration(
                labelText: "Crop Type",
                prefixIcon: const Icon(Icons.grass),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              items: const [

                DropdownMenuItem(
                  value: "Wheat",
                  child: Text("Wheat"),
                ),

                DropdownMenuItem(
                  value: "Rice",
                  child: Text("Rice"),
                ),

                DropdownMenuItem(
                  value: "Maize",
                  child: Text("Maize"),
                ),

                DropdownMenuItem(
                  value: "Cotton",
                  child: Text("Cotton"),
                ),

                DropdownMenuItem(
                  value: "Sugarcane",
                  child: Text("Sugarcane"),
                ),

              ],

              onChanged: (value) {
                setState(() {
                  selectedCrop = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: "Farm Location",
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.grey),
              ),

              leading: const Icon(Icons.calendar_today),

              title: Text(
                sowingDate == null
                    ? "Select Sowing Date"
                    : "${sowingDate!.day}/${sowingDate!.month}/${sowingDate!.year}",
              ),

              trailing: ElevatedButton(
                onPressed: pickDate,
                child: const Text("Choose"),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: selectedIrrigation,

              decoration: InputDecoration(
                labelText: "Irrigation Type",
                prefixIcon: const Icon(Icons.water_drop),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              items: const [

                DropdownMenuItem(
                  value: "Drip",
                  child: Text("Drip"),
                ),

                DropdownMenuItem(
                  value: "Sprinkler",
                  child: Text("Sprinkler"),
                ),

                DropdownMenuItem(
                  value: "Flood",
                  child: Text("Flood"),
                ),

                DropdownMenuItem(
                  value: "Canal",
                  child: Text("Canal"),
                ),

              ],

              onChanged: (value) {
                setState(() {
                  selectedIrrigation = value!;
                });
              },
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: () async {
  await StorageService.saveFarmArea(areaController.text);

  await StorageService.saveCrop(selectedCrop);

  await StorageService.saveSowingDate(dateController.text);

  if (!context.mounted) return;
                  // API will be connected later

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Farm Registered Successfully"),
                    ),
                  );
                  Navigator.pop(context);
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),

                child: const Text(
                  "Register Farm",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}