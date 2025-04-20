import 'package:flutter/material.dart';
import 'package:devaquiz/services/auth_service.dart';
import 'package:devaquiz/screens/welcome_screen.dart';
import 'package:devaquiz/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AuthService _authService = AuthService();
  String _adminName = 'Admin';
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }
  
  Future<void> _loadAdminData() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
            
        if (doc.exists) {
          setState(() {
            _adminName = doc.data()?['name'] ?? 'Admin';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading admin data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _signOut() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (route) => false,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'Welcome, $_adminName!',
                      style: headingStyle,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 20),
                  const Text(
                    'Admin Controls',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Quiz management controls will be added here
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.quiz),
                      title: const Text('Manage Quizzes'),
                      subtitle: const Text('Create, edit, and delete quizzes'),
                      onTap: () {
                        // Quiz management functionality will be implemented later
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Quiz management will be implemented soon')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.people),
                      title: const Text('Manage Users'),
                      subtitle: const Text('View user statistics and performance'),
                      onTap: () {
                        // User management functionality will be implemented later
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User management will be implemented soon')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}