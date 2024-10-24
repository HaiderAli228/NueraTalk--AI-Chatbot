// chat_session_model.dart

class ChatSession {
  final int id;
  final String title;
  final String date;
  final String messages;

  ChatSession({
    required this.id,
    required this.title,
    required this.date,
    required this.messages,
  });

  // Convert ChatSession to a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'messages': messages,
    };
  }
}
