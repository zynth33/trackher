import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/chat.dart';
import '../../../utils/enums.dart';

class ChatList extends StatefulWidget {
  final List<Chat> chats;
  const ChatList({super.key, required this.chats});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        thickness: 6,
        radius: Radius.circular(10),
        child: ListView.separated(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          itemCount: widget.chats.length,
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final chat = widget.chats[index];
            return Row(
              textDirection: chat.type == ChatType.user ? TextDirection.ltr : TextDirection.rtl,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: chat.type == ChatType.user ? LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.deepPurpleAccent,
                          Colors.pinkAccent
                        ]) : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    chat.text,
                    softWrap: true,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    gradient: chat.type == ChatType.ai ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.deepPurpleAccent,
                          Colors.purpleAccent
                        ]) : null,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(20, 0, 0, 0),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    chat.type == ChatType.user
                        ? Icons.person_outlined
                        : FontAwesomeIcons.robot,
                    color: chat.type == ChatType.user
                        ? Colors.deepPurple
                        : Colors.white,
                    size: chat.type == ChatType.user
                        ? 20
                        : 15,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}