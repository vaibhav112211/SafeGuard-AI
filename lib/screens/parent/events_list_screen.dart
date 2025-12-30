import 'package:flutter/material.dart';
import 'event_detail_screen.dart';

class EventsListScreen extends StatefulWidget {
  const EventsListScreen({super.key});

  @override
  State<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  // Mock events data
  final List<Map<String, dynamic>> events = [
    {
      'id': 1,
      'title': 'School Sports Day',
      'date': '2025-01-15',
      'time': '09:00 AM',
      'location': 'School Playground',
      'category': 'Sports',
      'childName': 'John',
      'status': 'Upcoming',
      'description': 'Annual sports day with various competitions',
    },
    {
      'id': 2,
      'title': 'Parent-Teacher Meeting',
      'date': '2025-01-20',
      'time': '03:00 PM',
      'location': 'School Auditorium',
      'category': 'Academic',
      'childName': 'Emma',
      'status': 'Upcoming',
      'description': 'Discuss academic progress and concerns',
    },
    {
      'id': 3,
      'title': 'Science Fair',
      'date': '2025-01-25',
      'time': '10:00 AM',
      'location': 'Science Lab',
      'category': 'Academic',
      'childName': 'John',
      'status': 'Upcoming',
      'description': 'Exhibition of student science projects',
    },
    {
      'id': 4,
      'title': 'Art Competition',
      'date': '2024-12-20',
      'time': '11:00 AM',
      'location': 'Art Room',
      'category': 'Arts',
      'childName': 'Emma',
      'status': 'Completed',
      'description': 'Drawing and painting competition',
    },
  ];

  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredEvents =
    selectedFilter == 'All'
        ? events
        : events
        .where((e) => e['category'] == selectedFilter)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add event feature coming soon!'),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // FILTER CHIPS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.grey[100],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  _buildFilterChip('Sports'),
                  _buildFilterChip('Academic'),
                  _buildFilterChip('Arts'),
                  _buildFilterChip('Other'),
                ],
              ),
            ),
          ),

          // EVENTS LIST
          Expanded(
            child: filteredEvents.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                return _buildEventCard(filteredEvents[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------- UI HELPERS ----------

  Widget _buildFilterChip(String label) {
    final bool isSelected = selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() => selectedFilter = label);
        },
        selectedColor: Colors.blue[100],
        labelStyle: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final Color categoryColor = _getCategoryColor(event['category']);
    final bool isCompleted = event['status'] == 'Completed';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventDetailsScreen(event: event),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildCategoryTag(event['category'], categoryColor),
                  const Spacer(),
                  _buildStatusTag(event['status'], isCompleted),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                event['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.person, event['childName']),
              _buildInfoRow(Icons.calendar_today, event['date']),
              _buildInfoRow(Icons.access_time, event['time']),
              _buildInfoRow(Icons.location_on, event['location']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatusTag(String text, bool completed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: completed ? Colors.grey[300] : Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: completed ? Colors.grey[700] : Colors.green[900],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No events found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Sports':
        return Colors.orange;
      case 'Academic':
        return Colors.blue;
      case 'Arts':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
