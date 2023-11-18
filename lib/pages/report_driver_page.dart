import 'dart:convert';
import 'dart:io';

import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ReportDriverPage extends ConsumerStatefulWidget {
  final int driverId;

  const ReportDriverPage({super.key, required this.driverId});

  @override
  ConsumerState<ReportDriverPage> createState() {
    return _ReportDriverPageState();
  }
}

class _ReportDriverPageState extends ConsumerState<ReportDriverPage> {
  String reportData = '';

  @override
  void initState() {
    super.initState();
    makeReport();
  }

  void makeReport() async {
    final url = Uri.http(
        'vms-api.madi-wka.xyz/', '/report/jobsdone/${widget.driverId}');
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${ref.read(jwt.jwtTokenProvider)}',
      },
    );
    var decodedResponse = json.decode(response.body);
    setState(() {
      reportData = decodedResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report on driver ${widget.driverId}'),
      ),
      body: Column(
        children: [
          Text(reportData),
        ],
      ),
    );
  }
}
