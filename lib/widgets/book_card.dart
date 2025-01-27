import 'package:flutter/material.dart';
import 'package:graded_reader/main.dart';
import 'package:graded_reader/models/book_models.dart';
import 'package:graded_reader/screens/book_screen.dart';
import 'package:provider/provider.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.context,
    required this.bookDetail,
  });

  final BuildContext context;
  final BookDetail bookDetail;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      context.read<MyAppState>().selectBook(bookDetail);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookScreen(bookSlug: bookDetail.slug),
        ),
      );
    },
    child: Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      child: SizedBox(
        width: 200, 
        child: ClipRRect( 
          borderRadius: BorderRadius.circular(15), 
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              AspectRatio(
                aspectRatio: 9 / 16,
                child: Image(
                  image: AssetImage('assets/images/${bookDetail.slug}.png'),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bookDetail.title,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      bookDetail.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}