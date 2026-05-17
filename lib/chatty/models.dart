import 'package:equatable/equatable.dart';

enum ChattyItemSource { user, assistant }

enum ChattyQuestionType { none, text, int, email, date, singleChoice }

class ChattyAnswer extends Equatable {
  final String value;
  final String content;
  const ChattyAnswer({required this.value, required this.content});
  @override
  List<Object?> get props => [value, content];
}

class ChattyQuestion extends Equatable {
  final ChattyQuestionType type;
  final String? min;
  final String? max;
  final List<ChattyAnswer>? answers;

  const ChattyQuestion({
    required this.type,
    this.min,
    this.max,
    this.answers,
  }); // Only of type is singleChoice

  @override
  List<Object?> get props => [type, min, max, answers];
}

class ChattyItem extends Equatable {
  /// Can contain the following HTML tags: p, b, strong, i, em.
  /// If this is a question, it contains the question content.
  final String content;
  final ChattyItemSource source;
  final ChattyQuestion? question;

  /// If set, this is always an error.
  /// If this is not a question, then the content will contain the same string.
  final String? error;
  final DateTime createdAt;

  const ChattyItem({
    required this.content,
    required this.source,
    this.question,
    this.error,
    required this.createdAt,
  });

  factory ChattyItem.fromUser(String content) {
    return ChattyItem(
      content: content,
      source: ChattyItemSource.user,
      createdAt: DateTime.now(),
    );
  }

  factory ChattyItem.fromAssistant(String content, {ChattyQuestion? question}) {
    return ChattyItem(
      content: content,
      source: ChattyItemSource.assistant,
      createdAt: DateTime.now(),
      question: question,
    );
  }

  ChattyItem copyWith({
    String? content,
    bool removeQuestion = false,
    String? error,
  }) {
    return ChattyItem(
      content: content ?? this.content,
      source: source,
      error: error ?? this.error,
      question: removeQuestion ? null : question,
      createdAt: createdAt,
    );
  }

  String getMainContent() {
    return question != null ? content : (error ?? content);
  }

  @override
  List<Object?> get props => [content, source, question, error, createdAt];
}
