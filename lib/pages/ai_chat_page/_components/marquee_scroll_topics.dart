import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';

class MarqueeScrollTopics extends StatefulWidget {
  const MarqueeScrollTopics({super.key});

  @override
  State<MarqueeScrollTopics> createState() => _MarqueeScrollTopicsState();
}

class _MarqueeScrollTopicsState extends State<MarqueeScrollTopics>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animationController;

  double scrollSpeed = 30.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(days: 365),
    )..addListener(_autoScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  void _autoScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      final delta = scrollSpeed / 60;

      if (currentScroll + delta >= maxScroll) {
        _scrollController.jumpTo(0);
      } else {
        _scrollController.jumpTo(currentScroll + delta);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Popular Topics",
                  style: TextStyle(
                      color: HexColor.fromHex(AppConstants.primaryText),
                      fontSize: 18)),
              Text("See all",
                  style: TextStyle(
                      color: HexColor.fromHex(AppConstants.primaryText)
                          .withAlpha(127),
                      fontSize: 14)),
            ],
          ),
        ),
        SizedBox(
          height: 190,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: Row(
                children: AppConstants.topics.map((topic) {
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 150,
                    width: 180,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    decoration: BoxDecoration(
                      color: HexColor.fromHex(AppConstants.primaryWhite),
                      borderRadius: BorderRadius.circular(20),
                      border:
                      Border.all(color: Colors.black.withAlpha((0.27 * 255).toInt())),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(20, 0, 0, 0),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                            color: HexColor.fromHex(AppConstants.secondaryBackgroundLight),
                          ),
                          child: SvgPicture.asset(
                            topic.icon,
                            color: HexColor.fromHex("#B567FA"),
                            height: 25,
                            width: 25,
                          ),
                        ),
                        Text(
                          topic.text,
                          style: TextStyle(
                            color: HexColor.fromHex(AppConstants.primaryText),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
