import 'package:flutter/material.dart';
import 'tests_screen.dart';
import 'mindfulness_screen.dart';
import 'social_chat_screen.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caja de Herramientas'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apoyo Rápido y Tests',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: const Icon(Icons.quiz_outlined, color: Colors.orange),
                title: const Text('Tests Psicométricos'),
                subtitle: const Text('Evalúa tu estado emocional.'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => const TestsScreen()));
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading:
                    const Icon(Icons.self_improvement, color: Colors.purple),
                title: const Text('Módulo de Ansiedad y Calma'),
                subtitle: const Text('Técnicas de Grounding y Meditación.'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const MindfulnessScreen()));
                },
              ),
            ),
            const Divider(height: 40),
            Text(
              'Conexión Social',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: const Icon(Icons.people_alt_outlined,
                    color: Colors.blueAccent),
                title: const Text('Chat de Conexión Anónima'),
                subtitle:
                    const Text('Chatea con otros usuarios que buscan apoyo.'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const SocialChatScreen()));
                },
              ),
            ),
            const Divider(height: 40),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Línea de ayuda en crisis: 911 o Línea de Vida.')));
                },
                icon:
                    const Icon(Icons.warning_amber_rounded, color: Colors.red),
                label: const Text('NECESITO AYUDA INMEDIATA',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
