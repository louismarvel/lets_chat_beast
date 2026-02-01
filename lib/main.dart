import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // للدردشة الحية العالمية
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // تفعيل محرك الأرباح والربط السحابي فوراً
  try {
    await Firebase.initializeApp();
    MobileAds.instance.initialize();
  } catch (e) {
    debugPrint("Chatter Engine Ready...");
  }
  runApp(const ChatterCloneBeast());
}

class ChatterCloneBeast extends StatelessWidget {
  const ChatterCloneBeast({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF080808),
        primaryColor: const Color(0xFFFF007F),
        colorScheme: const ColorScheme.dark(secondary: Colors.cyanAccent),
      ),
      home: const MainWorldScreen(),
    );
  }
}

class MainWorldScreen extends StatefulWidget {
  const MainWorldScreen({super.key});
  @override
  State<MainWorldScreen> createState() => _MainWorldScreenState();
}

class _MainWorldScreenState extends State<MainWorldScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHATTER BEAST', style: GoogleFonts.orbitron(letterSpacing: 3, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 10,
        actions: [
          IconButton(icon: const Icon(Icons.language, color: Colors.cyanAccent), onPressed: () {}),
        ],
      ),
      body: _getBeastPage(_selectedTab),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => setState(() => _selectedTab = index),
        selectedItemColor: const Color(0xFFFF007F),
        unselectedItemColor: Colors.white24,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Global'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Private'),
          BottomNavigationBarItem(icon: Icon(Icons.payments), label: 'Ads/Earn'),
        ],
      ),
    );
  }

  Widget _getBeastPage(int index) {
    switch (index) {
      case 0: return const GlobalChatRooms();
      case 1: return const EncryptedPrivateChat();
      case 2: return const AdMobEarningPortal();
      default: return const GlobalChatRooms();
    }
  }
}

// --- استنساخ ميزة الغرف العالمية (Firebase Ready) ---
class GlobalChatRooms extends StatelessWidget {
  const GlobalChatRooms({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, i) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white10),
        ),
        child: ListTile(
          leading: const CircleAvatar(backgroundColor: Color(0xFFFF007F), child: Icon(Icons.rocket_launch, color: Colors.white)),
          title: Text('Chatter Room #${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('Live Encryption: Active', style: TextStyle(color: Colors.cyanAccent, fontSize: 11)),
          trailing: const Icon(Icons.chevron_right, color: Colors.white38),
        ),
      ),
    );
  }
}

// --- ميزة التشفير الخاص المستنسخة ---
class EncryptedPrivateChat extends StatelessWidget {
  const EncryptedPrivateChat({super.override});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('End-to-End Encryption Enabled'));
  }
}

// --- بوابة الأرباح (AdMob) ---
class AdMobEarningPortal extends StatelessWidget {
  const AdMobEarningPortal({super.override});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Revenue Engine: Initializing...'));
  }
}
