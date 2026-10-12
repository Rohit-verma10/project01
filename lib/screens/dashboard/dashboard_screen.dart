import 'package:flutter/material.dart';

import '../../services/storage_service.dart';

const _forest = Color(0xFF173D2A);
const _green = Color(0xFF2E7D4F);
const _canvas = Color(0xFFF5F7F1);

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmerName = StorageService.getFarmerName().trim();
    final crop = StorageService.getCrop();
    final area = StorageService.getFarmArea();
    final sowingDate = StorageService.getSowingDate();

    return Scaffold(
      backgroundColor: _canvas,
      appBar: AppBar(
        backgroundColor: _canvas,
        foregroundColor: _forest,
        elevation: 0,
        titleSpacing: 20,
        title: const Row(
          children: [
            Icon(Icons.eco_rounded, color: _green),
            SizedBox(width: 9),
            Text('AgriVision', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.tune_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _DashboardDrawer(farmerName: farmerName),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    'Good day${farmerName.isEmpty ? '' : ', ${farmerName.split(' ').first}'}',
                    style: const TextStyle(
                      color: _forest,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'A clearer view of your farm starts here.',
                    style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 22),
                  _FarmOverviewCard(crop: crop, area: area, sowingDate: sowingDate),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Your farm tools', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: _forest)),
                      ),
                      Text('8 tools', style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _ActionCard(
                    title: 'Farm registration',
                    subtitle: 'Add or update your farm details',
                    icon: Icons.add_location_alt_rounded,
                    color: const Color(0xFF4B8C58),
                    onTap: () => Navigator.pushNamed(context, '/Farm Registration'),
                  ),
                  _ActionCard(
                    title: 'Weather',
                    subtitle: 'Conditions and forecast for your area',
                    icon: Icons.wb_cloudy_rounded,
                    color: const Color(0xFF4287A5),
                    onTap: () => Navigator.pushNamed(context, '/weather'),
                  ),
                  _ActionCard(
                    title: 'Yield prediction',
                    subtitle: 'Explore your expected harvest',
                    icon: Icons.insights_rounded,
                    color: const Color(0xFFB17B37),
                    onTap: () => Navigator.pushNamed(context, '/yield'),
                  ),
                  _ActionCard(
                    title: 'Disease detection',
                    subtitle: 'Check crop health from a leaf photo',
                    icon: Icons.biotech_rounded,
                    color: const Color(0xFFAC5E4C),
                    onTap: () => Navigator.pushNamed(context, '/disease'),
                  ),
                  _ActionCard(
                    title: 'Reports',
                    subtitle: 'Review your farm insights',
                    icon: Icons.description_rounded,
                    color: const Color(0xFF7166A8),
                    onTap: () => Navigator.pushNamed(context, '/reports'),
                  ),
                  _ActionCard(
                    title: 'News & alerts',
                    subtitle: 'Updates that matter to your farm',
                    icon: Icons.notifications_active_rounded,
                    color: const Color(0xFFC27C3D),
                    onTap: () => Navigator.pushNamed(context, '/news'),
                  ),
                  _ActionCard(
                    title: 'AI assistant',
                    subtitle: 'Get help with everyday farm questions',
                    icon: Icons.auto_awesome_rounded,
                    color: const Color(0xFF43857E),
                    onTap: () => Navigator.pushNamed(context, '/assistant'),
                  ),
                  _ActionCard(
                    title: 'Settings',
                    subtitle: 'Manage your preferences and account',
                    icon: Icons.settings_rounded,
                    color: const Color(0xFF64727B),
                    onTap: () => Navigator.pushNamed(context, '/settings'),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE1EFE3),
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 2) Navigator.pushNamed(context, '/reports');
          if (index == 3) Navigator.pushNamed(context, '/settings');
          if (index == 1) Navigator.pushNamed(context, '/assistant');
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome_rounded), label: 'Assistant'),
          NavigationDestination(icon: Icon(Icons.description_outlined), selectedIcon: Icon(Icons.description_rounded), label: 'Reports'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }

}

class _FarmOverviewCard extends StatelessWidget {
  const _FarmOverviewCard({required this.crop, required this.area, required this.sowingDate});

  final String crop;
  final String area;
  final String sowingDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_forest, Color(0xFF2E7048)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: _forest.withValues(alpha: 0.18), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: Text('FARM OVERVIEW', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
                child: const Row(children: [Icon(Icons.circle, color: Color(0xFF9BE2A6), size: 8), SizedBox(width: 6), Text('Your farm', style: TextStyle(color: Colors.white, fontSize: 11))]),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Text(crop.isEmpty ? 'Let’s set up your farm' : crop,
              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(area.isEmpty ? 'Add farm details to see your overview' : '$area hectares · Growing season',
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 22),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.18)),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.calendar_month_rounded, color: Color(0xFFA9D7AE), size: 19),
              const SizedBox(width: 8),
              Text(sowingDate.isEmpty ? 'Sowing date not set' : 'Sown $sowingDate', style: const TextStyle(color: Colors.white, fontSize: 12)),
              const Spacer(),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white70, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap});

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFE8ECE5))),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(15)),
                child: Icon(icon, color: color, size: 23),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: _forest, fontWeight: FontWeight.w700, fontSize: 14)),
                    const SizedBox(height: 3),
                    Text(subtitle, style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 11)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 15, color: Colors.blueGrey.shade300),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardDrawer extends StatelessWidget {
  const _DashboardDrawer({required this.farmerName});

  final String farmerName;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: _canvas,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 30, 22, 24),
              decoration: const BoxDecoration(color: _forest, borderRadius: BorderRadius.only(bottomRight: Radius.circular(26))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const CircleAvatar(radius: 26, backgroundColor: Colors.white24, child: Icon(Icons.person_rounded, color: Colors.white)),
                const SizedBox(height: 13),
                Text(farmerName.isEmpty ? 'Farmer' : farmerName, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                const Text('Your AgriVision account', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 12),
            _drawerItem(context, Icons.home_rounded, 'Home', null),
            _drawerItem(context, Icons.agriculture_rounded, 'Farm registration', '/Farm Registration'),
            _drawerItem(context, Icons.cloud_rounded, 'Weather', '/weather'),
            _drawerItem(context, Icons.biotech_rounded, 'Disease detection', '/disease'),
            _drawerItem(context, Icons.auto_awesome_rounded, 'AI assistant', '/assistant'),
            _drawerItem(context, Icons.description_rounded, 'Reports', '/reports'),
            _drawerItem(context, Icons.settings_rounded, 'Settings', '/settings'),
            const Spacer(),
            _drawerItem(context, Icons.logout_rounded, 'Log out', '/login'),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String label, String? route) {
    return ListTile(
      leading: Icon(icon, color: route == null ? _green : Colors.blueGrey.shade600),
      title: Text(label, style: TextStyle(color: _forest, fontWeight: route == null ? FontWeight.w700 : FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        if (route == '/login') {
          StorageService.logout().then((_) {
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(context, '/login', (item) => false);
          });
        } else if (route != null) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}

