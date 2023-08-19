// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathsaide/controllers/prefs.dart';
import 'package:mathsaide/env.dart';
import 'package:mathsaide/models/response_model.dart';

List<ChatResponse> chatHistory = [];
// String? topic;
String? sessionID, topic = "";

// String systemSolvePrompt =
//     "You are a math assistance application designed to guide users in solving mathematics questions related to the topic of $topic. Your goal is to provide hints, tips, and guidance to help users approach and solve math problems on their own. You should avoid directly solving the problems for them. Upon receiving a math question, your response should focus on giving the user step-by-step guidance on how to approach the problem, offering hints, suggesting relevant formulas, and explaining key concepts. If the user's final answer is correct, you should validate it and provide a similar question for them to practice independently. If a question falls outside the realm of mathematics or the specified topic, reply with 'This is outside Mathematics and the $topic'. Your interaction should be Socratic in nature, engaging the user in an active problem-solving process. Remember, your goal is to empower users to enhance their mathematical skills through thoughtful guidance.";
String systemSolvePrompt =
    "You are a Maths tutor that always responds in the Socratic style. You never give the student the answer, but always try to ask just the right question to help them learn to think for themselves. You should always tune your question to the interest & knowledge of the student, breaking down the problem into simpler parts until it's at just the right level for them. Reply with 'I can only do Mathematics' if the question is outside the realm of Mathematics or the specified topic. Try to keep the conversation going as long as possible, and remember that your goal is to empower the student to enhance their mathematical skills through thoughtful guidance. Output the answer to the question only if the student has already solved it. If the student has not solved the question, output a similar question for them to practice independently. Maths equations should be output in LaTeX format.";

Future sendMessage(String message) async {
  //send message to the server
  //if the message is a question, wait for the response
  //if the message is a response, display the response
  //
  // final String userID = FirebaseAuth.instance.currentUser!.uid;
  var response, content, role;
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
        role = response['choices'][0]['message']['role'];

        print("asdsd $response");

        // chatHistory.add(ChatResponse(content: content, role: "assistant"));
      } else {
        // Handle the case when the 'choices' key is not present or empty in the response
        print("Invalid response format: $response");
      }
    });

    return content;
  } catch (e) {
    throw Exception(e);
  }
}

Future<String?> makeRequest(String message) async {
  var url = Uri.parse("https://api.openai.com/v1/chat/completions");
  String systemPrompt = systemSolvePrompt.replaceAll("topic", topic ?? "");
  String userPrompt = message.trim();

  var headers = {
    'Content-Type': 'application/json',
    //TODO: remove the API key
    'Authorization': apiKey
  };

  chatHistory.add(ChatResponse(content: userPrompt, role: "user"));

  var history = chatHistory.map((e) => e.toJson()).toList();

  var body = jsonEncode({
    // "model": "text-davinci-003",
    "model": "gpt-3.5-turbo",
    "temperature": 0.9,
    "max_tokens": 256,
    "frequency_penalty": 0,
    "presence_penalty": 0,
    "stop": 'finish',
    "top_p": 1, "n": 1,
    "messages": history,
    // "messages": chatHistory,
  });

  // print(body);
  // print(history);

  // try {
  var request = http.Request(
      'POST', Uri.parse('https://api.openai.com/v1/chat/completions'));
  request.body = (body);
  //     '''{"model": "gpt-3.5-turbo","messages": [{"role": "system","content": $systemPrompt},{"role": "user", "content": $userPrompt}],"max_tokens": 200,"temperature": 0.9,"top_p": 1,"n": 1,"stop": "finish"}''';
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    return await response.stream.bytesToString();
  } else {
    print(response.reasonPhrase! + " " + response.statusCode.toString());
    return ("${response.reasonPhrase!} ${response.statusCode}");
  }
  // } catch (e) {
  //   throw Exception(e);
  // }
}
