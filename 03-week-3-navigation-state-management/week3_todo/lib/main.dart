import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'pages/todo_page.dart';
import 'router/app_router.dart';

void main() => runApp(const ProviderScope(child: MyApp()));


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
      title: 'Week 3 - Todo',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      routerConfig: appRouter,
      // home: const TodoPage(),  
      // home: const ProductPage(), 
    );
  }