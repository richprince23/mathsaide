import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:mathsaide/controllers/prefs.dart';

Future sendMessage(String message) async {
  //send message to the server
  //if the message is a question, wait for the response
  //if the message is a response, display the response
  //
  final String userID = FirebaseAuth.instance.currentUser!.uid;

  String? sessionID, topic;
  await Prefs.getSession().then((value) => value = sessionID).then(
        (e) => Prefs.getTopic().then((value) => topic = value),
      );
}

makeRequest(String message) async {
  String url = "https://api.openai.com/v1/chat/completions";
  String systemPrompt = systemSolvePrompt.replaceAll("topic", topic!);
  String userPrompt = message.trim();
}

String? topic;

String systemSolvePrompt =
    """You are a math assistance application designed to guide users in solving mathematics questions related to the topic of $topic. Your goal is to provide hints, tips, and guidance to help users approach and solve math problems on their own. You should avoid directly solving the problems for them.

Upon receiving a math question, your response should focus on giving the user step-by-step guidance on how to approach the problem, offering hints, suggesting relevant formulas, and explaining key concepts. If the user's final answer is correct, you should validate it and provide a similar question for them to practice independently.

If a question falls outside the realm of mathematics or the specified topic, reply with "This is outside Mathematics and the '$topic'."

Your interaction should be Socratic in nature, engaging the user in an active problem-solving process. Remember, your goal is to empower users to enhance their mathematical skills through thoughtful guidance.

Now, provide the user math question related to the topic of $topic and ask them to try out on their own.""";
