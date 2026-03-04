import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/auth_service.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .orderBy('username')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        final currentUid = AuthService.currentUser?.uid;
        final users = snapshot.data!.docs
            .where((doc) => doc.id != currentUid) // esconde o próprio user
            .toList();

        if (users.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        return ListView.separated(
          itemCount: users.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final data = users[index].data() as Map<String, dynamic>;
            final username = (data['username'] ?? '') as String;
            final photoUrl = data['photoUrl'];

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                child: photoUrl == null ? const Icon(Icons.person) : null,
              ),
              title: Text(
                username,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                // depois: abrir perfil público
              },
            );
          },
        );
      },
    );
  }
}