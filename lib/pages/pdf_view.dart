import 'dart:io'; // For File operations
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Import for MediaType
import 'package:path/path.dart';
import 'package:spynetra_tmp/constants/constants.dart'; // For file path operations

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

  // Allow the user to pick a zip file
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

  // Function to upload the selected file to the backend
  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('No file selected')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final uri = Uri.parse('https://your-backend-api.com/upload');
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

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        // Success
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(content: Text('File uploaded successfully')),
        );
      } else {
        // Failure
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(content: Text('File upload failed')),
        );
      }
    } catch (e) {
      // Error
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
            Text('URL: ${widget.document['url']}',
                style: const TextStyle(fontSize: 16.0, color: Pallete.text)),
            const SizedBox(height: 10.0),
            Text('Username: ${widget.document['username']}',
                style: const TextStyle(fontSize: 16.0, color: Pallete.text)),
            const SizedBox(height: 10.0),
            Text('Password: ${widget.document['password']}',
                style: const TextStyle(fontSize: 16.0, color: Colors.red)),
            const SizedBox(height: 20.0),
            _buildFileUploadSection(),
            const SizedBox(height: 20.0),
            if (_isUploading) const Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }

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
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
