import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/auth/data/datasource/auth_repo.dart';
 
import 'package:empire/feature/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
 

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);
 
  @override
  Future <Either<Failures, User>> login(String name, String password) {
    return remoteDataSource.login(name, password);
  }
}
