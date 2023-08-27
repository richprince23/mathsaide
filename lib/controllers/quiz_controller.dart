import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/auth_controller.dart';

Future generateQuestions({String topic = "Algebra", int number = 10}) async {
  // get student age
  int? age;
  // get student level
  String? level;

  await db
      .collection("user_details")
      .where("userID", isEqualTo: auth.currentUser!.uid)
      .get()
      .then((value) {
    if (value.docs.isNotEmpty) {
      age = value.docs.first.data()["age"];
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
    "model": "gpt-3.5-turbo",
    "temperature": 0.9,
    "max_tokens": 256,
    "frequency_penalty": 0,
    "presence_penalty": 0.5,
    "stop": 'finish',
    "top_p": 1,
    "n": 1,
    "messages": [
      {
        "role": "system",
        "content":
            "Generate $number Mutliple Choice Questions with 4 options for a $level student on the topic $topic."
      }
    ],
  });

  try {
    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());

      return response.body;
    } else {
      return ("${response.reasonPhrase!} ${response.statusCode}");
    }
  } catch (e) {
    throw Exception(e);
  }
}
