import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CoalTripForm extends StatefulWidget {
  final void Function() onSubmit;

  const CoalTripForm({super.key, required this.onSubmit});

  @override
  State<CoalTripForm> createState() => _CoalTripFormState();
}

class _CoalTripFormState extends State<CoalTripForm> {
  final _formKey = GlobalKey<FormState>();

  final weightAController = TextEditingController();
  final weightBController = TextEditingController();
  final weightCController = TextEditingController();
  final totalWeightController = TextEditingController();

  final tripAController = TextEditingController();
  final tripBController = TextEditingController();
  final tripCController = TextEditingController();
  final totalTripsController = TextEditingController();

  String selectedDoorNo = 'Door-1';
  DateTime selectedDate = DateTime.now();

  final List<String> doorNumbers = [
    for (int i = 1; i <= 50; i++) 'Door-$i',
    'MP65H0350',
    'MP65H0351',
    'MP65H0352',
    'CG12B80484',
    'CG12B80486',
  ];

  String _fmtDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  @override
  void initState() {
    super.initState();
    for (final c in [weightAController, weightBController, weightCController]) {
      c.addListener(_updateTotals);
    }
    for (final c in [tripAController, tripBController, tripCController]) {
      c.addListener(_updateTotals);
    }
  }

  @override
  void dispose() {
    weightAController.dispose();
    weightBController.dispose();
    weightCController.dispose();
    totalWeightController.dispose();
    tripAController.dispose();
    tripBController.dispose();
    tripCController.dispose();
    totalTripsController.dispose();
    super.dispose();
  }

  void _updateTotals() {
    final wA = int.tryParse(weightAController.text) ?? 0;
    final wB = int.tryParse(weightBController.text) ?? 0;
    final wC = int.tryParse(weightCController.text) ?? 0;
    totalWeightController.text = (wA + wB + wC).toString();

    final tA = int.tryParse(tripAController.text) ?? 0;
    final tB = int.tryParse(tripBController.text) ?? 0;
    final tC = int.tryParse(tripCController.text) ?? 0;
    totalTripsController.text = (tA + tB + tC).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _pickDate,
            child: AbsorbPointer(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Date'),
                controller: TextEditingController(text: _fmtDate(selectedDate)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedDoorNo,
            decoration: const InputDecoration(labelText: 'Door No.'),
            items: doorNumbers
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: (v) => setState(() => selectedDoorNo = v!),
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(child: Text('Shift')),
              SizedBox(width: 8),
              Expanded(child: Text('No. of Trips')),
              SizedBox(width: 8),
              Expanded(child: Text('Weight (kg)')),
            ],
          ),
          const SizedBox(height: 8),
          _shiftRow('A', tripAController, weightAController),
          const SizedBox(height: 8),
          _shiftRow('B', tripBController, weightBController),
          const SizedBox(height: 8),
          _shiftRow('C', tripCController, weightCController),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'TOTAL',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: totalTripsController,
                  readOnly: true,
                  decoration: const InputDecoration(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: totalWeightController,
                  readOnly: true,
                  decoration: const InputDecoration(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: _handleSubmit,
            child: const Text('SUBMIT'),
          ),
        ],
      ),
    );
  }

  Widget _shiftRow(String label, TextEditingController tripCtrl, TextEditingController weightCtrl) {
    return Row(
      children: [
        Expanded(child: Text('Shift $label')),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: tripCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: weightCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coal Trip Submitted')),
      );

      _formKey.currentState!.reset();

      for (final c in [
        weightAController,
        weightBController,
        weightCController,
        tripAController,
        tripBController,
        tripCController,
        totalWeightController,
        totalTripsController,
      ]) {
        c.clear();
      }
      setState(() => selectedDoorNo = 'Door-1');

      widget.onSubmit(); // 🔔 Notify main.dart
    }
  }
}
