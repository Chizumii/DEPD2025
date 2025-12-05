import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// Asumsi impor ini berfungsi dan berisi Style, HomePage, InternationalPage, dll.
import 'package:depd_mvvm_2025/shared/style.dart'; 
import 'package:depd_mvvm_2025/view/pages/pages.dart';
import 'package:depd_mvvm_2025/viewmodel/home_viewmodel.dart';
import 'package:depd_mvvm_2025/viewmodel/international_viewmodel.dart'; // ViewModel International yang baru

Future<void> main() async {
  // Memastikan binding Flutter sudah diinisialisasi sebelum menjalankan aplikasi
  WidgetsFlutterBinding.ensureInitialized();
  // Memuat file .env sebelum diakses widget
  // await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

// ===============================================
// Bagian 1: Aplikasi dan Provider Setup (MyApp)
// ===============================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider( // Menggunakan MultiProvider untuk menyediakan dua ViewModel
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()), // Untuk Domestik dan Location Origin
        ChangeNotifierProvider(create: (_) => InternationalViewModel()), // Untuk International Cost/Destination
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter x RajaOngkir API',
        theme: ThemeData(
          // ... (Theme Data Anda yang sudah ada)
          primaryColor: Style.blue800,
          scaffoldBackgroundColor: Style.grey50,
          textTheme: Theme.of(
            context,
          ).textTheme.apply(bodyColor: Style.black, displayColor: Style.black),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Style.blue800),
              foregroundColor: WidgetStateProperty.all<Color>(Style.white),
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(16),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Style.blue800),
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Style.grey500),
            floatingLabelStyle: TextStyle(color: Style.blue800),
            hintStyle: TextStyle(color: Style.grey500),
            iconColor: Style.grey500,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Style.grey500),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Style.blue800, width: 2),
            ),
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {'/': (context) => const MainWrapper()}, // Mengarah ke Wrapper Navigasi
      ),
    );
  }
}

// ===============================================
// Bagian 2: Struktur Bottom Navigation (MainWrapper)
// ===============================================

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  // Daftar page sesuai urutan Bottom Nav Bar
  // Asumsi HomePage dan InternationalPage diimpor dari pages.dart
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),          // 0: Home
    InternationalPage(), // 1: International
    HelloWorldPage(),    // 2: Hello World (Profile)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan Style yang tersedia di Theme
    final selectedColor = Theme.of(context).primaryColor;
    final unselectedColor = Style.grey500; // Asumsi Style.grey500 tersedia

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          // 0. Home
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          // 1. International (Plane symbol)
          BottomNavigationBarItem(
            icon: Icon(Icons.flight),
            label: 'International',
          ),
          // 2. Hello World (Profile symbol)
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Hello World',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// ===============================================
// Bagian 3: Placeholder Hello World Page
// ===============================================
// Karena HomePage dan InternationalPage sudah ada/diimpor, kita hanya perlu placeholder ini.

class HelloWorldPage extends StatelessWidget {
  const HelloWorldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Hello World Page (Profile/Settings)',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}