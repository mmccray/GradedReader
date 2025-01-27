import 'package:flutter/material.dart';
import 'package:graded_reader/models/book_models.dart';
import 'package:graded_reader/widgets/book_card.dart';

class BooksByLanguage extends StatelessWidget {
  const BooksByLanguage({
    super.key,
    required this.context,
    required this.language,
    required this.books,
  });

  final BuildContext context;
  final String language;
  final List<BookDetail> books;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(language,
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: "SBLBibLit",
                  )),
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: books
                    .map((bookDetail) =>
                        BookCard(context: context, bookDetail: bookDetail))
                    .toList(),
              ),
            ),
          ],
        ),
      );
}
