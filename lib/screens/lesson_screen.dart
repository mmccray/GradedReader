import 'package:flutter/material.dart';
import 'package:graded_reader/screens/chapter_screen.dart';
import 'package:graded_reader/screens/comprehension_screen.dart';
import 'package:graded_reader/screens/vocab_screen.dart';

class LessonScreen extends StatefulWidget {
  final String chapterSlug;
  final String bookTitle;

  const LessonScreen({
    super.key,
    required this.chapterSlug,
    required this.bookTitle,
  });

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(widget.bookTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                VocabScreen(chapterSlug: widget.chapterSlug),
                ChapterScreen(chapterSlug: widget.chapterSlug),
                ComprehensionScreen(chapterSlug: widget.chapterSlug),
              ],
            ),
          ),
          Container(
            height: 70,
            color: Theme.of(context).primaryColor,
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: "vocab"),
                Tab(text: "reading"),
                Tab(text: "review"),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.6),
              labelStyle: TextStyle(fontSize: 18),
              unselectedLabelStyle: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}