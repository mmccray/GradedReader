// book_models.dart
class BookDetail {
  final String id;
  final String slug;
  final String title;
  final String author;
  final String language;
  final String description;

  BookDetail({
    required this.id,
    required this.slug,
    required this.title,
    required this.author,
    required this.language,
    required this.description,
  });

  factory BookDetail.fromJson(Map<String, dynamic> json) {
    return BookDetail(
      id: json['id'],
      slug: json['slug'],
      title: json['title'],
      author: json['author'],
      language: json['language'],
      description: json['description'],
    );
  }
}

class Book {
  final String id;
  final String title;
  final String author;
  final String language;
  final String description;
  final List<Chapter> chapters;
  final String slug;
  
  Book({required this.id, required this.title, required this.slug, required this.author, required this.language, required this.description, required this.chapters});
  
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['slug'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      author: json['author'] ?? '',
      language: json['language'] ?? '',
      description: json['description'] ?? '',
      chapters: (json['chapters'] as List)
          .map((chapter) => Chapter.fromJson(chapter))
          .toList(),
    );
  }
}

class Chapter {
  final String slug;
  final String displayTitle;
  final String glossTitle;
  final List<Paragraph> content;
  final String? titleImage;
  final List<Vocab>? vocab;
  final List<ComprehensionQuestions>? comprehensionQuestions;
  
  Chapter({required this.slug, required this.displayTitle, required this.glossTitle, required this.content, this.titleImage, this.vocab, this.comprehensionQuestions});
  
  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      slug: json['slug'] ?? '',
      displayTitle: json['title']['display'] ?? '',
      glossTitle: json['title']['gloss'] ?? '',
      content: (json['content'] as List)
          .map((para) => Paragraph.fromJson(para))
          .toList(),
      titleImage: json['titleImage'],
      vocab: (json['vocab'] as List<dynamic>? ?? []).map((vocab) => Vocab.fromJson(vocab)).toList(),
      comprehensionQuestions: (json['questions'] as List<dynamic>? ?? []).map((questions) => ComprehensionQuestions.fromJson(questions)).toList(),
    );
  }
}

class Vocab {
  final String? image;
  final String word;
  final String gloss;

  Vocab({this.image, required this.word, required this.gloss});

  factory Vocab.fromJson(Map<String, dynamic> json) {
    return Vocab(
      image: json['image'],
      word: json['word'],
      gloss: json['gloss']
    );
  }
}

class ComprehensionQuestions {
  final String question;
  final String answer;

  ComprehensionQuestions({required this.question, required this.answer});

  factory ComprehensionQuestions.fromJson(Map<String, dynamic> json) {
    return ComprehensionQuestions(
      question: json['question'],
      answer: json['answer']
    );
  }
}

class Paragraph {
  final List<Verse> paragraph;
  final String? imageAsset; // Optional image asset path
  final String? subTitle;
  
  Paragraph({required this.paragraph, this.imageAsset, this.subTitle});
  
  factory Paragraph.fromJson(Map<String, dynamic> json) {
    return Paragraph(
      paragraph: (json['paragraph'] as List)
          .map((verse) => Verse.fromJson(verse))
          .toList(),
      imageAsset: json['image'],
      subTitle: json['subtitle']
    );
  }
}

class Verse {
  final int verseId;
  final List<Word> words;
  
  Verse({required this.verseId, required this.words});
  
  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      verseId: json['verse_id'] ?? 0,
      words: (json['words'] as List)
          .map((word) => Word.fromJson(word))
          .toList(),
    );
  }
}

class Word {
  final String word;
  final String gloss;
  
  Word({required this.word, required this.gloss});
  
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'] ?? '',
      gloss: json['gloss'] ?? '',
    );
  }
}