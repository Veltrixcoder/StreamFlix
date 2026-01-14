
import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'api/tmdb_client.dart';
import 'screens/home_screen.dart';
import 'screens/details_screen.dart';
import 'screens/search_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/details/:type/:id',
      builder: (context, state) {
        final type = state.pathParameters['type']!;
        final id = int.parse(state.pathParameters['id']!);
        return DetailsScreen(id: id, type: type);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TmdbClient>(create: (_) => TmdbClient()),
      ],
      child: ShadcnApp.router(
        title: 'StreamFlix',
        theme: AppTheme.darkTheme,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
