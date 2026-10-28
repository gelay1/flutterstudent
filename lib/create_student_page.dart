import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateStudentPage extends StatefulWidget {
  const CreateStudentPage({super.key});

  @override
  State<CreateStudentPage> createState() => _CreateStudentPageState();
}

class _CreateStudentPageState extends State<CreateStudentPage> {
  final studentNoController = TextEditingController();
  final nameController = TextEditingController();
  final courseController = TextEditingController();

  Future<void> createStudent() async {
    final studentNo = studentNoController.text.trim();
    final name = nameController.text.trim();
    final course = courseController.text.trim();

    if (studentNo.isEmpty || name.isEmpty || course.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('Students').add({
      'student_no': studentNo,
      'name': name,
      'course': course,
      'createdat': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Student Created Successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    studentNoController.dispose();
    nameController.dispose();
    courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Student'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            TextField(
              controller: studentNoController,
              decoration: const InputDecoration(
                labelText: 'Student No.',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: courseController,
              decoration: const InputDecoration(
                labelText: 'Course',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: createStudent,

                child: const Text(
                  'Create Student',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
