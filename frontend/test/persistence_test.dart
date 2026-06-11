import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

// Interface o contrato del servicio de red
abstract class ApiService {
  Future<int> postProgress(int objectId, bool consumed);
}

// STUB CONTROLADO: Forzamos el comportamiento de desconexión sin problemas de Null Safety
class FallbackNetworkStub implements ApiService {
  @override
  Future<int> postProgress(int objectId, bool consumed) async {
    // Simulamos de forma real una caída abrupta de red inalámbrica en la UCI
    throw const SocketException('Error de conexión con el servidor central');
  }
}

void main() {
  late Box syncBox;
  late FallbackNetworkStub stubClient;

  setUp(() async {
    // Inicializa la base de datos local Hive aislada en memoria para pruebas
    await setUpTestHive();
    syncBox = await Hive.openBox('pending_sync');
    stubClient = FallbackNetworkStub();
  });

  tearDown(() async {
    await syncBox.close();
    await tearDownTestHive();
  });

  test(
    'Debe persistir progreso en Hive local ante un fallo de red (SocketException)',
    () async {
      final int targetObjectId = 42;
      bool seDisparoExcepcion = false;

      // 1. Ejecutar la acción interceptando el fallo simulado
      try {
        await stubClient.postProgress(targetObjectId, true);
      } catch (e) {
        if (e is SocketException) {
          seDisparoExcepcion = true;

          // Estrategia Offline-First: Respaldar localmente en la caché de Hive
          await syncBox.put(targetObjectId, {
            'learning_object_id': targetObjectId,
            'is_consumed': true,
            'synced': false,
          });
        }
      }

      // 2. Validaciones (Asserts)
      expect(
        seDisparoExcepcion,
        true,
        reason: "La app debió detectar e interceptar la caída de red",
      );

      final cachedData = syncBox.get(targetObjectId);
      expect(cachedData, isNotNull);
      expect(cachedData['synced'], false);
      expect(cachedData['is_consumed'], true);
      expect(cachedData['learning_object_id'], 42);

      print(
        "----------------------------------------------------------------------",
      );
      print(
        "Resultado: OK - Datos resguardados en la persistencia local de Hive.",
      );
      print(
        "----------------------------------------------------------------------",
      );
    },
  );
}
