import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:graded_reader/models/book_models.dart';
import 'package:graded_reader/main.dart';

class ChapterScreen extends StatefulWidget {
  final String chapterSlug;

  const ChapterScreen({
    key,
    required this.chapterSlug,
  }) : super(key: key);

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  Word? hoveredWord;
  Offset? tooltipPosition;

  void handleWordTap(Word word, TapDownDetails details) {
    setState(() {
      hoveredWord = word;
      tooltipPosition = details.globalPosition;
    });
  }

  void hideTooltip() {
    setState(() {
      hoveredWord = null;
      tooltipPosition = null;
    });
  }

  Widget buildWord(Word word, int index, int length) {
    
    return GestureDetector(
      onTapDown: (details) => handleWordTap(word, details),
      onTapUp: (_) => hideTooltip(),
      onTapCancel: hideTooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          word.word,
          style: const TextStyle(
            fontSize: 22,
            fontFamily: 'SBLBibLit',
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final chapter = appState.getChapter(widget.chapterSlug);

    String language = appState.selectedBook?.language ?? '';

    if (appState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chapter == null || chapter.content.isEmpty) {
      return const Center(
        child: Text(
          'Chapter not found or content unavailable',
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
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(left:16, right: 16),
              child: Column(
                children: [
                  if (chapter.titleImage != null && chapter.titleImage != "")
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                        maxHeight: MediaQuery.of(context).size.height * 0.3, 
                      ),
                      child: Image(
                        image:
                            AssetImage('assets/images/${chapter.titleImage}'),
                        fit: BoxFit
                            .contain,
                      ),
                    ),
                  Text(
                    chapter.displayTitle,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'SBLBibLit',
                    ),
                    textAlign: language == 'Hebrew' ? TextAlign.right : TextAlign.left,
                    textDirection: language == 'Hebrew' ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  const SizedBox(height: 20),
                  ...chapter.content.map((paragraph) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: language == 'Hebrew' ? CrossAxisAlignment.end : CrossAxisAlignment.start, 
                          children: [
                            if (paragraph.imageAsset != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width,
                                    maxHeight:
                                        MediaQuery.of(context).size.height * .2,
                                  ),
                                  child: Center(
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/${paragraph.imageAsset}'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            if (paragraph.subTitle != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Text(
                                  paragraph.subTitle ?? '',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'SBLBibLit',
                                  ),
                                ),
                              ),  
                            Directionality(
                              textDirection: language == 'Hebrew' ? TextDirection.rtl : TextDirection.ltr,
                              child: Wrap(
                                alignment: WrapAlignment.start, 
                                textDirection: language == 'Hebrew' ? TextDirection.rtl : TextDirection.ltr,
                                children: paragraph.paragraph.expand((verse) {
                                  return verse.words.asMap().entries.map((entry) {
                                    return buildWord(entry.value, entry.key,
                                        verse.words.length);
                                  });
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            if (hoveredWord != null && tooltipPosition != null)
              Positioned(
                top: tooltipPosition!.dy - 100,
                left: tooltipPosition!.dx.clamp(
                  0,
                  MediaQuery.of(context).size.width - 150,
                ),
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(181, 0, 0, 0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    hoveredWord!.gloss,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'SBLBibLit',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
