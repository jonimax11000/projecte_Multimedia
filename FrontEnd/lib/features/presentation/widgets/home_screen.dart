import 'package:exercici_disseny_responsiu_stateful/features/presentation/widgets/my_container_widget.dart';
import 'package:exercici_disseny_responsiu_stateful/features/presentation/widgets/my_list_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Exemple amb OrientationBuilder
  final List<Map<String, dynamic>> llistaItems = [
    
  ];

  Map<String, dynamic>? currentFilm;

  _setFilm(Map<String, dynamic>? film) {
    setState(() {
      currentFilm = film;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Aquesta pantalla conté un scaffold amb la barra d'aplicacions i un cos
    return Scaffold(
      appBar: AppBar(title: const Text('OrientationBuilder Example')),
      // El body és un SafeArea: Widget que evita la interfície del sistema
      body: SafeArea(
        // Reacciona explícitament a canvis d’orientació del pare
        // Rebem orientation en el builder
        child: OrientationBuilder(
          builder: (context, orientation) {
            // isLandscape rep el valor de la comparació orientation==Orientation.landscape
            final isLandscape = orientation == Orientation.landscape;
            // Segons aquest, retornem un o altre arbre de widgets (ui declarativa)
            return isLandscape
                ? _sideBySideLayout(context, _setFilm)
                : _stackedLayout(context, _setFilm);
          },
        ),
      ),
    );
  }

  /* ============================
    Helpers de composició layout
    Els introduim com a mètodes del propi estat, per accedir a la informació necessària
   ============================ 
   */

  /// Disposició *top–bottom* (portrait): contenidor dalt, llista baix.
  ///
  Widget _stackedLayout(
    BuildContext context,
    Function(Map<String, dynamic>?) callback,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // El contenidor ocupa alçada intrínseca; la llista s’expandeix
          MyContainerWidget(film: currentFilm),
          const SizedBox(height: 12),
          Expanded(
            child: MyListWidget(items: llistaItems, callback: _setFilm),
          ),
        ],
      ),
    );
  }

  /// Disposició *side‑by‑side* (landscape): contenidor esquerra, llista dreta.
  Widget _sideBySideLayout(
    BuildContext context,
    Function(Map<String, dynamic>?) callback,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Flexible(flex: 2, child: MyContainerWidget(film: currentFilm)),
          const SizedBox(width: 12),
          Flexible(
            flex: 3,
            child: MyListWidget(items: llistaItems, callback: _setFilm),
          ),
        ],
      ),
    );
  }
}
