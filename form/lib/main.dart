
import 'package:flutter/material.dart';
import 'coal_trip_form.dart';
import 'ob_trip_form.dart';

void main() => runApp(const TripEntryApp());

class TripEntryApp extends StatelessWidget {
  const TripEntryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Entry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 3, 10),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF1E293B),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      home: const TripSelectionScreen(),
    );
  }
}

class TripSelectionScreen extends StatefulWidget {
  const TripSelectionScreen({super.key});

  @override
  State<TripSelectionScreen> createState() => _TripSelectionScreenState();
}

class _TripSelectionScreenState extends State<TripSelectionScreen> {
  String selectedTripType = 'Coal Trip Entry';
  bool isSubmitted = false;

  void handleFormSubmission() {
    setState(() => isSubmitted = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isSubmitted = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          color: const Color(0xFF0F172A),
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: isSubmitted
                  ? const SizedBox(
                      height: 400,
                      child: Center(
                        child: Text(
                          'Submitted',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              // Add navigation logic if needed
                            },
                            child: const Text(
                              'Back',
                              style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 231, 138, 9)), // 🟡 Changed here
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: selectedTripType,
                          decoration: const InputDecoration(labelText: 'Trip Type'),
                          items: ['Coal Trip Entry', 'OB Trip Entry']
                              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                              .toList(),
                          onChanged: (value) {
                            setState(() => selectedTripType = value!);
                          },
                        ),
                        const SizedBox(height: 20),
                        if (selectedTripType == 'Coal Trip Entry')
                          CoalTripForm(onSubmit: handleFormSubmission)
                        else
                          OBTripForm(onSubmit: handleFormSubmission),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

