import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

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
    final bytess = response.bodyBytes;
    setState(() {
      pdfUrl = bytess;
    });
  }

  void _openFileFromBytes(Uint8List bytes) async {
    if (kIsWeb) {
      final _base64 = base64Encode(bytes);
      // Create the link with the file
      final anchor = html.AnchorElement(
          href: 'data:application/octet-stream;base64,$_base64')
        ..target = 'blank';
      // add the name

      anchor.download = 'report.pdf';

      // trigger download
      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();
      return;
    }
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/report.pdf').create();
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        _openFileFromBytes(pdfUrl);
      },
      icon: const Icon(Icons.receipt_long),
      label: const Text('Get a report'),
    );
  }
}
