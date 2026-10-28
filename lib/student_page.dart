import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'create_student_page.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

  Future<void> deleteStudent(BuildContext context, String documentId) async {
    // Confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Student'),
          content: const Text('Are you sure you want to delete this student?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('Students')
          .doc(documentId)
          .delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student deleted successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Student Page'),
        leading: const BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateStudentPage(),
                  ),
                );
              },
              child: const Text('Create'),
            ),
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Students').snapshots(),

        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // No data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No students found', style: TextStyle(fontSize: 18)),
            );
          }

          final students = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),

            itemCount: students.length,

            itemBuilder: (context, index) {
              final student = students[index];

              final studentNo = student['student_no'] ?? '';

              final name = student['name'] ?? '';

              final course = student['course'] ?? '';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(12),

                  child: Row(
                    children: [
                      // Student avatar
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.lightBlue.shade100,
                        child: const Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 32,
                        ),
                      ),

                      const SizedBox(width: 14),

                      // Student information
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              studentNo,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(name, style: const TextStyle(fontSize: 16)),

                            const SizedBox(height: 3),

                            Text(
                              course,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // DELETE ONLY
                      IconButton(
                        onPressed: () {
                          deleteStudent(context, student.id);
                        },

                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
