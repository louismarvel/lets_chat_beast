import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const StarchatLove());
}

class StarchatLove extends StatelessWidget {
  const StarchatLove({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        primaryColor: const Color(0xFFFF007F),
      ),
      home: const GlobalNexusScreen(),
    );
  }
}

class GlobalNexusScreen extends StatelessWidget {
  const GlobalNexusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('STARCHAT LOVE GLOBAL', style: GoogleFonts.orbitron(letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite, color: Color(0xFFFF007F), size: 100),
            const SizedBox(height: 20),
            Text('الوحش متصل بـ Firebase', style: GoogleFonts.orbitron(color: Colors.cyanAccent)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF007F)),
              child: const Text('دخول غرف الدردشة العالمية'),
            )
          ],
        ),
      ),
    );
  }
}
