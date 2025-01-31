// lib/services/book_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/book_models.dart';

class BookService {
  Future<List<BookDetail>> loadBooks() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/books/books.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map<BookDetail>((jsonBook) => BookDetail.fromJson(jsonBook)).toList();
    } catch (e) {
      print('Error loading book details: $e');
      return []; // Return an empty list or handle error appropriately
    }
  }

  Future<Book> loadBookContent(String bookSlug, List<BookDetail> books) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/books/$bookSlug.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      var bookDetail = books.firstWhere((book) => book.slug == bookSlug);
      return Book(
        id: bookDetail.id,
        slug: bookSlug,
        author: bookDetail.author,
        title: bookDetail.title,
        language: bookDetail.language,
        description: bookDetail.description,
        chapters: (jsonData['chapters'] as List<dynamic>).map<Chapter>((chapterJson) => Chapter.fromJson(chapterJson)).toList(),
      );
    } catch (e) {
      print('Error loading book content: $e');
      throw Exception('Failed to load book content'); // Or handle error differently
    }
  }
}