import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:spynetra_tmp/constants/constants.dart';

class DocumentDetailScreen extends StatefulWidget {
  final Map<String, String> document;

  const DocumentDetailScreen({super.key, required this.document});

  @override
  DocumentDetailScreenState createState() => DocumentDetailScreenState();
}

class DocumentDetailScreenState extends State<DocumentDetailScreen> {
  String? _selectedFileName;
  File? _selectedFile;
  bool _isUploading = false;
  Map<String, dynamic>? _apiResponse;

  @override
  void initState() {
    super.initState();
    _fetchDocumentDetails();
  }

  // Method to fetch document details from API
  Future<void> _fetchDocumentDetails() async {
    const url = 'http://10.0.2.2:5001/download';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _apiResponse = json.decode(response.body);
        });
      } else {
        print('Failed to download!');
      }
    } catch (e) {
      print('error ${e}');
    }
  }

  // Method to allow the user to pick a zip file
  Future<void> _pickZipFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result != null) {
      setState(() {
        _selectedFileName = result.files.single.name;
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  // Method to upload the selected file to the backend
  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      print('No file selected');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final uri = Uri.parse('http://10.0.2.2:5001/upload');
      final request = http.MultipartRequest('POST', uri);
      final fileStream = http.ByteStream(_selectedFile!.openRead());
      final fileLength = await _selectedFile!.length();

      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: basename(_selectedFile!.path),
        contentType: MediaType('application', 'zip'),
      );

      request.files.add(multipartFile);

      final response = await request.send();

      if (response.statusCode == 200) {
        print('File upload successfully');
      } else {
        print('File upload failed!');
      }
    } catch (e) {
      print("Error: ${e}");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.screen,
      appBar: AppBar(
        backgroundColor: Pallete.appbar,
        title: const Text(
          'Document Details',
          style: TextStyle(color: Pallete.text),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_apiResponse != null) _buildDocumentDetails(),
            const SizedBox(height: 20.0),
            _buildFileUploadSection(),
            const SizedBox(height: 20.0),
            if (_isUploading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  // Widget to display document details
  Widget _buildDocumentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title: ${_apiResponse!['title']}',
          style: const TextStyle(fontSize: 16.0, color: Pallete.text),
        ),
        const SizedBox(height: 10.0),
        Text(
          'Description: ${_apiResponse!['description']}',
          style: const TextStyle(fontSize: 16.0, color: Pallete.text),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  // Widget to build the file upload section
  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20.0),
        Center(
          child: ElevatedButton.icon(
            onPressed: _pickZipFile,
            icon: const Icon(Icons.upload_file),
            label: const Text('Select Zip File'),
          ),
        ),
        const SizedBox(height: 10.0),
        if (_selectedFileName != null)
          Text(
            'Selected File: $_selectedFileName',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: 20.0),
        if (_selectedFile != null)
          Center(
            child: ElevatedButton.icon(
              onPressed: _uploadFile,
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Upload File'),
            ),
          ),
      ],
    );
  }
}
