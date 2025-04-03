import 'dart:developer';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/frontend/pages/add_todos.dart';
import 'package:todo_app/frontend/pages/chat_wth_ai.dart';
import 'package:todo_app/frontend/pages/show_todos.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;
  const HomePage({Key? key,this.initialIndex = 0}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final PageController _pageController;
  late final NotchBottomBarController _controller;

  @override
  void initState() {
    super.initState();
    /// Controller to handle PageView and also handles initial page
    _pageController = PageController(initialPage: widget.initialIndex);

    /// Controller to handle bottom nav bar and also handles initial page
    _controller = NotchBottomBarController(index: widget.initialIndex);
  }
  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// widget list
    final List<Widget> bottomBarPages = [
      //List all the pages for bottom bar
      ShowTodosScreen(),
      AddTodosScreen(),
      ChatWithAIScreen(),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: Colors.white.withOpacity(0.3),
        showLabel: false,
        textOverflow: TextOverflow.visible,
        maxLine: 1,
        shadowElevation: 5,
        kBottomRadius: 28.0,
        notchColor: Colors.black87,
        removeMargins: false,
        bottomBarWidth: 500,
        showShadow: false,
        durationInMilliSeconds: 300,
        elevation: 1,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(
              CupertinoIcons.home,
              color: Colors.white.withOpacity(0.7),
              size: 28 ,
            ),
            activeItem: const Icon(
              CupertinoIcons.house_fill,
              color: Colors.white,
              size: 29,
            ),
            itemLabel: "Page 1",
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.add_task_rounded,
              color: Colors.white.withOpacity(0.7),
              size: 27,
            ),
            activeItem: Icon(
              Icons.add_task_outlined,
              color: Colors.white,
              size: 29,
            ),
            itemLabel: 'Page 2',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              CupertinoIcons.chat_bubble_text,
              color: Colors.white.withOpacity(0.7),
              size: 27,
            ),
            activeItem: Icon(
              CupertinoIcons.chat_bubble_text_fill,
              color: Colors.white,
              size: 29,
            ),
            itemLabel: 'Page 3',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.person_outline_rounded,
              color: Colors.white.withOpacity(0.7),
              size: 27,
            ),
            activeItem: Icon(
              Icons.person,
              color: Colors.white,
              size: 29,
            ),
            itemLabel: 'Page 4',
          ),
        ],
        onTap: (index) {
          log('current selected index $index');
          _pageController.jumpToPage(index);
        },
        kIconSize: 24.0,
      )
          : null,
    );
  }
}
