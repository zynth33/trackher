import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchBarWithFocusBorder extends StatefulWidget {
  final VoidCallback onSearch;
  const SearchBarWithFocusBorder({super.key, required this.onSearch});

  @override
  State<SearchBarWithFocusBorder> createState() => _SearchBarWithFocusBorderState();
}

class _SearchBarWithFocusBorderState extends State<SearchBarWithFocusBorder> {
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
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 25.0, right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: _isFocused ? Colors.deepPurple : Colors.grey.shade100,
          width: 1.5,
        ),
        color: _isFocused ? Colors.purpleAccent.withValues(alpha: 0.1) : Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(20, 0, 0, 0),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(Icons.search, color: Colors.grey),
          Expanded(
            child: TextFormField(
              maxLines: 1,
              focusNode: _focusNode,
              controller: _textEditingController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ask me anything about your health…',
                  hintStyle: TextStyle(color: Colors.grey),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none
              ),
              onChanged: (value) {
                setState(() {

                });
              },
              style: const TextStyle(color: Colors.black),
            ),
          ),

          _textEditingController.text.isNotEmpty ? InkWell(
            onTap: () {
              _textEditingController.text = "";
              widget.onSearch();
            },
            child: Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurpleAccent,
                      Colors.pinkAccent
                    ]),
              ),
              child: SvgPicture.asset('assets/icons/share.svg'),
            ),
          ) : SizedBox.shrink()
        ],
      ),
    );
  }
}