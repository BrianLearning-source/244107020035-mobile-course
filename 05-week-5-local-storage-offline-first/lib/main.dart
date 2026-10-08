=import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/notes_page.dart'; // Sesuaikan dengan halaman utama yang kamu buat
import 'pages/settings_page.dart'; // Tempat darkModeProvider didefinisikan

void main() {
  // Memastikan binding Flutter terinisialisasi sebelum menjalankan operasi async
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    // ProviderScope wajib ada di root aplikasi Riverpod
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Memantau state dark mode dari provider yang sudah dibuat di settings_page.dart
    final darkModeAsync = ref.watch(darkModeProvider);

    // Mengambil nilai boolean dari AsyncValue, default ke false jika masih loading/error
    final isDarkMode = darkModeAsync.value ?? false;

    return MaterialApp(
      title: 'Offline Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      // Mengubah tema secara dinamis berdasarkan state Riverpod
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
      // Halaman utama aplikasi (bisa diarahkan ke NotesPage)
      home: const NotesPage(),
    );
  }
}