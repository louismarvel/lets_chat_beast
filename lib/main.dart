import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const StarChatFinal());

class StarChatFinal extends StatelessWidget {
  const StarChatFinal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        primaryColor: const Color(0xFFFF007F),
      ),
      home: const MainNexusScreen(),
    );
  }
}

class MainNexusScreen extends StatefulWidget {
  const MainNexusScreen({super.key});

  @override
  State<MainNexusScreen> createState() => _MainNexusScreenState();
}

class _MainNexusScreenState extends State<MainNexusScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const RoomsScreen(), // ميزة غرف الدردشة
    const ChatBeastScreen(), // ميزة الدردشة الخاصة
    const ProfileNeonScreen(), // ميزة الملف الشخصي
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFFF007F),
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'الغرف'),
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'الوحش'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'أنا'),
        ],
      ),
    );
  }
}

// --- ميزة غرف الدردشة الاحترافية ---
class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 150,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('STAR CHAT ROOMS', style: GoogleFonts.orbitron(letterSpacing: 2)),
            background: Container(color: Colors.black),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFF007F).withOpacity(0.5)),
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(colors: [Colors.black, Colors.grey[900]!]),
              ),
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFFFF007F), child: Icon(Icons.group)),
                title: Text('غرفة الوحوش رقم ${index + 1}', style: const TextStyle(color: Colors.white)),
                subtitle: const Text('متواجد الآن: 45 عضو', style: TextStyle(color: Colors.grey)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFFF007F)),
              ),
            ),
            childCount: 10,
          ),
        ),
      ],
    );
  }
}

// --- ميزة الدردشة الذكية ---
class ChatBeastScreen extends StatelessWidget {
  const ChatBeastScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.security, size: 80, color: Colors.cyanAccent),
          const SizedBox(height: 20),
          Text('نظام تشفير الوحش نشط', style: GoogleFonts.orbitron(color: Colors.cyanAccent)),
        ],
      ),
    );
  }
}

// --- ميزة الملف الشخصي النيوني ---
class ProfileNeonScreen extends StatelessWidget {
  const ProfileNeonScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('بروفايل النيون جاهز'));
  }
}
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
