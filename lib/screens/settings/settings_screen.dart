import 'package:flutter/material.dart';
import '../../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool darkMode = false;

  bool notifications = true;

  String language = "English";

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF5F8F2),

      appBar: AppBar(
       title: const Text(
  ("settings"),
),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: ListView(

        padding: const EdgeInsets.all(15),

        children: [

          Card(

            elevation: 5,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            child: const ListTile(

              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              title: Text(
                "Farmer",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text("farmer@email.com"),

            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: SwitchListTile(
              value: darkMode,

              title: const Text("Dark Mode"),

              secondary: const Icon(Icons.dark_mode),

              onChanged: (value) {

                setState(() {
                  darkMode = value;
                });

              },
            ),
          ),

          Card(
            child: SwitchListTile(
              value: notifications,

              title: const Text("Notifications"),

              secondary: const Icon(Icons.notifications),

              onChanged: (value) {

                setState(() {
                  notifications = value;
                });

              },
            ),
          ),

          Card(
            child: ListTile(

              leading: const Icon(Icons.language),

              title: const Text("Language"),

              subtitle: Text(language),

              trailing: DropdownButton<String>(

                value: language,

                items: const [

                  DropdownMenuItem(
                    value: "English",
                    child: Text("English"),
                  ),

                  DropdownMenuItem(
                    value: "Hindi",
                    child: Text("Hindi"),
                  ),

                ],

                onChanged: (value) {

                  setState(() {
                    language = value!;

                   
                  });

                },

              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Privacy Policy"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About App"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {

                showAboutDialog(
                  context: context,
                  applicationName: "AgriVision AI",
                  applicationVersion: "1.0.0",
                  applicationLegalese: "© 2026 AgriVision AI Team",
                );

              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.help),
              title: const Text("Help & Support"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(

            width: double.infinity,
            height: 55,

            child: ElevatedButton.icon(

              icon: const Icon(Icons.logout),

              label: const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),

              onPressed: () {

                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                );

              },

            ),
          ),

          const SizedBox(height: 20),

          // Logout button
ElevatedButton.icon(
  icon: const Icon(Icons.logout),
  label: const Text("Logout"),
  onPressed: () async {
    await StorageService.logout();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  },
),

        ],
      ),
    );
  }
}