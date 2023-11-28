import 'dart:convert';
import 'dart:io';
import 'package:csci361_vms_frontend/models/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class FuelingDetailsPage extends ConsumerStatefulWidget {
  final int vehicleId;

  const FuelingDetailsPage({Key? key, required this.vehicleId})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FuelingDetailsPageState();
  }
}

class _FuelingDetailsPageState extends ConsumerState<FuelingDetailsPage> {
  final formKey = GlobalKey<FormState>();
  Vehicle? currentVehicle;
  String _fuelingTask = "";
  String _description = "";
  String _date = "";
  String _cost = "";
  String _fuelRefilled = "";
  String _gasStationName = "";
  File? _beforeImage;
  File? _afterImage;
  bool datePicked = false;

  // Add controllers for the editable fields
  TextEditingController fuelAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadVehicleInfo();
  }

  void loadVehicleInfo() async {
    final url =
        Uri.parse('http://vms-api.madi-wka.xyz/vehicle/${widget.vehicleId}');
    final response = await http.get(url);
    Map<String, dynamic> decodedResponse = json.decode(response.body);
    setState(() {
      currentVehicle = Vehicle.fromJson(decodedResponse);

      // Optionally update the controller value
      fuelAmountController.text = currentVehicle!.fuel.toString();
    });
  }

  String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYWRpLnR1cmd1bm92QG51LmVkdS5reiIsImV4cCI6MTcwMTE5MzIwNH0.IXyt9_g5mangj9Px00fREGPTmkO6zXmCWV9qle2RyVg';

  Future<void> _editFuelAmount() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final Map<String, dynamic> queryParams = {
        "Model": currentVehicle!.model,
        "Year": currentVehicle!.year.toString(),
        "Fuel": fuelAmountController.text,
        "Capacity": currentVehicle!.sittingCapacity.toString(),
        "Type": currentVehicle!.type,
        "Mileage": currentVehicle!.mileage.toString(),
        "Status": currentVehicle!.status,
        "LicensePlate": currentVehicle!.licensePlate,
      };

      final url =
          Uri.parse('http://vms-api.madi-wka.xyz/vehicle/${widget.vehicleId}');
      var response =
          await http.put(url, body: jsonEncode(queryParams), headers: {
        'Authorization': "Bearer $token",
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
      });

      if (response.statusCode == 200) {
        loadVehicleInfo();
        fuelAmountController.text = currentVehicle!.fuel.toString();
      } else {
        throw Exception(response.body);
      }
    }
  }

  final imagepicker = ImagePicker();

  Future<void> _pickImageBefore() async {
    final pickedFile = await imagepicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _beforeImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _pickImageAfter() async {
    final pickedFile = await imagepicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _afterImage = File(pickedFile.path);
      }
    });
  }

  String intFixed(int n, int count) => n.toString().padLeft(count, "0");

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );
    if (picked != null && picked != selectedDate && selectedTime != null) {
      setState(() {
        selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        // _date =
        // '${intFixed(picked.year, 4)}-${intFixed(picked.month, 2)}-${intFixed(picked.day, 2)}T${intFixed(picked.hour, 2)}:${intFixed(picked.minute, 2)}:${intFixed(picked.second, 2)}.${intFixed(picked.millisecond, 3)}Z';
        datePicked = true;
      });
    }
  }

  void _submitTask() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final Map<String, dynamic> queryParams = {
        'VehicleId': widget.vehicleId.toString(),
        'Description': _description,
        'Date': DateFormat("yyyy-MM-ddTHH:mm:ssZ").format(selectedDate),
        'Cost': _cost,
        'FuelRefilled': _fuelRefilled,
        'GasStationName': _gasStationName,
      };
      final request = http.MultipartRequest(
          'POST', Uri.http('vms-api.madi-wka.xyz', '/fuel/', queryParams));
      request.headers.addAll({
        'Authorization': "Bearer ${ref.read(jwt.jwtTokenProvider)}",
        'Content-Type': 'application/json',
      });
      request.files.add(
          await http.MultipartFile.fromPath('ImageBefore', _beforeImage!.path));
      request.files.add(
          await http.MultipartFile.fromPath('ImageAfter', _afterImage!.path));

      final response = await request.send();
      var responseData = await http.Response.fromStream(response);
      print(response.statusCode);
      print(responseData.body);

      if (response.statusCode == 201) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fueling task creation failed.'),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fueling Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Fuel Amount: ${currentVehicle?.fuel}',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: fuelAmountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Fuel Amount',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a fuel amount';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    ElevatedButton(
                      onPressed: _editFuelAmount,
                      child: const Text('Change'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // if on mobile show the following
                Text(
                  'Fueling Task Details',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  onChanged: (value) {
                    _description = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(
                      context), // Call the _selectDate method on tap
                  controller: TextEditingController(
                      text: DateFormat("yyyy-MM-dd HH:mm").format(
                          selectedDate)), // Use a controller to display the selected date
                  validator: (value) {
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cost',
                  ),
                  onChanged: (value) {
                    _cost = value;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Fuel Refilled (in liters)',
                  ),
                  onChanged: (value) {
                    _fuelRefilled = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Gas Station Name',
                  ),
                  onChanged: (value) {
                    _gasStationName = value;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _pickImageBefore();
                      },
                      child: const Text('Upload Before Image'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        _pickImageAfter();
                      },
                      child: const Text('Upload After Image'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _submitTask();
                  },
                  child: const Text('Submit Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
