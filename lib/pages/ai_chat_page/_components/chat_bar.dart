import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trackher/pages/ai_chat_page/ai_chatting_page/chatting_page.dart';
import 'package:trackher/utils/assets.dart';
import 'package:trackher/utils/constants.dart';
import 'package:trackher/utils/extensions/color.dart';

class ChatBar extends StatefulWidget {
  final VoidCallback onSearch;
  const ChatBar({super.key, required this.onSearch});

  @override
  State<ChatBar> createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: HexColor.fromHex(AppConstants.secondaryBackgroundLight),
              ),
              child: TextFormField(
                maxLines: 1,
                focusNode: _focusNode,
                controller: _textEditingController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: HexColor.fromHex(AppConstants.primaryText).withValues(alpha: 0.7),
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {});
                },
                style: TextStyle(
                  color: HexColor.fromHex(AppConstants.primaryText),
                ),
              ),
            ),
          ),
          SizedBox(width: 10,),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChattingPage()));
            },
            child: Container(
              height: 55,
              width: 55,
              // padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: HexColor.fromHex(AppConstants.secondaryBackgroundLight),
              ),
              child: Center(
                child: SvgPicture.asset(AppAssets.iconShare)
              ),
            ),
          ),
        ],
      ),
    );
  }
}