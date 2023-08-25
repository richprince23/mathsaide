import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:resize/resize.dart';

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
  // final Color fontColor;

  const ChatBubble(
      {required this.isUser,
      required this.message,
      this.msgID = "",
      this.chatID = "",
      this.avatar,
      this.showAvatar = false,
      this.mediaUrl,
      this.hasTime = false,
      this.time = "",
      this.hasOptions = false,
      // this.fontColor = txtCol,
      super.key});

  @override
  Widget build(BuildContext context) {
    Color getBubbleColor() {
      if (isUser) {
        // return Colors.black87;
        return priColDark;
      } else {
        // return Colors.black54;
        return priColLight;
      }
    }

    return InkWell(
      onLongPress: () {
        if (hasOptions == true) {
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
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isUser == false && showAvatar == true)
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  avatar != null ? CachedNetworkImageProvider(avatar!) : null,
              backgroundColor: avatar == null ? Colors.white : null,
              child: avatar == null
                  ? const Icon(
                      Icons.person,
                      color: Colors.black,
                    )
                  : null,
            ),
          Flexible(
            fit: FlexFit.loose,
            child: IntrinsicWidth(
              child: Container(
                // elevation: 0,
                alignment: isUser ? Alignment.topRight : Alignment.topLeft,
                margin: isUser
                    ? EdgeInsets.only(left: 40.w, top: 10.w)
                    : EdgeInsets.only(right: 40.w, top: 10.w),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: isUser == true
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        color: isUser ? bgCol : txtCol,
                        fontSize: 16.sp,
                      ),
                    ),
                    if (hasTime == true && time != "")
                      Text(
                        (time),
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
          ),
          if (isUser == true && showAvatar == true)
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  avatar != null ? CachedNetworkImageProvider(avatar!) : null,
              backgroundColor: avatar == null ? Colors.white : null,
              child: avatar == null
                  ? Icon(
                      Icons.person,
                      color: priColDark,
                    )
                  : null,
            ),
        ],
      ),
    );
  }

  buildChatOptions(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: IntrinsicHeight(
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
                  SizedBox(
                    height: 10.w,
                  ),
                  Expanded(
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text("Copy"),
                            leading: const Icon(Icons.copy),
                            onTap: () {
                              //copy to clipboard
                              Clipboard.setData(ClipboardData(text: message))
                                  .then(
                                (value) => Navigator.pop(context),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text("Delete"),
                            leading: const Icon(Icons.delete),
                            onTap: () async {},
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
