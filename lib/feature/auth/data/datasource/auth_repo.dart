import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource();

  Failures _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return const Failures.messange('Please enter a valid phone number');
      case 'too-many-requests':
        return const Failures.messange(
          'Too many attempts. Please try again later.',
        );
      case 'quota-exceeded':
        return const Failures.messange(
          'SMS quota exceeded. Please try again later.',
        );
      case 'operation-not-allowed':
        return const Failures.messange('Phone authentication is not enabled.');
      case 'user-disabled':
        return const Failures.messange('This account has been disabled.');

      case 'user-not-found':
        return const Failures.messange(
          'No user found for that email. Please register first.',
        );
      case 'wrong-password':
        return const Failures.messange('Incorrect password. Please try again.');
      case 'invalid-email':
        return const Failures.messange(
          'Invalid email format. Please check and try again.',
        );
      case 'email-already-in-use':
        return const Failures.messange(
          'Email is already registered. Try logging in instead.',
        );

      case 'network-request-failed':
      case 'timeout':
        return const Failures.network(
          'Network error. Please check your connection and retry.',
        );

      default:
        return Failures.messange(e.message ?? e.code);
    }
  }

  Future<Either<Failures, User>> login(String email, String password) async {
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return Right(user.user!);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } on SocketException catch (e) {
      throw FirebaseAuthException(
        code: 'auth/network-error',
        message: 'No internet connection. Please check your network.',
      );
    } on TimeoutException catch (e) {
      throw FirebaseAuthException(
        code: 'auth/timeout',
        message: 'Login timed out. Please try again.',
      );
    } catch (e) {
      throw FirebaseAuthException(
        code: 'auth/unexpected',
        message: 'Something went wrong. Please try again later.',
      );
    }
  }
}
