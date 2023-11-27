import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csci361_vms_frontend/models/maintenance_assignment.dart';
import 'package:csci361_vms_frontend/pages/maintenance_assignment_page_mob.dart'
if (dart.library.io) 'package:csci361_vms_frontend/pages/maintenance_assignment_page_mob.dart'
if (dart.library.html) 'package:csci361_vms_frontend/pages/maintenance_assignment_page_web.dart'
as dest;


class MaintenanceAssignmentPage extends ConsumerStatefulWidget {
  final MaintenanceAssignment maintenanceAssignment;

  const MaintenanceAssignmentPage({Key? key, required this.maintenanceAssignment}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends ConsumerState<MaintenanceAssignmentPage> {
  @override
  Widget build(BuildContext context) {
//<<<<<<< HEAD
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Assignment Details'),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         const SizedBox(
    //           height: 6,
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(12),
    //           child: Form(
    //             key: _formKey,
    //             child: Column(
    //               children: [
    //                 const SizedBox(
    //                   height: 8,
    //                 ),
    //                 Row(
    //                   children: [
    //                     const SizedBox(
    //                       width: 12,
    //                     ),
    //                     Expanded(
    //                       child: TextFormField(
    //                         controller: _carPartNameController,
    //                         decoration: const InputDecoration(
    //                           label: Text('Car Part Name'),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Row(
    //                   children: [
    //                     const SizedBox(
    //                       width: 12,
    //                     ),
    //                     Expanded(
    //                       child: TextFormField(
    //                         controller: _repairCostController,
    //                         keyboardType: TextInputType.number,
    //                         decoration: const InputDecoration(
    //                           label: Text('Repair Cost in Tenge'),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     const SizedBox(
    //                       width: 12,
    //                     ),
    //                     Expanded(
    //                       child: TextFormField(
    //                         controller: _carPartNumberController,
    //                         decoration: const InputDecoration(
    //                           label: Text('Car Part Number'),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     const SizedBox(
    //                       width: 12,
    //                     ),
    //                     Expanded(
    //                       child: TextFormField(
    //                         controller: _carPartConditionController,
    //                         decoration: const InputDecoration(
    //                           label: Text('Car Part Condition'),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         _selectedImage != null
    //             ? Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 20),
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(8),
    //             child: Image.file(
    //               //to show image, you type like this.
    //               File(_selectedImage!.path),
    //               fit: BoxFit.cover,
    //               width: MediaQuery
    //                   .of(context)
    //                   .size
    //                   .width,
    //               height: 300,
    //             ),
    //           ),
    //         )
    //             : const SizedBox(height: 10,),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: [
    //             ElevatedButton(
    //               onPressed: () {
    //                 _pickImage();
    //               },
    //               child: Text('Upload Photo'),
    //             ),
    //             ElevatedButton(
    //               onPressed: () {
    //                 setState(() {
    //                   _selectedImage = null;
    //                 });
    //               },
    //               child: Text('Delete Photo'),
    //             ),
    //           ],
    //         ),
    //         ElevatedButton(
    //           onPressed: _addCarPart,
    //           child: const Text('Add Car Part'),
    //         ),
    //         SizedBox(
    //           height: 12,
    //         ),
    //         Container(
    //           child: const Text("Uploaded Car Parts",
    //             style: TextStyle(color: Colors.white,
    //                 fontSize: 20, fontWeight: FontWeight.bold), ),
    //         ),
    //         ListView.builder(
    //           physics: const NeverScrollableScrollPhysics(),
    //           shrinkWrap: true,
    //           itemCount: _carParts.length,
    //           itemBuilder: (context, index) {
    //             return Container(
    //               margin: const EdgeInsets.symmetric(vertical: 8),
    //               padding: const EdgeInsets.all(12),
    //               decoration: BoxDecoration(
    //                 border: Border.all(color: Colors.grey),
    //                 borderRadius: BorderRadius.circular(8),
    //               ),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text('Car Part Name:   ${_carParts[index]['name']}',
    //                     style: const TextStyle(color: Colors.white,
    //                         fontSize: 15, fontWeight: FontWeight.w300),),
    //                   Text('Car Part Number:  ${_carParts[index]['number']}',
    //                     style: const TextStyle(color: Colors.white,
    //                         fontSize: 15, fontWeight: FontWeight.w300),),
    //                   Text('Car Part Cost:   ${_carParts[index]['cost']}',
    //                     style: const TextStyle(color: Colors.white,
    //                         fontSize: 15, fontWeight: FontWeight.w300),),
    //                   Text('Car Part Condition:   ${_carParts[index]['condition']}',
    //                     style: const TextStyle(color: Colors.white,
    //                         fontSize: 15, fontWeight: FontWeight.w300),),
    //                   if (_carParts[index]['photo'] != null)
    //                     Image.memory(_carParts[index]['photo']!),
    //                 ],
    //               ),
    //             );
    //           },),
    //       ],
    //     ),
    //   ),
    // );
    return dest.MaintenanceAssignmentPage(maintenanceAssignment: widget.maintenanceAssignment);
  }
}
