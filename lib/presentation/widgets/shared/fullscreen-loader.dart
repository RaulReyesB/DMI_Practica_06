import 'package:flutter/material.dart';

class FullscreenLoader extends StatelessWidget {
  const FullscreenLoader({super.key});

  // Definir correctamente el Stream
  Stream<String> getLoadingMessages() {
    final messages = <String>[
      'Estableciendo elementos de Comunicación...',
      'Conectando a la API de The MovieDB ...',
      'Obteniendo las películas que actualmente se proyectan...',
      'Obteniendo los próximos estrenos...',
      'Todo listo... Comencemos',
    ];

    return Stream.periodic(const Duration(seconds: 3), (step) {
      return messages[step % messages.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Bienvenid@ a Cinemapedia-220219'),
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 4),
          const SizedBox(height: 10),
          StreamBuilder<String>(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('Cargando...');
              }
              return Text(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}
