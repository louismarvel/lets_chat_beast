import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const LetsChatApp());

class LetsChatApp extends StatelessWidget {
  const LetsChatApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Let\'s Chat Pro',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFFFF1493),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1A1A1A)),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Let\'s Chat', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFFFF1493))),
          bottom: const TabBar(
            indicatorColor: Color(0xFFFF1493),
            tabs: [Tab(icon: Icon(Icons.camera_alt)), Tab(text: 'CHATS'), Tab(text: 'STATUS'), Tab(text: 'CALLS')],
          ),
          actions: [
            const Icon(Icons.search),
            const SizedBox(width: 15),
            const Icon(Icons.more_vert),
            const SizedBox(width: 10),
          ],
        ),
        body: const TabBarView(
          children: [
            Center(child: Icon(Icons.camera_alt, size: 100)),
            ChatList(),
            Center(child: Text('Status View')),
            Center(child: Text('Calls View')),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFFF1493),
          child: const Icon(Icons.message, color: Colors.white),
          onPressed: () {},
        ),
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  const ChatList({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) => ListTile(
        leading: const CircleAvatar(backgroundColor: Color(0xFF333333), child: Icon(Icons.person, color: Color(0xFFFF1493))),
        title: Text('Contact ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('Last message from the team...', style: TextStyle(color: Colors.white54)),
        trailing: const Text('10:30 PM', style: TextStyle(fontSize: 12, color: Colors.white38)),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatDetail())),
      ),
    );
  }
}

class ChatDetail extends StatelessWidget {
  const ChatDetail({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChatDetail')),
      body: Column(
        children: [
          // مساحة إعلانية
          Container(width: double.infinity, height: 50, color: Colors.white10, child: const Center(child: Text('REVENUE AD ACTIVE 💰'))),
          Expanded(child: ListView(padding: const EdgeInsets.all(20), children: const [
            Bubble(text: 'Hi Fouad! This is Let\'s Chat UI.', isMe: false),
            Bubble(text: 'It looks amazing and fast!', isMe: true),
          ])),
          _input(),
        ],
      ),
    );
  }

  Widget _input() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color(0xFF1A1A1A),
      child: Row(
        children: [
          const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Type message...', border: InputBorder.none))),
          IconButton(icon: const Icon(Icons.send, color: Color(0xFFFF1493)), onPressed: () {}),
        ],
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final String text; final bool isMe;
  const Bubble({required this.text, required this.isMe, super.key});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFFF1493) : const Color(0xFF262626),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(text),
      ),
    );
  }
}
