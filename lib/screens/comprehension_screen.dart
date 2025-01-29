import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:graded_reader/models/book_models.dart';
import 'package:graded_reader/main.dart';

class ComprehensionScreen extends StatefulWidget {
  final String chapterSlug;

  const ComprehensionScreen({
    Key? key,
    required this.chapterSlug,
  }) : super(key: key);

  @override
  State<ComprehensionScreen> createState() => _ComprehensionScreenState();
}

class _ComprehensionScreenState extends State<ComprehensionScreen> {
  ComprehensionQuestions? hoveredQuestion;
  Offset? tooltipPosition;

  void handleQuestionTap(
      ComprehensionQuestions question, TapDownDetails details) {
    setState(() {
      hoveredQuestion = question;
      tooltipPosition = details.globalPosition;
    });
  }

  void hideTooltip() {
    setState(() {
      hoveredQuestion = null;
      tooltipPosition = null;
    });
  }

  Widget buildQuestion(ComprehensionQuestions question, String language) {
    return GestureDetector(
      onTapDown: (details) => handleQuestionTap(question, details),
      onTapUp: (_) => hideTooltip(),
      onTapCancel: hideTooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Directionality(
          textDirection:
              language == 'Hebrew' ? TextDirection.rtl : TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    textAlign:
                        language == 'Hebrew' ? TextAlign.right : TextAlign.left,
                    question.question,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'SBLBibLit',
                    ),
                  ),
                ),
              ),
            ],
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

    if (chapter == null ||
        (chapter.comprehensionQuestions == null ||
            chapter.comprehensionQuestions!.isEmpty)) {
      return Text(
        'Chapter not found or Comprehension Questions unavailable',
        textAlign: language == 'Hebrew' ? TextAlign.right : TextAlign.left,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 18,
          fontFamily: 'SBLBibLit',
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    ...?chapter.comprehensionQuestions
                        ?.map((question) => buildQuestion(question, language)),
                  ],
                ),
              ),
              if (hoveredQuestion != null && tooltipPosition != null)
                Positioned(
                  top: (tooltipPosition!.dy - 175) < 0
                      ? 10
                      : (tooltipPosition!.dy - 175) >
                              (MediaQuery.of(context).size.height - 175)
                          ? MediaQuery.of(context).size.height - 185
                          : tooltipPosition!.dy - 175,
                  left: MediaQuery.of(context).size.width * .05,
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(181, 0, 0, 0),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Text(
                      hoveredQuestion!.answer,
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
      ),
    );
  }
}
