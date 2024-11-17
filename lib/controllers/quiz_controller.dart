import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/auth_controller.dart';

//genrate random question
//not used
Future<String?> generateQuestions(
    {String topic = "Algebra", int number = 10}) async {
  // get student age
  // int? age;
  // get student level
  String? level;
  //quiz questions list
  // List<Question> questionList = [];

  await db
      .collection("user_details")
      .where("userID", isEqualTo: auth.currentUser!.uid)
      .get()
      .then((value) {
    if (value.docs.isNotEmpty) {
      // age = value.docs.first.data()["age"];
      level = value.docs.first.data()["class"];
    }
  });

  // make a call to gpt3.5 api to get questions
  // return a list of questions

  Uri url = Uri.parse('https://api.openai.com/v1/chat/completions');

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': "Bearer $apiKey"
  };

  var body = jsonEncode({
    "model": "gpt-4o",
    "temperature": 0.7,
    // "max_tokens": 400,
    "frequency_penalty": 0,
    "presence_penalty": 0.5,
    "stop": 'finish',
    "top_p": 1,
    "n": 1,
    "messages": [
      {
        "role": "system",
        "content":
            """Generate $number Multiple Choice Questions with 4 options for a $level student on the topic $topic. Format response as json like "question": "Simplify: 3sin(π/6) + 2cos(π/3)",
        "options": [
            "3 + √3",
            "2√2 + 3√3",
            "4/√2",
            "3√2 + 2√3"
        ],
        "correct_answer": "3 + √3"."""
      }
    ],
  });

  try {
    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      // print(response.body);
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      String content = jsonData['choices'][0]['message']['content'];
      // print("content is $content");

      return content;
    } else {
      // return ("${response.reasonPhrase!} ${response.statusCode}");
      return null;
    }
  } catch (e) {
    throw Exception(e);
  }
}

//Generate random String for quiz ID
String generateRandomString() {
  final Random random = Random.secure();
  const String chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  return List.generate(16, (index) => chars[random.nextInt(chars.length)])
      .join();
}

///Get quiz history
///
///Returns a list of quiz history
Stream<QuerySnapshot<Map<String, dynamic>>> getQuizHistory() {
  final results = FirebaseFirestore.instance
      .collection("quiz_grades")
      .where("userID", isEqualTo: auth.currentUser!.uid)
      .orderBy("timestamp", descending: false)
      .snapshots();
  return results;
}

//delete quiz from firebase

Future deleteQuiz(String quizID) async {
  Future.delayed(const Duration(seconds: 2));
  await db.collection("quiz_grades").doc(quizID).delete();
}
