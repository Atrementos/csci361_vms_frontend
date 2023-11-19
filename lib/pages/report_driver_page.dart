import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
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
  Uint8List pdfUrl = Uint8List(0);

  @override
  void initState() {
    super.initState();
    loadPdfFromApi();
  }

  void loadPdfFromApi() async {
    final url =
        Uri.http('vms-api.madi-wka.xyz', '/report/pdf/${widget.driverId}');
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${ref.read(jwt.jwtTokenProvider)}',
      },
    );
    final bytes = response.bodyBytes;
    setState(() {
      pdfUrl = bytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report on driver ${widget.driverId}'),
      ),
      body: PDFView(
        filePath: null,
        pdfData: pdfUrl,
      ),
    );
  }
}
