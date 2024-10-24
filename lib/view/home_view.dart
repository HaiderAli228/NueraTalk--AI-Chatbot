import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';
import '../view-model/app_links.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final GenerativeModel generativeModel;
  final ChatUser currentUser =
  ChatUser(id: "1", firstName: "Haider", lastName: "Ali");
  final ChatUser gptUser =
  ChatUser(id: "2", firstName: "Chatbot", lastName: "NueraTalk");

  List<ChatMessage> messageList = <ChatMessage>[];
  List<ChatUser> typingUsers = <ChatUser>[];
  late Database db;
  List<Map<String, dynamic>> chatSessions = [];

  @override
  void initState() {
    super.initState();

    // Initialize the GenerativeModel
    generativeModel = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: AppLinks.chatbotPostApi,
    );

    // Initialize database and load chat sessions
    initDb();
  }

  Future<void> initDb() async {
    final dbPath = await getDatabasesPath();
    db = await openDatabase(
      join(dbPath, 'chats.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE chats(id INTEGER PRIMARY KEY, title TEXT, date TEXT, messages TEXT)',
        );
      },
      version: 1,
    );

    loadChats();
  }

  Future<void> loadChats() async {
    final chats = await db.query('chats', orderBy: 'date DESC');
    setState(() {
      chatSessions = chats;
    });
  }

  Future<void> saveChatSession() async {
    // Generate a title based on the last message
    final lastMessageText =
    messageList.isNotEmpty ? messageList.first.text : "New Chat";

    final title =
        'Chat: "$lastMessageText" - ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now())}';

    final chatMessages = messageList
        .map((msg) => "${msg.user.firstName}: ${msg.text}")
        .join('\n');

    await db.insert(
      'chats',
      {
        'title': title,
        'date': DateTime.now().toString(),
        'messages': chatMessages
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    loadChats();
  }

  Future<void> loadChat(int chatId) async {
    final chat = await db.query('chats', where: 'id = ?', whereArgs: [chatId]);

    if (chat.isNotEmpty) {
      final messages = chat.first['messages'].toString().split('\n');
      setState(() {
        messageList = messages.map((message) {
          final parts = message.split(': ');
          return ChatMessage(
            user: parts[0] == 'Haider' ? currentUser : gptUser,
            createdAt: DateTime.now(),
            text: parts[1],
          );
        }).toList();
      });
    }
  }

  // Function to format chat titles based on date
  String getChatLabel(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return "Today";
    } else if (difference == 1) {
      return "Yesterday";
    } else if (difference <= 7) {
      return "Last Week";
    } else if (difference <= 30) {
      return "This Month";
    } else {
      return "Older";
    }
  }

  // Delete chats older than one month
  Future<void> deleteOldChats() async {
    final oneMonthAgo = DateTime.now().subtract(const Duration(days: 30));
    await db.delete(
      'chats',
      where: 'date < ?',
      whereArgs: [oneMonthAgo.toIso8601String()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bodyBGColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.themeColor,
        title: const Text(
          "NeuraTalk",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            color: AppColor.themeTextColor,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        surfaceTintColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: AppColor.themeColor),
                accountName: Text("Haider Ali"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text("HA"),
                ),
                accountEmail: Text("flutter2830@gmail.com")),
            ...chatSessions.map((chat) {
              final chatDate = DateTime.parse(chat['date']);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: ListTile(
                  title: Text(
                    chat['title'],
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    getChatLabel(chatDate),
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () => loadChat(chat['id']),
                ),
              );
            }),
          ],
        ),
      ),
      body: DashChat(
        currentUser: currentUser,
        typingUsers: typingUsers,
        messageOptions: MessageOptions(
          textColor: AppColor.themeTextColor,
          currentUserContainerColor: Colors.grey.shade300,
          currentUserTextColor: Colors.black,
          containerColor: AppColor.themeColor,
        ),
        readOnly: false,
        inputOptions: const InputOptions(
          autocorrect: true,
          alwaysShowSend: false,
          cursorStyle: CursorStyle(
            color: AppColor.themeColor,
          ),
        ),
        onSend: (ChatMessage msg) {
          getChatResponse(msg);
          saveChatSession(); // Automatically save chat after sending a message
        },
        messages: messageList,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage msg) async {
    setState(() {
      messageList.insert(0, msg);
      typingUsers.add(gptUser); // Show that GPT is typing
    });

    // Prepare the prompt for the GenerativeModel
    final prompt = "User: ${msg.text}";

    try {
      final content = [Content.text(prompt)];
      final response = await generativeModel.generateContent(content);
      final responseText = response.text;

      setState(() {
        messageList.insert(
          0,
          ChatMessage(
            user: gptUser,
            createdAt: DateTime.now(),
            text: responseText.toString(),
          ),
        );
      });
    } catch (e) {
      setState(() {
        messageList.insert(
          0,
          ChatMessage(
            user: gptUser,
            createdAt: DateTime.now(),
            text: "Error: ${e.toString()}",
          ),
        );
      });
    } finally {
      setState(() {
        typingUsers.remove(gptUser); // Remove typing indicator
      });
    }
  }
}