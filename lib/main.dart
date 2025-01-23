import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/data/http/http.dart';
import 'src/data/repositories_impl/acount_repository_impl.dart';
import 'src/data/repositories_impl/authentication_repository_impl.dart';
import 'src/data/repositories_impl/conectivity_repository_impl.dart';
import 'src/data/services/local/session_service.dart';
import 'src/data/services/remote/acount_api.dart';
import 'src/data/services/remote/authentication_api.dart';
import 'src/domain/repositories/acount_repository.dart';
import 'src/domain/repositories/authentication_repository.dart';
import 'src/domain/repositories/connectivity_repository.dart';
import 'src/presentation/controllers/session_controller.dart';

main() {
  final sessionService = SessionService(
    const FlutterSecureStorage(),
  );

  //
  final httpClient = Http(
    'https://api.themoviedb.org/3',
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ZTgwMzc3OGZiYWNjOWY2N2FlMzQwNDczMDMwYzdlNSIsIm5iZiI6MTczMTY0NzQ4NC43ODMsInN1YiI6IjY3MzZkN2ZjZDYzZmVkNTgyNmNmNDU2YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Oe_j1v1mJSJForvSPiwLSPnnMbSp7uhj1GUPS4j5Y3I',
    Client(),
  );

  //
  final acountApi = AcountApi(httpClient);

  //
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthenticationRepository>(
          create: (_) => AuthenticationRepositoryImpl(
            sessionService,
            AuthenticationAPI(httpClient),
            acountApi,
          ),
        ),
        Provider<ConnectivityRepository>(
          create: (_) => ConnectivityRepositoryImpl(Connectivity()),
        ),
        Provider<AcountRepository>(
          create: (_) => AcountRepositoryImpl(
            acountApi,
            sessionService,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SessionController(
            authenticationRepository: context.read(),
          ),
        )
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: const App(),
      ),
    ),
  );
}
