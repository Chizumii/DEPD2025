part of 'pages.dart';

class HelloWorldPage extends StatelessWidget {
  const HelloWorldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Hello World Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}