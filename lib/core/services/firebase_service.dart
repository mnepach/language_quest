import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../firebase_options.dart';
import '../../data/models/user_model.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Инициализация Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Регистрация
  static Future<UserModel> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      final now = DateTime.now();

      final userData = {
        'id': uid,
        'email': email,
        'username': username,
        'level': 1,
        'experience': 0,
        'coins': 50,
        'createdAt': Timestamp.fromDate(now),
        'lastLoginAt': Timestamp.fromDate(now),
        'progress': {
          'completedLessons': 0,
          'totalLessons': 50,
          'currentStreak': 0,
          'longestStreak': 0,
          'skillLevels': {
            'vocabulary': 0,
            'grammar': 0,
            'listening': 0,
            'speaking': 0,
          },
        },
      };

      await _firestore.collection('users').doc(uid).set(userData);

      final userDataForModel = {
        'id': uid,
        'email': email,
        'username': username,
        'level': 1,
        'experience': 0,
        'coins': 50,
        'createdAt': now.toIso8601String(),
        'lastLoginAt': now.toIso8601String(),
        'progress': {
          'completedLessons': 0,
          'totalLessons': 50,
          'currentStreak': 0,
          'longestStreak': 0,
          'skillLevels': {
            'vocabulary': 0,
            'grammar': 0,
            'listening': 0,
            'speaking': 0,
          },
        },
      };

      return UserModel.fromJson(userDataForModel);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('User already exists');
      }
      throw Exception('Registration failed: ${e.message}');
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).update({
        'lastLoginAt': Timestamp.fromDate(DateTime.now()),
      });

      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        throw Exception('User data not found');
      }

      final data = doc.data()!;
      final userData = _convertFirestoreData(data);

      return UserModel.fromJson(userData);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw Exception('Invalid email or password');
      }
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      final userData = _convertFirestoreData(data);

      return UserModel.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  static Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  static Future<bool> isEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  static Stream<UserModel?> userStream() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      final userData = _convertFirestoreData(data);

      return UserModel.fromJson(userData);
    });
  }

  static Map<String, dynamic> _convertFirestoreData(Map<String, dynamic> data) {
    final convertedData = Map<String, dynamic>.from(data);

    if (convertedData['createdAt'] is Timestamp) {
      convertedData['createdAt'] =
          (convertedData['createdAt'] as Timestamp).toDate().toIso8601String();
    }

    if (convertedData['lastLoginAt'] is Timestamp) {
      convertedData['lastLoginAt'] =
          (convertedData['lastLoginAt'] as Timestamp).toDate().toIso8601String();
    }

    return convertedData;
  }
}