import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:digimag/utils/services/user_services.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _feedbackController = TextEditingController();
  final UserService _userService = UserService(); // Instance of UserService
  int _rating = 0; // To store star rating
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // Fetch user info when the page loads
  }

  /// **Fetch user name and email from Firestore and auto-fill fields**
  Future<void> _loadUserInfo() async {
    try {
      Map<String, String?> userInfo = await _userService.getUserInfo();
      setState(() {
        _nameController.text = userInfo['Name'] ?? 'Guest';
        _emailController.text = userInfo['Email'] ?? 'No email';
      });
    } catch (e) {
      log('Failed to load user info: $e');
    }
  }

  /// **Send Feedback via EmailJS Gmail API**
  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // EmailJS API details
    const serviceId = 'service_n1l8wdg'; 
    const templateId = 'template_welayn5'; 
    const userId = 'nPK05NiIdmRfWb5tF'; 
    const emailEndpoint = 'https://api.emailjs.com/api/v1.0/email/send';

    // Prepare email data
    final emailData = {
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'user_name': _nameController.text,
        'user_email': _emailController.text,
        'user_feedback': _feedbackController.text,
        'user_rating': '⭐' * _rating, // Pass star rating
        'to_email': 'riyanachwani220@gmail.com' // Send to email
      },
    };

    try {
      final response = await http.post(
        Uri.parse(emailEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(emailData),
      );

      if (response.statusCode == 200) {
        _showSnackBar('Feedback submitted successfully! Thank you 😊');
        _clearForm();
      } else {
        _showSnackBar('Failed to send feedback. Please try again.');
      }
    } catch (e) {
      _showSnackBar('An error occurred: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// **Show SnackBar message**
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  /// **Clear Form Fields**
  void _clearForm() {
    _feedbackController.clear();
    setState(() => _rating = 0);
  }

  /// **Build star rating widget**
  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () => setState(() => _rating = index + 1),
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 30,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'We value your feedback!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Please rate your experience:',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  _buildStarRating(), // ⭐ Star Rating Widget
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Your Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Your Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter your email';
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _feedbackController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Your Feedback',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your feedback' : null,
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.purple,
                            ),
                            onPressed: _submitFeedback,
                            child: const Text(
                              'Submit Feedback',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(
                                    0xFFFFFFFF,
                                  )),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
