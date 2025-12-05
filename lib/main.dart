import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// Asumsi impor ini berfungsi dan berisi Style, HomePage, InternationalPage, dll.
import 'package:depd_mvvm_2025/shared/style.dart'; 
import 'package:depd_mvvm_2025/view/pages/pages.dart';
import 'package:depd_mvvm_2025/viewmodel/home_viewmodel.dart';
import 'package:depd_mvvm_2025/viewmodel/international_viewmodel.dart'; // ViewModel International yang baru

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider( 
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => InternationalViewModel()), 
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter x RajaOngkir API',
        theme: ThemeData(
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
        routes: {'/': (context) => const MainWrapper()},
      ),
    );
  }
}


class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;


  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),          
    InternationalPage(), 
    HelloWorldPage(),    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).primaryColor;
    final unselectedColor = Style.grey500; 

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flight),
            label: 'International',
          ),
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

