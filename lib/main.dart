import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const StarchatLoveApp());

class StarchatLoveApp extends StatelessWidget {
  const StarchatLoveApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF050505),
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
        title: Text('STARCHAT LOVE', style: GoogleFonts.orbitron(letterSpacing: 3)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite, color: Color(0xFFFF007F), size: 120),
            const SizedBox(height: 20),
            Text('الوحش العالمي جاهز للإطلاق', style: GoogleFonts.orbitron(color: Colors.cyanAccent)),
            const SizedBox(height: 10),
            const Text('Connected to Firebase: starchat-love', style: TextStyle(color: Colors.white24)),
          ],
        ),
      ),
    );
  }
}
