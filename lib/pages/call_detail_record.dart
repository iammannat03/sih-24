import 'package:flutter/material.dart';

class CallDetailRecord extends StatefulWidget {
  const CallDetailRecord({super.key});

  @override
  _CallDetailRecordState createState() => _CallDetailRecordState();
}

class _CallDetailRecordState extends State<CallDetailRecord> {
  // Hardcoded list of call records
  final List<Map<String, String>> callRecords = [
    {
      'caller': ' Mannat Jaiswal',
      'time': '10:30 AM',
      'duration': '5 mins',
      'status': 'Completed',
    },
    {
      'caller': 'Lakshay Mehta',
      'time': '11:15 AM',
      'duration': '2 mins',
      'status': 'Missed',
    },
    {
      'caller': 'Aditi Sharma',
      'time': '12:00 PM',
      'duration': '55 mins',
      'status': 'Completed',
    },
    {
      'caller': 'Rahul Singh',
      'time': '1:45 PM',
      'duration': '3 mins',
      'status': 'Missed',
    },
  ];

  List<Map<String, String>> filteredRecords = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredRecords = callRecords;
    _searchController.addListener(_filterRecords);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRecords() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredRecords = callRecords
          .where((record) =>
              record['caller']!.toLowerCase().contains(query) ||
              record['status']!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Detail Records'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Calls',
                hintText: 'Enter caller name or status',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredRecords.length,
              itemBuilder: (context, index) {
                final record = filteredRecords[index];
                return _buildCallRecordTile(record);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallRecordTile(Map<String, String> record) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              record['status'] == 'Missed' ? Colors.red : Colors.green,
          child: Icon(
            record['status'] == 'Missed' ? Icons.call_missed : Icons.phone,
            color: Colors.white,
          ),
        ),
        title: Text(record['caller'] ?? '',
            style:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text('Time: ${record['time']}',
                style: const TextStyle(fontSize: 14.0)),
            const SizedBox(height: 3),
            Text('Duration: ${record['duration']}',
                style: const TextStyle(fontSize: 14.0)),
          ],
        ),
        trailing: Text(record['status'] ?? '',
            style: TextStyle(
                fontSize: 14.0,
                color: record['status'] == 'Missed' ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
