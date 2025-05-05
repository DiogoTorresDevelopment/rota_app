import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Páginas principais
import 'package:rota_app/modules/auth/presentation/login_page.dart';
import 'package:rota_app/modules/home/presentation/splash_page.dart';
import 'package:rota_app/modules/home/presentation/home_page.dart';
import 'package:rota_app/modules/navigation/main_scaffold.dart';
import 'package:rota_app/modules/routes/presentation/routes_page.dart';
import 'package:rota_app/modules/settings/presentation/settings_page.dart';

// Páginas com argumentos
import 'package:rota_app/modules/routes/presentation/rota_detalhe_page.dart';
import 'package:rota_app/modules/routes/domain/models/rota_model.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Splash (inicial)
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),

    // Login
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    // Shell com menu de navegação
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        // Página principal
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),

        // Página de rotas
        GoRoute(
          path: '/rotas',
          builder: (context, state) => const RoutesPage(),
        ),

        // Página de configurações
        GoRoute(
          path: '/config',
          builder: (context, state) => const SettingsPage(),
        ),

        // Detalhe da rota com dados via extra
        GoRoute(
          path: '/rota_detalhe',
          builder: (context, state) {
            final rota = state.extra as RotaModel;
            return RotaDetalhePage(rota: rota);
          },
        ),
      ],
    ),
  ],
);
