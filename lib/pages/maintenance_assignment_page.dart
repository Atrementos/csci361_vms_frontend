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
    return dest.MaintenanceAssignmentPage(maintenanceAssignment: widget.maintenanceAssignment);
  }
}
