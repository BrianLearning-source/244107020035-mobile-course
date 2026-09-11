import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main() => runApp(const DashboardApp());

const kWideBreakpoint = 700.0;

class DashboardApp extends StatefulWidget {
  const DashboardApp({super.key});

  @override
  State<DashboardApp> createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: DashboardPage(
        isDark: isDark,
        onDarkChanged: (value) => setState(() => isDark = value),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    required this.isDark,
    required this.onDarkChanged,
    super.key,
  });

  final bool isDark;
  final ValueChanged<bool> onDarkChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          child: const Text('ACADEMIC DASHBOARD'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Semantics(
              label: 'Dark mode',
              toggled: isDark,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sembunyikan ikon dekoratif agar tidak dibaca ganda
                  ExcludeSemantics(
                    child: Icon(isDark ? Icons.dark_mode : Icons.light_mode,
                                     color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  CupertinoSwitch(
                    value: isDark,
                    activeTrackColor: colorScheme.primary,
                    onChanged: onDarkChanged,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // final columns = constraints.maxWidth >= 700 ? 2 : 1;
          final columns = constraints.maxWidth >= kWideBreakpoint ? 2 : 1;
          return GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.6,
            children: const [
              InfoCard(
                title: 'Courses',
                value: '12',
                semanticValue: '12 courses enrolled',
              ),
              InfoCard(
                title: 'Attendance',
                value: '90%',
                semanticValue: '90 percent',
              ),
              InfoCard(
                title: 'Competition',
                value: '5',
                semanticValue: '5 competitions joined',
              ),
              InfoCard(
                title: 'GPA',
                value: '3.7',
                semanticValue: '3 point 7',
              ),
            ],
          );
        },
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.title,
    required this.value,
    this.semanticValue,
    super.key,
  });

  final String title;
  final String value;
  final String? semanticValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveValue = semanticValue ?? value;

    return Semantics(
      container: true,
      // Menggabungkan pembacaan judul dan isi kartu dalam 1 fokus ketukan
      label: '$title: $effectiveValue',
      excludeSemantics: true,
      child: Card(
        color: colorScheme.surfaceContainerHighest,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(child: Text(title)),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
      ),
    );
  }
}