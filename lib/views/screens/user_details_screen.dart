import 'package:flutter/material.dart';
import 'package:randomuser/models/schemas/user.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                CircleAvatar(
                  radius: 50,
                  child: CircleAvatar(
                    radius: 50 - 2,
                    backgroundColor: Colors.deepPurple[300],
                    child: ClipOval(
                      child: Image.network(
                        user.picture,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.deepPurple[300],
                            child: const Center(
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text(
                      "Pseudo",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black45,
                      ),
                    ),
                    subtitle: Text(
                      user.username,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      user.gender == "male" ? Icons.face : Icons.face_2,
                    ),
                    title: const Text(
                      "Prénom et nom",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black45,
                      ),
                    ),
                    subtitle: Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_month_rounded),
                    title: const Text(
                      "Membre depuis le",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black45,
                      ),
                    ),
                    subtitle: Text(
                      "${user.registerDate.day}/${user.registerDate.month}/${user.registerDate.year}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.mail_rounded),
                    title: const Text(
                      "Mail",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black45,
                      ),
                    ),
                    subtitle: Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.location_on_rounded),
                    title: const Text(
                      "Habite à",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black45,
                      ),
                    ),
                    subtitle: Text(
                      '${user.city}, ${user.country}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
