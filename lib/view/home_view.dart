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
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
  );
  final ChatUser currentUser = ChatUser(id: "1", firstName: "Hagider", lastName: "Ali");
  final ChatUser gptUser = ChatUser(id: "2", firstName: "Chatbot", lastName: "NueraTalk");

  List<ChatMessage> messageList = <ChatMessage>[];
  List<ChatUser> typeUser = <ChatUser>[];

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
          containerColor: AppColor.themeColor,
        ),
        onSend: (ChatMessage msg) {
          getChatResponse(msg);
        },
        messages: messageList,  // Pass messageList directly here.
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage msg) async {
    setState(() {
      messageList.insert(0, msg);
      typeUser.add(gptUser);
    });

    List<Map<String, dynamic>> msgHistory = messageList.reversed.map((msg) {
      return {"role": msg.user == currentUser ? "user" : "assistant", "content": msg.text};
    }).toList();

    try {
      final request = ChatCompleteText(
        model: GptTurboChatModel(),
        messages: msgHistory,
        maxToken: 50, // Keep this low to avoid heavy API usage
      );

      final response = await openAIApi.onChatCompletion(request: request);

      if (response != null) {
        for (var element in response.choices) {
          if (element.message != null) {
            setState(() {
              messageList.insert(
                0,
                ChatMessage(
                  user: gptUser,
                  createdAt: DateTime.now(),
                  text: element.message!.content,
                ),
              );
            });
          }
        }
      }
    } catch (e) {
      if (e.toString().contains("429")) {
        // Simulate a mock response
        setState(() {
          messageList.insert(
            0,
            ChatMessage(
              user: gptUser,
              createdAt: DateTime.now(),
              text:
              "You have exceeded the API quota. This is a mock response. Please check your API usage or upgrade your plan.",
            ),
          );
        });
      } else {
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
      }
    } finally {
      setState(() {
        typeUser.remove(gptUser);
      });
    }
  }
}
