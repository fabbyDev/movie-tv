import 'package:flutter/material.dart';

import 'presentation/routes/router.dart';
import 'presentation/routes/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splash,
      routes: routes,
    );
  }
}
