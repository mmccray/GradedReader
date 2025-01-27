import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:graded_reader/main.dart';

class VocabScreen extends StatefulWidget {
  final String chapterSlug;

  const VocabScreen({
    Key? key,
    required this.chapterSlug,
  }) : super(key: key);

  @override
  State<VocabScreen> createState() => _VocabScreenState();
}

class _VocabScreenState extends State<VocabScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final chapter = appState.getChapter(widget.chapterSlug);

    if (appState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chapter == null || (chapter.vocab == null || chapter.vocab!.isEmpty)) {
      return const Center(
        child: Text(
          'Chapter not found or vocabulary unavailable',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18,
            fontFamily: 'SBLBibLit',
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              ...?chapter.vocab?.map((vocab) => VocabCard(
                    image: vocab.image,
                    word: vocab.word,
                    gloss: vocab.gloss,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class VocabCard extends StatelessWidget {
  final String? image;
  final String word;
  final String gloss;

  const VocabCard({
    Key? key,
    this.image,
    required this.word,
    required this.gloss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null)
              Image(
                image: AssetImage('$image'),
                fit: BoxFit.contain,
              ),

            if (image != null) SizedBox(height: 8),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                word,
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.normal,
                    fontFamily: "SBLBibLit"),
              ),
            ),
            SizedBox(height: 4),
            // Display the gloss
            Center(
              child: Text(
                textAlign: TextAlign.center,
                gloss,
                style: TextStyle(
                  fontSize: 14,
                  color: const Color.fromARGB(93, 117, 117, 117),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
