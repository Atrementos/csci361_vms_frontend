import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csci361_vms_frontend/pages/report_driver_page_mob.dart'
    if (dart.library.io) 'package:csci361_vms_frontend/pages/report_driver_page_mob.dart'
    if (dart.library.html) 'package:csci361_vms_frontend/pages/report_driver_page_web.dart'
    as dest;

class ReportDriverPage extends ConsumerStatefulWidget {
  final int driverId;

  const ReportDriverPage({Key? key, required this.driverId}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends ConsumerState<ReportDriverPage> {
  @override
  Widget build(BuildContext context) {
    return dest.ReportDriverPage(driverId: widget.driverId);
  }
}
