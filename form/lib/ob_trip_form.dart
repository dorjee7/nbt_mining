import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OBTripForm extends StatefulWidget {
  final void Function() onSubmit;

  const OBTripForm({super.key, required this.onSubmit});

  @override
  State<OBTripForm> createState() => _OBTripFormState();
}

class _OBTripFormState extends State<OBTripForm> {
  final _formKey = GlobalKey<FormState>();
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

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Date'),
                controller: TextEditingController(
                  text: _formatDate(selectedDate),
                ),
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
            onChanged: (d) => setState(() => selectedDoorNo = d!),
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(child: Divider(thickness: 1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Trips / Shift'),
              ),
              Expanded(child: Divider(thickness: 1)),
            ],
          ),
          const SizedBox(height: 10),
          _numericField('1st Shift(No. of trips)', tripAController),
          const SizedBox(height: 10),
          _numericField('2nd Shift(No. of trips)', tripBController),
          const SizedBox(height: 10),
          _numericField('3rd Shift(No. of trips)', tripCController),
          const SizedBox(height: 10),
          TextFormField(
            controller: totalTripsController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Total Trips',
              hintText: 'Auto-calculated from shifts',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _handleSubmit,
            child: const Text('SUBMIT'),
          ),
        ],
      ),
    );
  }

  Widget _numericField(String label, TextEditingController ctrl) {
    return TextFormField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(labelText: label),
      validator: (v) => (v == null || v.isEmpty) ? 'Enter value' : null,
      onChanged: (_) => _updateTotalTrips(),
    );
  }

  void _updateTotalTrips() {
    final a = int.tryParse(tripAController.text) ?? 0;
    final b = int.tryParse(tripBController.text) ?? 0;
    final c = int.tryParse(tripCController.text) ?? 0;
    totalTripsController.text = (a + b + c).toString();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'type': 'OB Trip Entry',
        'date': selectedDate,
        'door': selectedDoorNo,
        'tripA': int.parse(tripAController.text),
        'tripB': int.parse(tripBController.text),
        'tripC': int.parse(tripCController.text),
        'totalTrips': int.parse(totalTripsController.text),
      };

      debugPrint('OB Form data: $data');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form Submitted')),
      );

      _formKey.currentState!.reset();
      tripAController.clear();
      tripBController.clear();
      tripCController.clear();
      totalTripsController.clear();
      setState(() => selectedDoorNo = 'Door-1');

      widget.onSubmit(); // 🔔 Notify main.dart
    }
  }
}
