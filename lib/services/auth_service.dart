import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<bool> signup({
    required String email,
    required String password
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true; // Başarılı kayıt
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'weak-password') {
        message = 'Şifreniz güçlü değil';
      } else if (e.code == 'email-already-in-use') {
        message = 'Bu e-posta ile kayıtlı bir hesap zaten mevcut';
      }
      print(message);
      return false; // Başarısız kayıt
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> signin({
    required String email,
    required String password
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true; // Başarılı giriş
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'user-not-found') {
        message = 'Bu e-posta ile kayıtlı herhangi bir hesap bulunmamaktadır';
      } else if (e.code == 'wrong-password') {
        message = 'Hatalı şifre';
      }
      print(message);
      return false; // Başarısız giriş
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Logout methodu
  Future<void> signout() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('Çıkış başarılı');
    } catch (e) {
      print('Çıkış başarısız: $e');
    }
  }
}
