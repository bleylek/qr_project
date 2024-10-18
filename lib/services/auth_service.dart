import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Email ve şifre ile kayıt
  Future<bool> signup({
    required String email,
    required String password,
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

  // Email ve şifre ile giriş
  Future<bool> signin({
    required String email,
    required String password,
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

  // Google Sign-In
  Future<bool> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return false; // Kullanıcı giriş yapmayı iptal etti
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      return true; // Başarılı Google Sign-In
    } catch (e) {
      print('Google Sign-In Hatası: $e');
      return false; // Google Sign-In başarısız
    }
  }

  // Şifre sıfırlama e-postası gönderme methodu
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('Şifre sıfırlama e-postası gönderildi');
    } catch (e) {
      print('Şifre sıfırlama e-postası gönderilemedi: $e');
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
