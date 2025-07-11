// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/auth_controller.dart';
import 'package:mathsaide/controllers/prefs.dart';
import 'package:mathsaide/models/response_model.dart';

List<ChatResponse> chatHistory = [];
List<ChatResponse> queryHistory = [];
// String? topic;
String? sessionID, topic = "";

// String systemSolvePrompt =
//     "You are a math assistance application designed to guide users in solving mathematics questions related to the topic of $topic. Your goal is to provide hints, tips, and guidance to help users approach and solve math problems on their own. You should avoid directly solving the problems for them. Upon receiving a math question, your response should focus on giving the user step-by-step guidance on how to approach the problem, offering hints, suggesting relevant formulas, and explaining key concepts. If the user's final answer is correct, you should validate it and provide a similar question for them to practice independently. If a question falls outside the realm of mathematics or the specified topic, reply with 'This is outside Mathematics and the $topic'. Your interaction should be Socratic in nature, engaging the user in an active problem-solving process. Remember, your goal is to empower users to enhance their mathematical skills through thoughtful guidance.";
String systemSolvePrompt =
    "You are a Maths tutor that always responds in the Socratic style. You never give the student the answer, but always try to ask just the right question to help them learn to think for themselves. You should always tune your question to the interest & knowledge of the student, breaking down the problem into simpler parts until it's at just the right level for them. Reply with 'I can only do Mathematics' if the question is outside the realm of Mathematics and the specified topic. Try to keep the conversation going as long as possible, and remember that your goal is to empower the student to enhance their mathematical skills through thoughtful guidance.";

Future sendMessage(String message) async {
  //send message to the server
  //if the message is a question, wait for the response
  //if the message is a response, display the response
  //
  // final String userID = FirebaseAuth.instance.currentUser!.uid;
  // ignore: prefer_typing_uninitialized_variables
  var response;

  String? content;
  // String role;
  // chatHistory.add(ChatResponse(content: systemSolvePrompt, role: "system"));

  try {
    await Prefs.getSession()
        .then((value) => value = sessionID)
        .then((e) => Prefs.getTopic().then((value) async => {
              topic = value,
              // print("topic issss: $value"),
            }));
    await makeRequest(message).then((value) {
      response = jsonDecode(value!);

      if (response != null &&
          response['choices'] != null &&
          response['choices'].isNotEmpty) {
        content = response['choices'][0]['message']['content'];
        // role = response['choices'][0]['message']['role'];

        // print("asdsd $response");

        // chatHistory.add(ChatResponse(content: content, role: "assistant"));
      } else {
        // Handle the case when the 'choices' key is not present or empty in the response
        // print("Invalid response format: $response");
        throw Exception("Invalid response format: $response");
      }
    });

    return content;
  } catch (e) {
    // print(e);
    throw Exception(e);
  }
}

Future<String?> makeRequest(String message) async {
  // var url = Uri.parse("https://api.openai.com/v1/chat/completions");
  // String systemPrompt = systemSolvePrompt;
  String userPrompt = message.trim();

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': "Bearer $apiKey"
  };

  chatHistory.add(ChatResponse(content: userPrompt, role: "user"));

  var history = chatHistory.map((e) => e.toJson()).toList();

  var body = jsonEncode({
    // "model": "text-davinci-003",
    "model": "gpt-4o-mini",
    "temperature": 0.7,
    "max_tokens": 400,
    "frequency_penalty": 0.2,
    "presence_penalty": 0.5,
    "stop": 'finish',
    "top_p": 0.1,
    "n": 1,
    "messages": history,
    // "messages": chatHistory,
  });

  try {
    var request = http.Request(
        'POST', Uri.parse('https://api.openai.com/v1/chat/completions'));
    request.body = (body);
    //     '''{"model": "gpt-4o-mini","messages": [{"role": "system","content": $systemPrompt},{"role": "user", "content": $userPrompt}],"max_tokens": 200,"temperature": 0.9,"top_p": 1,"n": 1,"stop": "finish"}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      return await response.stream.bytesToString();
    } else {
      // print("${response.reasonPhrase!} ${response.statusCode}");
      return ("${response.reasonPhrase!} ${response.statusCode}");
    }
  } catch (e) {
    throw Exception(e);
  }
}

/// This is the method to send chat history to Firestore database
/// [sessionID] is the session ID
/// [topic] is the topic of the session
/// [userID] is the user ID of the user
/// [role] is the role of the user
/// [content] is the content of the message

// send chat history to Firestore database

Future<void> uploadChat({required String content, required String role}) async {
  if (content.isEmpty || role.isEmpty) return;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference sessionsCollection =
      firestore.collection('sessions');

  await Prefs.getSession().then((value) async {
    sessionID = value!;
    await Prefs.getTopic().then((value) async {
      topic = value;
      // Query sessions by the provided sessionID
      QuerySnapshot sessionQuery = await sessionsCollection
          .where('sessionID', isEqualTo: sessionID)
          .get();
      // print("")
      if (sessionQuery.docs.isNotEmpty && sessionQuery.size > 0) {
        // Session document with provided sessionID exists, add chat to subcollection
        String sessionDocID = sessionQuery.docs.first.id;

        await sessionsCollection.doc(sessionDocID).collection('chats').add({
          'content': content,
          'isUser': role == "user" ? true : false,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        // Session document with provided sessionID doesn't exist, create session and add chat
        DocumentReference sessionDocRef = sessionsCollection
            .doc(sessionID); // Use the sessionID as the document ID

        await sessionDocRef.set({
          'sessionID': sessionID,
          'topic': topic,
          'userID': auth.currentUser!.uid
        }).then(
          (value) async => await sessionDocRef.collection('chats').add({
            'content': content,
            'isUser': role == "user" ? true : false,
            'timestamp': FieldValue.serverTimestamp(),
          }),
        );

        chatHistory.add(ChatResponse(content: content, role: role));
      }
    });
  });
}

///
///
/// Function to generate pactice questions for users to try and evaluate response
Future generatePracticeQuestions(String? message) async {
  // final String userID = FirebaseAuth.instance.currentUser!.uid;
  // ignore: prefer_typing_uninitialized_variables
  // var response;

  String? content;

  try {
    await Prefs.getSession().then((value) => sessionID = value).then(
          (e) => Prefs.getTopic().then((value) => topic = value),
        );

    if (message != "" || message!.isNotEmpty) {
      queryHistory.add(ChatResponse(content: message!.trim(), role: "user"));
    } else {
      queryHistory
          .add(ChatResponse(content: "Give me a question", role: "user"));
    }
    // String userPrompt = message!.trim();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $apiKey"
    };

    // queryHistory.add(ChatResponse(content: userPrompt, role: "user"));

    var history = queryHistory.map((e) => e.toJson()).toList();

    // print(history);

    var body = jsonEncode({
      // "model": "text-davinci-003",
      "model": "gpt-4o-mini",
      "temperature": 0.7,
      "max_tokens": 400,
      "frequency_penalty": 0.2,
      "presence_penalty": 0.5,
      "stop": 'finish',
      "top_p": 0.1,
      "n": 1,
      "messages": history,

      // "messages": chatHistory,
    });

    // try {
    var request = http.Request(
        'POST', Uri.parse('https://api.openai.com/v1/chat/completions'));
    request.body = (body);
    //     '''{"model": "gpt-4o-mini","messages": [{"role": "system","content": $systemPrompt},{"role": "user", "content": $userPrompt}],"max_tokens": 200,"temperature": 0.9,"top_p": 1,"n": 1,"stop": "finish"}''';
    request.headers.addAll(headers);

    // ignore: prefer_typing_uninitialized_variables
    var res;
    http.StreamedResponse response = await request.send();
    // response = await response.stream
    //     .bytesToString();

    if (response.statusCode == 200) {
      await response.stream
          .bytesToString()
          .then((value) => res = jsonDecode(value));
      if (res != null && res['choices'] != null && res['choices'].isNotEmpty) {
        content = res['choices'][0]['message']['content'];

        //add to chat history
        queryHistory.add(ChatResponse(content: content!, role: "assistant"));
        return content;
      } else {
        // print("${response.reasonPhrase!} ${response.statusCode}");
        return ("${response.reasonPhrase!} ${response.statusCode}");
      }
    } else {
      // print("${response.reasonPhrase!} ${response.statusCode}");
      return ("${response.reasonPhrase!} ${response.statusCode}");
    }
    // } catch (e) {
    //   throw Exception(e);
    // }
    // return content;
  } catch (e) {
    // print(e);
    throw Exception(e);
  }
}

//delete chat history from firestore

Future deleteChatHistory(String sessionID) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference sessionsCollection =
      firestore.collection('sessions');

  QuerySnapshot sessionQuery =
      await sessionsCollection.where('sessionID', isEqualTo: sessionID).get();

  if (sessionQuery.docs.isNotEmpty && sessionQuery.size > 0) {
    // Session document with provided sessionID exists, delete chat subcollection
    String sessionDocID = sessionQuery.docs.first.id;

    await sessionsCollection
        .doc(sessionDocID)
        .collection('chats')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
