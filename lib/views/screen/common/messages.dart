import 'package:baby_watcher/controllers/message_controller.dart';
import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/formatter.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  final user = Get.find<UserController>();
  final controller = Get.find<MessageController>();

  @override
  void initState() {
    super.initState();
    if (user.connectionId.value != null) {
      controller.initialize();
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (user.connectionId.value == null) {
      return Center(child: Text("No Connection Added"));
    }
    return Scaffold(
      appBar: customAppBar(
        user.connectionName ?? "Connecting...",
        showBackButton: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Obx(() {
              if (controller.isLoading.value) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: [...renderMessages(controller.messages)],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.indigo[50],
                    ),
                    child: Center(
                      child: TextField(
                        controller: messageController,
                        focusNode: messageFocusNode,
                        onTapOutside: (event) {
                          messageFocusNode.unfocus();
                        },
                        onSubmitted: (value) {
                          controller.sendMessage(messageController.text.trim());
                          messageController.text = "";
                          messageFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                          hintText: "Type your message...",
                          hintStyle: TextStyle(
                            fontVariations: [FontVariation("wght", 500)],
                            fontSize: 12,
                            color: AppColors.gray[300],
                            height: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(99),
                  onTap: () {
                    controller.sendMessage(messageController.text.trim());
                    messageController.text = "";
                  },
                  child: Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.indigo,
                    ),
                    child: Transform.translate(
                      offset: Offset(-1, 2),
                      child: Center(child: SvgPicture.asset(AppIcons.send)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

List<Widget> renderMessages(List<Message> messages) {
  List<Widget> rtn = [];
  final user = Get.find<UserController>();

  for (int i = 0; i != messages.length; i++) {
    Message current = messages[i];
    bool showAvatar = true;

    if (i == 0 ||
        current.timeStamp.difference(messages[i - 1].timeStamp) >
            const Duration(hours: 1)) {
      rtn.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Formatter.timeFormatter(
                dateTime: current.timeStamp,
                showDate: true,
              ),

              style: TextStyle(
                fontVariations: [FontVariation("wght", 400)],
                fontSize: 12,
                color: Color(0xff797C7B),
              ),
            ),
          ],
        ),
      );
    }

    if (i != 0 &&
        !messages[i - 1].isSent &&
        messages[i - 1].timeStamp.difference(messages[i].timeStamp) <
            const Duration(hours: 1)) {
      showAvatar = false;
    }

    // Print Message
    if (current.isSent) {
      rtn.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 48),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: getRadius(
                      i == 0 ? null : messages[i - 1],
                      messages[i],
                      i == messages.length - 1 ? null : messages[i + 1],
                    ),
                    color: AppColors.indigo,
                  ),
                  child: Text(
                    current.text,
                    style: TextStyle(
                      fontVariations: [FontVariation("wght", 500)],
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Sender's Message
      rtn.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              showAvatar
                  ? ProfilePicture(
                    image: user.connectionImage,
                    size: 40,
                    showLoading: false,
                  )
                  : const SizedBox(width: 40),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.gray[100],
                    borderRadius: getRadius(
                      i == 0 ? null : messages[i - 1],
                      messages[i],
                      i == messages.length - 1 ? null : messages[i + 1],
                    ),
                  ),
                  child: Text(
                    current.text,
                    style: TextStyle(
                      fontVariations: [FontVariation("wght", 500)],
                      fontSize: 12,
                      color: AppColors.gray[600],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
      );
    }
  }

  return rtn;
}

BorderRadius getRadius(Message? prev, Message current, Message? next) {
  BorderRadius rtn = BorderRadius.circular(8);

  if (prev == null) {
    if (current.isSent) {
      rtn = rtn.copyWith(topRight: Radius.circular(0));
    }
    if (!current.isSent) {
      rtn = rtn.copyWith(topLeft: Radius.circular(0));
    }
  }
  if (prev != null) {
    if (current.isSent && prev.isSent) {
      rtn = rtn.copyWith(topRight: Radius.circular(0));
    }
    if (current.isSent && !prev.isSent) {
      rtn = rtn.copyWith(topRight: Radius.circular(0));
    }
    if (!current.isSent && prev.isSent) {
      rtn = rtn.copyWith(topLeft: Radius.circular(0));
    }
    if (!current.isSent && !prev.isSent) {
      rtn = rtn.copyWith(topLeft: Radius.circular(0));
    }
  }
  if (next != null) {
    if (current.isSent && next.isSent) {
      rtn = rtn.copyWith(bottomRight: Radius.circular(0));
    }
    if (!current.isSent && !next.isSent) {
      rtn = rtn.copyWith(bottomLeft: Radius.circular(0));
    }
  }

  return rtn;
}

class Message {
  final String text;
  final DateTime timeStamp;
  final bool isSent;
  const Message({
    required this.text,
    required this.timeStamp,
    this.isSent = true,
  });
}
