import 'package:flutter/material.dart';
import '../db/db_helper.dart';

// Displays the last registered user as profile card
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil (último usuario)'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: DBHelper.instance.getLastUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final user = snapshot.data;

          if (user == null) {
            return const Center(
              child: Text('No hay usuarios registrados'),
            );
          }

          final nombre = (user['nombre'] ?? '').toString();
          final email = (user['email'] ?? '').toString();
          final telefono = (user['telefono'] ?? '').toString();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 38,
                        child: Text(
                          nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        nombre,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: Text(email),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('Teléfono'),
                        subtitle: Text(telefono),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}