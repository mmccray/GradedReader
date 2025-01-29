// books_page.dart
import 'package:flutter/material.dart';
import 'package:graded_reader/models/book_models.dart';
import 'package:graded_reader/screens/lesson_screen.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class BookScreen extends StatelessWidget {
  final String bookSlug;

  BookScreen({super.key, required this.bookSlug});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    // Check if the book content is still loading
    if (appState.isBookLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Loading...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Fetch the selected book from appState
    Book? book = appState.selectedBook;

    if (book == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Book Not Found')),
        body: Center(child: Text('No book found with slug: $bookSlug')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.only(left: 20, right: 20),
          itemCount: book.chapters.length,
          itemBuilder: (context, index) {
            final chapter = book.chapters[index];
            return ListTile(
              title: Text(
                chapter.displayTitle,
                textAlign: book.language == 'Hebrew' ? TextAlign.right : TextAlign.left,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w200, fontFamily: "SBLBibLit"),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey), // Arrow to show it's clickable
              
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonScreen(chapterSlug: chapter.slug, bookTitle: book.title,),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}