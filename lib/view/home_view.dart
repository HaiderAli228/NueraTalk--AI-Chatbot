import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatbot/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

import '../view-model/app_links.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final openAIApi = OpenAI.instance.build(
      token: AppLinks.chatbotPostApi,
      enableLog: true,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)));
  final ChatUser currentUser =
      ChatUser(id: "1", firstName: "Haider", lastName: "Ali");

  final ChatUser gptUser =
      ChatUser(id: "2", firstName: "chatbot", lastName: "-NueraTalk");

  List<ChatMessage> messageList = <ChatMessage>[];
  List<ChatUser> typeUser = <ChatUser>[];
  Future<void> getChatResponse(ChatMessage msg) async {
    setState(() {
      messageList.insert(0, msg);
      typeUser.add(gptUser);
    });

    List<Map<String, dynamic>> msgHistory = messageList.reversed.map((msg) {
      if (msg.user == currentUser) {
        return {"role": "user", "content": msg.text};
      } else {
        return {"role": "assistant", "content": msg.text};
      }
    }).toList();

    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: msgHistory,
      maxToken: 200,
    );
    final response = await openAIApi.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          messageList.insert(
              0,
              ChatMessage(
                  user: gptUser,
                  createdAt: DateTime.now(),
                  text: element.message!.content));
        });
      }
    }
    setState(() {
      typeUser.remove(gptUser) ;
    });
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
      ),
      body: DashChat(
          currentUser: currentUser,
          typingUsers: typeUser,
          messageOptions: const MessageOptions(
              textColor: AppColor.themeTextColor,
              currentUserContainerColor: AppColor.themeColor,
              containerColor: AppColor.themeColor),
          onSend: (ChatMessage msg) {
            getChatResponse(msg);
          },
          messages: messageList),
    );
  }
}
