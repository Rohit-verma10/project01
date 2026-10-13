import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  Widget reportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onDownload,
  }) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),

        leading: CircleAvatar(
          radius: 28,
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(
            icon,
            color: color,
            size: 30,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(subtitle),
        ),

        trailing: IconButton(
          icon: const Icon(Icons.download),
          color: Colors.green,
          onPressed: onDownload,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF5F8F2),

      appBar: AppBar(
       title: const Text(
  ("reports"),
       ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff2E7D32),
                    Color(0xff66BB6A),
                  ],
                ),

                borderRadius: BorderRadius.circular(20),
              ),

              child: const Column(
                children: [

                  Icon(
                    Icons.description,
                    color: Colors.white,
                    size: 70,
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Farm Reports",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Generate and download detailed AI reports",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 25),

            reportCard(
              icon: Icons.eco,
              title: "Crop Health Report",
              subtitle:
                  "AI analysis of crop health and vegetation.",
              color: Colors.green,
              onDownload: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Crop Health Report Downloaded",
                    ),
                  ),
                );
              },
            ),

            reportCard(
              icon: Icons.analytics,
              title: "Yield Report",
              subtitle:
                  "Predicted crop production and harvest details.",
              color: Colors.blue,
              onDownload: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Yield Report Downloaded",
                    ),
                  ),
                );
              },
            ),

            reportCard(
              icon: Icons.cloud,
              title: "Weather Report",
              subtitle:
                  "Weekly weather analysis and forecast.",
              color: Colors.orange,
              onDownload: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Weather Report Downloaded",
                    ),
                  ),
                );
              },
            ),

            reportCard(
              icon: Icons.currency_rupee,
              title: "Profit Report",
              subtitle:
                  "Estimated income and profit analysis.",
              color: Colors.purple,
              onDownload: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Profit Report Downloaded",
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text(
                  "Download All Reports",
                  style: TextStyle(fontSize: 18),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),

                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "All Reports Downloaded Successfully",
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
