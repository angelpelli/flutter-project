import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:proyecto_angel_pellitero/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verificar que estamos en la pantalla de ocupación
      expect(find.text('Ocupación'), findsOneWidget);

      // Navegar a la pantalla de listados
      await tester.tap(find.byIcon(Icons.pets));
      await tester.pumpAndSettle();

      // Verificar que estamos en la pantalla de listados
      expect(find.text('Mascotas'), findsOneWidget);
      expect(find.text('Dueños'), findsOneWidget);

      // Verificar que se muestra el botón para agregar mascota
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Tap en el botón de agregar mascota
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verificar que se abre el diálogo de agregar mascota
      expect(find.text('Agregar nueva mascota'), findsOneWidget);

      // Cerrar el diálogo
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      // Navegar a la pantalla de ocupación
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();

      // Verificar que estamos de vuelta en la pantalla de ocupación
      expect(find.text('Ocupación'), findsOneWidget);
    });
  });
}

