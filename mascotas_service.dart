import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/mascotas.dart';

class MascotasService {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection("mascotas");

  // Crear
  Future<void> addMascota(Mascota mascota) async {
    await collection.add(mascota.toMap());
  }

  // Leer (Stream en tiempo real)
  Stream<List<Mascota>> getMascotas() {
    return collection.snapshots().map(
      (query) {
        return query.docs.map((doc) {
          return Mascota.fromMap(doc.id, doc.data() as Map<String, dynamic>);
        }).toList();
      },
    );
  }

  // Actualizar
  Future<void> updateMascota(Mascota mascota) async {
    await collection.doc(mascota.id).update(mascota.toMap());
  }

  // Eliminar
  Future<void> deleteMascota(String id) async {
    await collection.doc(id).delete();
  }
}
