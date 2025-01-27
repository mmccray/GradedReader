import 'package:flutter/material.dart';
import 'package:graded_reader/services/book_service.dart';
import 'package:graded_reader/widgets/books_by_language.dart';
import 'package:provider/provider.dart';

import 'models/book_models.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Grader Reader',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.lerp(ColorScheme.dark(), ColorScheme.light(), 30)
        ),
        home: HomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<BookDetail> myBooks = [];
  Book? selectedBook;
  bool isLoading = true;
  bool isBookLoading = false;

  String? language;

  final BookService _bookService = BookService();

  MyAppState() {
    loadBooks();
  }

  Future<void> loadBooks() async {
    isLoading = true;
    notifyListeners();
    try {
      myBooks = await _bookService.loadBooks();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBookContent(String bookSlug) async {
    isBookLoading = true;
    notifyListeners();
    try {
      selectedBook = await _bookService.loadBookContent(bookSlug, myBooks);
      isBookLoading = false;
      notifyListeners();
    } catch (e) {
      isBookLoading = false;
      notifyListeners();
    }
  }

  void selectBook(BookDetail bookDetail) {
    loadBookContent(bookDetail.slug);
  }

  Chapter? getChapter(String slug) {
    return selectedBook?.chapters.firstWhere(
      (chapter) => chapter.slug == slug,
      orElse: () => Chapter(displayTitle: '', glossTitle: '', slug: '', content: []),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Book'),
      ),
      body: SingleChildScrollView( 
        child: Column(
          children: [
            BooksByLanguage(context: context, language: 'עִבְרִית', books: appState.myBooks.where((book) => book.language == 'Hebrew').toList()),
            BooksByLanguage(context: context, language: 'Ἑλληνική', books: appState.myBooks.where((book) => book.language == 'Greek').toList()),
            // Add more languages sections as needed
          ],
        ),
      ),
    );
  }
}
