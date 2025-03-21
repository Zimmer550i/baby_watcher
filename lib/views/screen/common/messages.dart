import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/formatter.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final messageController = TextEditingController();
  List<Message> data = [
    Message(
      text:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
      timeStamp: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        10,
        45,
      ),
      isSent: false,
    ),
    Message(
      text: "Lorem Ipsum is",
      timeStamp: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        11,
        45,
      ),
    ),
    Message(
      text: "Lorem Ipsum is simply dummy",
      timeStamp: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        11,
        45,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("BabySitter/Parrent Name", showBackButton: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [...renderMessages(data)]),
              ),
            ),
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
                        onTapOutside: (event) {},
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
                    setState(() {
                      data.add(
                        Message(
                          text: messageController.text,
                          timeStamp: DateTime.now(),
                        ),
                      );
                    });
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
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

List<Widget> renderMessages(List<Message> messages) {
  List<Widget> rtn = [];

  for (int i = 0; i != messages.length; i++) {
    Message current = messages[i];
    // bool showTime = false;
    bool showAvatar = true;

    if (i == 0) {
      // showTime = true;
      rtn.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              current.timeStamp.difference(DateTime.now()) <
                      const Duration(days: 1)
                  ? "Today"
                  : current.timeStamp.year.toString(),

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

    /*

    Implement ShowAvatar Logic Here:

    1. If the previous message is "isSent" then showAvatar is true.
    2. If previous message is not "isSent" and if time difference is 
       more than 1 hour then showAvatar is true.

    */

    // Print Message
    if (current.isSent) {
      // User's Message
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
                    borderRadius: BorderRadius.circular(
                      8,
                    ).copyWith(topRight: Radius.circular(0)),
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
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              showAvatar
                  ? ClipOval(
                    child: Image.asset(
                      "assets/images/baby_1.png",
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                  // ignore: dead_code
                  : const SizedBox(width: 40),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.gray[100],
                    borderRadius: BorderRadius.circular(
                      8,
                    ).copyWith(topLeft: Radius.circular(0)),
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

    if (i < messages.length - 1) {
      if (current.timeStamp.difference(messages[i + 1].timeStamp).abs() >=
          const Duration(hours: 1)) {
        rtn.add(
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  Formatter.timeFormatter(dateTime: current.timeStamp),
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 400)],
                    fontSize: 10,
                    color: Color(0xff797C7B),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      rtn.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              Formatter.timeFormatter(dateTime: current.timeStamp),
              style: TextStyle(
                fontVariations: [FontVariation("wght", 400)],
                fontSize: 10,
                color: Color(0xff797C7B),
              ),
            ),
          ],
        ),
      );
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
