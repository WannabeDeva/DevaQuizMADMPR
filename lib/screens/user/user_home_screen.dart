import 'package:flutter/material.dart';
import 'package:devaquiz/services/auth_service.dart';
import 'package:devaquiz/screens/welcome_screen.dart';
import 'package:devaquiz/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final AuthService _authService = AuthService();
  String _userName = 'User';
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  Future<void> _loadUserData() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
            
        if (doc.exists) {
          setState(() {
            _userName = doc.data()?['name'] ?? 'User';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
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
        title: const Text('User Dashboard'),
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
                      'Welcome, $_userName!',
                      style: headingStyle,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Available Quizzes will be shown here.',
                      style: bodyStyle,
                    ),
                  ),
                  // Quiz content will be added in future implementations
                ],
              ),
            ),
    );
  }
}