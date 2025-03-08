import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "1", firstName: "User",);
  ChatUser geminiUser = ChatUser(
      id: "2",
      firstName: "Gemini",
      profileImage:
          "https://www.gemini.com/_next/image?url=%2Fstatic%2Fimages%2Fgemini-hor-light-full-rgb%403x.png&w=256&q=75");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Gezy Chat"),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(trailing: [
        IconButton(onPressed: (){}, icon: Icon(Icons.image))
      ]),
        currentUser: currentUser, onSend: _SendMessage, messages: messages);
  }

  void _SendMessage(ChatMessage chatMessage) {
    // Create a list of `Part` objects with the user's text input
    // Create a list of `Part` objects with the user's text input
    List<Part> parts = [
      Part.text(chatMessage.text), // Wrap the user's text in a `Part` object
    ];
    setState(() {
      messages = [chatMessage, ...messages];
    });
     // Variable to accumulate the streamed response
    String accumulatedResponse = "";
    // String question = chatMessage.text;
    gemini.promptStream(parts: parts).listen(
      (event) {
        // Handle the streamed response from Gemini
        // setState(() {
        //   messages = [
        //     ChatMessage(
        //       user: geminiUser,
        //       text: response.toString(),
        //       createdAt: DateTime.now(),
        //     ),
        //     ...messages, // Add Gemini's response to the chat
        //   ];
        // });

        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event?.content?.parts
                  ?.map((part) => (part as TextPart).text)
                  .join("") ??
              "";
                      // Accumulate the response
          accumulatedResponse += response;
          lastMessage.text = response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = event?.content?.parts
                  ?.map((part) => (part as TextPart).text)
                  .join("") ??
              "";
          ChatMessage message = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [message, ...messages];
          });
        }
      },
      onError: (error) {
        // Handle errors
        print("Error: $error");
      },
    );
    try {} catch (e) {
      print(e);
    }
  }
}
