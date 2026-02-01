import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const StarchatLoveApp());
}

class StarchatLoveApp extends StatelessWidget {
  const StarchatLoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Starchat Love',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        primaryColor: const Color(0xFFFF007F),
      ),
      home: const GlobalHomeScreen(),
    );
  }
}

class GlobalHomeScreen extends StatelessWidget {
  const GlobalHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('STARCHAT LOVE', style: GoogleFonts.orbitron(letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, color: Colors.cyanAccent, size: 80),
            const SizedBox(height: 20),
            Text('الوحش متصل ومؤمن بنجاح', 
              style: GoogleFonts.orbitron(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            const Text('Package: com.starchat.love', 
              style: TextStyle(color: Colors.white24)),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: Color(0xFFFF007F)),
          ],
        ),
      ),
    );
  }
}
