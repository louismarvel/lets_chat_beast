import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const ChatStarApp());

class ChatStarApp extends StatelessWidget {
  const ChatStarApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        primaryColor: const Color(0xFFFF1493),
        textTheme: GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/chat': (context) => const ChatRoomsScreen(),
      },
    );
  }
}

// --- واجهة الترحيب الجذابة ---
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite, size: 100, color: Color(0xFFFF1493)),
            const SizedBox(height: 20),
            Text('CHATSTAR PRO', style: GoogleFonts.orbitron(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF1493), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('ENTER NEON WORLD'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- واجهة تسجيل StarChat ---
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SIGN IN'), backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: 'Username', enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFF1493))))),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/chat'), child: const Text('JOIN CHAT')),
          ],
        ),
      ),
    );
  }
}

// --- واجهة غرف الدردشة الكاملة ---
class ChatRoomsScreen extends StatelessWidget {
  const ChatRoomsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NEON ROOMS'), backgroundColor: const Color(0xFFFF1493)),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => ListTile(
          leading: const CircleAvatar(backgroundColor: Color(0xFFFF1493), child: Icon(Icons.person, color: Colors.white)),
          title: Text('Chat Room #${index + 1}'),
          subtitle: const Text('Active Now...', style: TextStyle(color: Colors.greenAccent)),
          onTap: () {},
        ),
      ),
    );
  }
}
