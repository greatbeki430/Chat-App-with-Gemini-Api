// import 'dart:io';
// import 'dart:typed_data';

// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:image_picker/image_picker.dart';

// class Chat extends StatefulWidget {
//   const Chat({super.key});

//   @override
//   State<Chat> createState() => _ChatState();
// }

// class _ChatState extends State<Chat> {
//   final Gemini gemini = Gemini.instance;
//   List<ChatMessage> messages = [];

//   ChatUser currentUser = ChatUser(id: "1", firstName: "User");
//   ChatUser geminiUser = ChatUser(
//     id: "2",
//     firstName: "Gemini",
//     profileImage:
//         "https://registry.npmmirror.com/@lobehub/icons-static-png/latest/files/dark/gemini-color.png",
//     // "https://www.gemini.com/_next/image?url=%2Fstatic%2Fimages%2Fgemini-hor-light-full-rgb%403x.png&w=256&q=75",
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Gezy Chat"),
//       ),
//       body: _buildUI(),
//     );
//   }

//   Widget _buildUI() {
//     return DashChat(
//       inputOptions: InputOptions(trailing: [
//         IconButton(
//             onPressed: () {
//               _sendMediaMessage();
//             },
//             icon: Icon(Icons.image))
//       ]),
//       currentUser: currentUser,
//       onSend: _sendMessage,
//       messages: messages,
//     );
//   }

//   void _sendMessage(ChatMessage chatMessage) {
//     setState(() {
//       messages = [
//         chatMessage,
//         ...messages
//       ]; // Add the user's message to the chat
//     });

//     // Create a list of `Part` objects with the user's text input
//     List<Part> parts = [
//       Part.text(chatMessage.text), // Wrap the user's text in a `Part` object
//     ];

//     // Variable to accumulate the streamed response
//     String accumulatedResponse = "";
//     List<Uint8List>? images;
//     if (chatMessage.medias!.isNotEmpty ?? false) {
//       images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
//     }

//     // Send the text input to Gemini using `promptStream`
//     // gemini.promptStream(parts: parts).listen(
//     //   (response) {
//     //     // Extract the text content from the response
//     //     String responseText = response?.content?.parts
//     //             ?.map((part) => (part as TextPart).text) // ✅ Correct
//     //             .join("") ??
//     //         "";

//     //     // Accumulate the response
//     //     accumulatedResponse += responseText;

//     //     // Check if a Gemini message already exists in the chat
//     //     ChatMessage? lastMessage = messages.isNotEmpty
//     //         ? messages.firstWhere(
//     //             (message) => message.user == geminiUser,
//     //             orElse: () => ChatMessage(
//     //                 user: geminiUser,
//     //                 text: "",
//     //                 createdAt: DateTime.now()), // Provide a fallback
//     //           )
//     //         : null;

//     //     if (lastMessage != null) {
//     //       // Update the existing Gemini message
//     //       setState(() {
//     //         lastMessage.text = accumulatedResponse;
//     //       });
//     //     } else {
//     //       // Create a new Gemini message
//     //       setState(() {
//     //         messages = [
//     //           ChatMessage(
//     //             user: geminiUser,
//     //             text: accumulatedResponse,
//     //             createdAt: DateTime.now(),
//     //           ),
//     //           ...messages,
//     //         ];
//     //       });
//     //     }
//     //   },
//     //   onError: (error) {
//     //     // Handle errors
//     //     print("Error: $error");
//     //   },
//     //   onDone: () {
//     //     // Optional: Handle completion of the stream
//     //     print("Stream completed");
//     //   },
//     // );

//     gemini.promptStream(parts: parts).listen(
//       (response) {
//         print("Received response: $response"); // Debugging line
//         String responseText = response?.content?.parts
//                 ?.map((part) => (part as TextPart).text)
//                 .join("") ??
//             "";

//         // Accumulate the response
//         accumulatedResponse = "$accumulatedResponse $responseText".trim();

//         print("Processed response text: $accumulatedResponse"); // Debugging

//         setState(() {
//           messages = [
//             ChatMessage(
//               user: geminiUser,
//               text: accumulatedResponse,
//               createdAt: DateTime.now(),
//             ),
//             ...messages,
//           ];
//         });
//       },
//       onError: (error) {
//         print("Error: $error");
//       },
//     );
//   }

//   void _sendMediaMessage() async {
//     ImagePicker imagePicker = ImagePicker();
//     XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
//     if (file != null) {
//       ChatMessage chatMessage = ChatMessage(
//           user: currentUser,
//           createdAt: DateTime.now(),
//           text: "Describe this picture?",
//           medias: [
//             ChatMedia(url: file.path, fileName: "", type: MediaType.image)
//           ]);
//       _sendMessage(chatMessage);
//     }
//   }
// }

// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "1", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "2",
    firstName: "Gemini",
    profileImage:
        "https://registry.npmmirror.com/@lobehub/icons-static-png/latest/files/dark/gemini-color.png",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Gezy Chat"),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(trailing: [
        IconButton(
          onPressed: _sendMediaMessage,
          icon: const Icon(Icons.image),
        ),
      ]),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    // Reset the accumulated response for each new message
    String accumulatedResponse = "";

    // Add the user's message to the chat
    setState(() {
      messages = [
        chatMessage,
        ...messages,
      ];
    });

    // Create a list of `Part` objects with the user's text input
    List<Part> parts = [
      Part.text(chatMessage.text), // Wrap the user's text in a `Part` object
    ];

    // Add image data if available
    if (chatMessage.medias != null && chatMessage.medias!.isNotEmpty) {
      for (var media in chatMessage.medias!) {
        if (media.type == MediaType.image) {
          Uint8List imageBytes = File(media.url).readAsBytesSync();
          parts
              .add(Part.bytes(imageBytes)); // Add image data as a `Part` object
        }
      }
    }

    // Send the text and image input to Gemini using `promptStream`
    gemini.promptStream(parts: parts).listen(
      (response) {
        // Extract the text content from the response
        String responseText = response?.content?.parts
                ?.map((part) => (part as TextPart).text) // ✅ Correct
                .join("") ??
            "";

        // Accumulate the response (optional, for debugging)
        accumulatedResponse += " $responseText ";

        // Create a new Gemini message for each chunk of the response
        setState(() {
          messages = [
            ChatMessage(
              user: geminiUser,
              text:
                  responseText.trim(), // Use the current chunk of the response
              createdAt: DateTime.now(),
            ),
            ...messages,
          ];
        });
      },
      onError: (error) {
        // Handle errors
        print("Error: $error");
      },
      onDone: () {
        // Optional: Handle completion of the stream
        print("Stream completed");
      },
    );
  }

  void _sendMediaMessage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture?",
        medias: [
          ChatMedia(url: file.path, fileName: "", type: MediaType.image),
        ],
      );
      _sendMessage(chatMessage);
    }
  }
}

// Extension for firstWhereOrNull
extension FirstWhereOrNullExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
