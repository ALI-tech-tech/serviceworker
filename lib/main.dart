import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // GoRouter setup
  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/details',
        builder: (context, state) => const DetailsPage(),
      ),
    ],
    // The following setup is important to handle the state properly
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(child: Text('Page not found: ${state.uri}')),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig:_router ,
      // routerDelegate: _router.routerDelegate,
      // routeInformationParser: _router.routeInformationParser,
      // You can also add other app settings here
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final savedData = html.window.localStorage['controllerData'];
    if (savedData != null) {
      _controller.text = savedData;
    }
  }

  @override
  void dispose() {
    html.window.localStorage['controllerData'] = _controller.text;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GoRouter Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _controller),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/details');
              },
              child: const Text('Go to Details Page'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
    final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final savedData = html.window.localStorage['controllerData2'];
    if (savedData != null) {
      _controller.text = savedData;
    }
  }

  @override
  void dispose() {
    html.window.localStorage['controllerData2'] = _controller.text;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details Page')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(controller: _controller),
            SizedBox(height: 20),
          ElevatedButton(
          onPressed: () {
            context.go('/');
          },
          child: const Text('Back to Home'),
        ),]
      ),
    );
  }
}
