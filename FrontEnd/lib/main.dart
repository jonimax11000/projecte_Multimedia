import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter/rendering.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  debugPaintSizeEnabled =
      false; // Per veure els layouts. Requereix rendering.dart
=======
import 'injection_container.dart' as di;
import 'features/presentation/widgets/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
>>>>>>> origin/guillem
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      title: 'Exercici. Disseny responsiu i reactiu',
      debugShowCheckedModeBanner: false,
      // Definim el tema de l'aplicacicó. Fem ús de l'esquema de colors Teal
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.amberAccent),
      // Widget principal
      home: HomeScreen(),
    );
  }
}
=======
      debugShowCheckedModeBanner: false,
      title: 'Videos App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
>>>>>>> origin/guillem
