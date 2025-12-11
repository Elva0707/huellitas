import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final auth = FirebaseAuth.instance;

  // Registro con manejo de errores
  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Errores específicos de Firebase
      switch (e.code) {
        case 'weak-password':
          throw Exception('La contraseña es muy débil');
        case 'email-already-in-use':
          throw Exception('Este email ya está registrado');
        case 'invalid-email':
          throw Exception('El email no es válido');
        default:
          throw Exception('Error en registro: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error desconocido: $e');
    }
  }

  // Login Email con manejo de errores
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('Usuario no encontrado');
        case 'wrong-password':
          throw Exception('Contraseña incorrecta');
        case 'invalid-email':
          throw Exception('Email inválido');
        case 'user-disabled':
          throw Exception('Usuario deshabilitado');
        case 'invalid-credential':
          throw Exception('Credenciales inválidas');
        default:
          throw Exception('Error en login: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error desconocido: $e');
    }
  }

  // Login Google con manejo de errores
  Future<User?> loginGoogle() async {
    try {
      // Para Android/iOS no se necesita especificar clientId
      // Solo para Web se requiere
      final GoogleSignIn googleSignIn = GoogleSignIn();
      
      // Iniciar el flujo de autenticación
      final GoogleSignInAccount? gUser = await googleSignIn.signIn();
      
      // Si el usuario cancela el login
      if (gUser == null) {
        throw Exception('Login cancelado por el usuario');
      }

      // Obtener los detalles de autenticación
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Crear credencial
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Iniciar sesión en Firebase
      final userCredential = await auth.signInWithCredential(credential);
      return userCredential.user;
      
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception('Ya existe una cuenta con este email');
        case 'invalid-credential':
          throw Exception('Credenciales de Google inválidas');
        case 'operation-not-allowed':
          throw Exception('Login con Google no está habilitado');
        case 'user-disabled':
          throw Exception('Usuario deshabilitado');
        default:
          throw Exception('Error con Google: ${e.message}');
      }
    } catch (e) {
      // Errores de Google Sign In
      if (e.toString().contains('network_error')) {
        throw Exception('Error de conexión. Verifica tu internet');
      }
      throw Exception('Error en login con Google: $e');
    }
  }

  // Logout con manejo de errores
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut(); // Cerrar sesión de Google también
      await auth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  // Usuario actual
  User? get currentUser => auth.currentUser;

  // Stream de cambios de autenticación
  Stream<User?> get userStream => auth.authStateChanges();

  // Verificar si hay usuario logueado
  bool get isLoggedIn => auth.currentUser != null;
}