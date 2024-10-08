import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:resize/resize.dart';
import 'package:markdown/markdown.dart' as md;

class ChatBubble extends StatelessWidget {
  final bool isUser;
  final String message;
  final String? avatar;
  final bool showAvatar;
  final bool hasTime;
  final String time;
  final String? mediaUrl;
  final bool hasOptions;
  final String msgID;
  final String chatID;

  const ChatBubble({
    required this.isUser,
    required this.message,
    this.msgID = "",
    this.chatID = "",
    this.avatar,
    this.showAvatar = false,
    this.mediaUrl,
    this.hasTime = false,
    this.time = "",
    this.hasOptions = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color getBubbleColor() {
      return isUser ? priColDark : priColLight;
    }

    return InkWell(
      onLongPress: () {
        if (hasOptions) {
          showDialog(
            barrierDismissible: true,
            context: context,
            builder: ((context) {
              return buildChatOptions(context);
            }),
          );
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser && showAvatar) _buildAvatar(),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              margin: EdgeInsets.only(
                left: isUser ? 40.w : 0,
                right: isUser ? 0 : 40.w,
                top: 10.w,
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
              decoration: ShapeDecoration(
                color: getBubbleColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: isUser
                        ? const Radius.circular(16)
                        : const Radius.circular(0),
                    bottomRight: isUser
                        ? const Radius.circular(0)
                        : const Radius.circular(16),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  MarkdownBody(
                    data: message,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        fontSize: 16.sp,
                        color: isUser ? bgCol : txtCol,
                      ),
                    ),
                    extensionSet: md.ExtensionSet(
                      md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                      <md.InlineSyntax>[
                        md.EmojiSyntax(),
                        ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
                        md.

                      ],
                    ),
                  ),
                  if (hasTime && time.isNotEmpty)
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (isUser && showAvatar) _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 20,
      backgroundImage:
          avatar != null ? CachedNetworkImageProvider(avatar!) : null,
      backgroundColor: avatar == null ? Colors.white : null,
      child: avatar == null
          ? Icon(
              Icons.person,
              color: isUser ? priColDark : Colors.black,
            )
          : null,
    );
  }

  Widget buildChatOptions(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  color: Colors.white,
                  child: SizedBox(
                    width: 100.vw,
                    child: ChatBubble(
                      isUser: isUser,
                      message: message,
                      showAvatar: false,
                      hasOptions: false,
                    ),
                  ),
                ),
                SizedBox(height: 10.w),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text("Copy"),
                        leading: const Icon(Icons.copy),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: message)).then(
                            (value) => Navigator.pop(context),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text("Delete"),
                        leading: const Icon(Icons.delete),
                        onTap: () async {
                          // Implement delete functionality
                          Navigator.pop(context);
                        },
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("Cancel"),
                        leading: const Icon(Icons.cancel),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
