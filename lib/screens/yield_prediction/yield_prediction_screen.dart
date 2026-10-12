import 'package:flutter/material.dart';

import '../../services/storage_service.dart';

const _yieldGreen = Color(0xFF2E7D4F);
const _yieldInk = Color(0xFF173D2A);

class YieldPredictionScreen extends StatefulWidget {
  const YieldPredictionScreen({super.key});

  @override
  State<YieldPredictionScreen> createState() => _YieldPredictionScreenState();
}

class _YieldPredictionScreenState extends State<YieldPredictionScreen> {
  static const _cropYields = <String, double>{
    'Wheat': 3.2,
    'Rice': 4.1,
    'Maize': 5.4,
    'Cotton': 2.1,
    'Sugarcane': 70,
    'Pulses': 1.4,
    'Soybean': 2.2,
  };

  final _areaController = TextEditingController();
  String _crop = 'Wheat';
  String _irrigation = 'Reliable';
  double _soilHealth = 0.65;
  bool _hasPrediction = false;
  String? _validationMessage;
  double _predictedTonnes = 0;
  double _lowTonnes = 0;
  double _highTonnes = 0;

  @override
  void initState() {
    super.initState();
    final savedCrop = StorageService.getCrop();
    if (_cropYields.containsKey(savedCrop)) _crop = savedCrop;
    final savedArea = double.tryParse(StorageService.getFarmArea());
    if (savedArea != null && savedArea > 0) {
      _areaController.text = savedArea.toString();
    }
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  void _calculatePrediction() {
    final area = double.tryParse(_areaController.text.trim());
    if (area == null || area <= 0) {
      setState(() {
        _validationMessage = 'Enter a farm area greater than zero hectares.';
        _hasPrediction = false;
      });
      return;
    }

    final irrigationFactor = switch (_irrigation) {
      'Reliable' => 1.0,
      'Limited' => 0.86,
      _ => 0.70,
    };
    final soilFactor = 0.78 + (_soilHealth * 0.34);
    final estimate = area * _cropYields[_crop]! * irrigationFactor * soilFactor;

    setState(() {
      _validationMessage = null;
      _hasPrediction = true;
      _predictedTonnes = estimate;
      _lowTonnes = estimate * 0.82;
      _highTonnes = estimate * 1.18;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yield prediction')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          final form = _buildForm(context);
          final result = _buildResult(context);

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: wide ? 32 : 20,
              vertical: 22,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIntro(context),
                    const SizedBox(height: 22),
                    if (wide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 6, child: form),
                          const SizedBox(width: 20),
                          Expanded(flex: 5, child: result),
                        ],
                      )
                    else ...[
                      form,
                      const SizedBox(height: 18),
                      result,
                    ],
                    const SizedBox(height: 18),
                    _buildNote(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [_yieldInk, Color(0xFF36764B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plan your harvest',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Add a few farm details to get a practical yield range.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(19),
            ),
            child: const Icon(Icons.grass_rounded, color: Colors.white, size: 31),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return _SectionCard(
      title: 'Farm details',
      subtitle: 'Use your current season information.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _crop,
            decoration: const InputDecoration(
              labelText: 'Crop',
              prefixIcon: Icon(Icons.grass_rounded),
            ),
            items: _cropYields.keys
                .map((crop) => DropdownMenuItem(value: crop, child: Text(crop)))
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _crop = value);
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _areaController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Farm area',
              hintText: 'For example, 2.5',
              suffixText: 'hectares',
              prefixIcon: Icon(Icons.crop_square_rounded),
            ),
          ),
          if (_validationMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _validationMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 20),
          const Text('Water availability', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 9),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Reliable', label: Text('Reliable')),
              ButtonSegment(value: 'Limited', label: Text('Limited')),
              ButtonSegment(value: 'Rain-fed', label: Text('Rain-fed')),
            ],
            selected: {_irrigation},
            onSelectionChanged: (selection) => setState(() => _irrigation = selection.first),
            showSelectedIcon: false,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(child: Text('Soil health', style: TextStyle(fontWeight: FontWeight.w700))),
              Text(_soilLabel, style: const TextStyle(color: _yieldGreen, fontWeight: FontWeight.w700)),
            ],
          ),
          Slider(
            value: _soilHealth,
            divisions: 2,
            label: _soilLabel,
            onChanged: (value) => setState(() => _soilHealth = value),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _calculatePrediction,
              icon: const Icon(Icons.auto_graph_rounded),
              label: const Text('Estimate my yield'),
            ),
          ),
        ],
      ),
    );
  }

  String get _soilLabel => switch (_soilHealth.round()) {
        0 => 'Needs care',
        1 => 'Average',
        _ => 'Healthy',
      };

  Widget _buildResult(BuildContext context) {
    return _SectionCard(
      title: 'Your estimate',
      subtitle: _hasPrediction ? 'Expected harvest for this season' : 'Your estimate will appear here.',
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: !_hasPrediction
            ? Container(
                key: const ValueKey('empty'),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F6EF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Icon(Icons.query_stats_rounded, size: 40, color: Colors.green.shade700),
                    const SizedBox(height: 10),
                    const Text('Ready when you are', style: TextStyle(fontWeight: FontWeight.w700, color: _yieldInk)),
                    const SizedBox(height: 5),
                    Text('Complete the farm details and tap estimate.', textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey.shade600)),
                  ],
                ),
              )
            : Column(
                key: const ValueKey('result'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_crop.toUpperCase(), style: const TextStyle(color: _yieldGreen, letterSpacing: 1.1, fontSize: 11, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 9),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${_predictedTonnes.toStringAsFixed(1)} tonnes',
                            style: const TextStyle(color: _yieldInk, fontSize: 32, fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('Expected range ${_lowTonnes.toStringAsFixed(1)}–${_highTonnes.toStringAsFixed(1)} tonnes', style: TextStyle(color: Colors.blueGrey.shade700, fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ResultDetail(label: 'Crop', value: _crop, icon: Icons.eco_outlined),
                  _ResultDetail(label: 'Area', value: '${_areaController.text} ha', icon: Icons.crop_free_rounded),
                  _ResultDetail(label: 'Water', value: _irrigation, icon: Icons.water_drop_outlined),
                ],
              ),
      ),
    );
  }

  Widget _buildNote(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFF9A6A21), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Planning estimate only. Actual harvest depends on seed variety, weather, pests, and local growing conditions. This screen uses typical crop baselines; it is not connected to a trained prediction model.',
              style: TextStyle(color: Color(0xFF725626), fontSize: 12, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.subtitle, required this.child});

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: Color(0xFFE4EAE1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: _yieldInk, fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 12)),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _ResultDetail extends StatelessWidget {
  const _ResultDetail({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: _yieldGreen),
          const SizedBox(width: 9),
          Expanded(child: Text(label, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 13))),
          Text(value, style: const TextStyle(color: _yieldInk, fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}
