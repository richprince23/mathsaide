class ChatResponse {
  String content;
  String role;

  ChatResponse({required this.content, required this.role});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      // role: json['role'] ? "user" : "assistant",
      role: json['role'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
      };
}
