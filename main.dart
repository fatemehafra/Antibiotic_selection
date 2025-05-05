import 'package:flutter/material.dart';

void main() {
  runApp(AntibioticApp());
}

class AntibioticApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Antibiotic Selection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PatientInfoPage(),
    );
  }
}

class PatientInfoPage extends StatefulWidget {
  @override
  _PatientInfoPageState createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage> {
  String? selectedSex;
  final weightController = TextEditingController();
  final clCrController = TextEditingController();
  final heightController = TextEditingController();
  bool isObese = false;

  double? bmi;
  double? ibw;
  double? adbw;

  void calculateWeights() {
    double weight = double.tryParse(weightController.text) ?? 0;
    double height = double.tryParse(heightController.text) ?? 0;

    if (height <= 0 || selectedSex == null) return;

    double heightInM = height / 100;
    bmi = weight / (heightInM * heightInM);

    if (selectedSex == 'Male') {
      ibw = 50 + 0.9 * (height - 152);
    } else {
      ibw = 45.5 + 0.9 * (height - 152);
    }

    adbw = ibw! + 0.4 * (weight - ibw!);
  }

  void goToInfectionSelection() {
    calculateWeights();
    double weight = double.tryParse(weightController.text) ?? 0;
    double clcr = double.tryParse(clCrController.text) ?? 0;
    double height = double.tryParse(heightController.text) ?? 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InfectionSelectionPage(
          weight: weight,
          clCr: clcr,
          isObese: isObese,
          height: height,
          sex: selectedSex ?? 'Male',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    calculateWeights();
    return Scaffold(
      appBar: AppBar(title: Text('Patient Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              onChanged: (_) => setState(() => calculateWeights()),
            ),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Height (cm)'),
              onChanged: (_) => setState(() => calculateWeights()),
            ),
            TextField(
              controller: clCrController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'ClCr (ml/min)'),
            ),
            CheckboxListTile(
              title: Text('Obese (use Adjusted BW)'),
              value: isObese,
              onChanged: (val) {
                setState(() {
                  isObese = val ?? false;
                });
              },
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Sex'),
              value: selectedSex,
              items: ['Male', 'Female']
                  .map((sex) => DropdownMenuItem(value: sex, child: Text(sex)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSex = value;
                  calculateWeights();
                });
              },
            ),
            if (selectedSex != null && bmi != null && ibw != null && adbw != null) ...[
              SizedBox(height: 16),
              Text('BMI: ${bmi!.toStringAsFixed(1)}'),
              Text('IBW: ${ibw!.toStringAsFixed(1)} kg'),
              Text('AdBW: ${adbw!.toStringAsFixed(1)} kg'),
            ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: goToInfectionSelection,
              child: Text('Next'),
            ),
            SizedBox(height: 24),
            Divider(),
            Text(
              'فرمول‌های آموزشی:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text('BMI = وزن (kg) ÷ [قد (m)]²'),
            Text('IBW (مرد) = 50 + 0.9 × (قد (cm) - 152)'),
            Text('IBW (زن) = 45.5 + 0.9 × (قد (cm) - 152)'),
            Text('AdBW = IBW + 0.4 × (وزن واقعی - IBW)'),
          ],
        ),
      ),
    );
  }
}
