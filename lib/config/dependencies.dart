import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_example/data/datasources/firebase_user_datasource.dart';
import 'package:flutter_firebase_example/data/repositories/firebase_auth_service.dart';
import 'package:flutter_firebase_example/data/repositories/firebase_user_repository.dart';
import 'package:flutter_firebase_example/domain/usecases/add_user_usecase.dart';
import 'package:flutter_firebase_example/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_firebase_example/presentation/blocs/user/user_bloc.dart';

List<BlocProvider> getBlocProviders() {
  return [
    BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthService())),
    BlocProvider<UserBloc>(
        create: (context) => UserBloc(
              AddUserUseCase(
                UserRepositoryImpl(
                  FirebaseUserDatasource(),
                ),
              ),
            ))
  ];
}
