import 'package:chatty/chatty/chatty_widget.dart';
import 'package:chatty/chatty/models.dart';
import 'package:flutter/material.dart';

final List<ChattyItem> myItems = [
  ChattyItem.fromAssistant(
    'Hi, I am <b><i>the</i> assistant</b>!',
    createdAt: DateTime(2026, 5, 15, 9, 30),
  ),
  ChattyItem.fromAssistant(
    'Whats your <b>name</b>?',
    createdAt: DateTime(2026, 5, 15, 10, 30),
    question: ChattyQuestion(type: ChattyQuestionType.text),
  ),
  ChattyItem.fromAssistant(
    'Whats your <b>age</b>?',
    createdAt: DateTime(2026, 5, 15, 10, 30),
    question: ChattyQuestion(
      type: ChattyQuestionType.int,
      min: '18',
      max: '100',
    ),
  ),
  ChattyItem.fromAssistant(
    'Date?',
    createdAt: DateTime(2026, 5, 16, 12, 30),
    question: ChattyQuestion(type: ChattyQuestionType.date, min: '2000-01-01'),
  ),
  ChattyItem.fromAssistant(
    'Gender?',
    question: ChattyQuestion(
      type: ChattyQuestionType.singleChoice,
      answers: [
        ChattyAnswer(value: 'male', content: 'Male'),
        ChattyAnswer(value: 'female', content: 'Female'),
      ],
    ),
  ),
];

final List<ChattyItem> initialItems = [
  //ChattyItem.fromDateSeparator(DateTime(2026, 5, 10)),
  ChattyItem.fromAssistant(
    'Hoi ik ben de assistent! Wat kan ik voor je doen?',
    createdAt: DateTime(2026, 5, 10, 9, 45),
  ),
  ChattyItem.fromUser('Wie ben jij?', createdAt: DateTime(2026, 5, 10, 10, 45)),
  ChattyItem.fromAssistant(
    'Dat zeg ik net: ik ben de assistent!',
    createdAt: DateTime(2026, 5, 10, 11, 45),
    documents: [
      ChattyDocument(
        uri: 'https://www.nu.nl',
        type: ChattyDocumentType.url,
        title: 'Test 123',
      ),
    ],
  ),
  //ChattyItem.fromDateSeparator(DateTime(2026, 5, 11)),
  ChattyItem.fromUser('Wat kun jij?', createdAt: DateTime(2026, 5, 11, 8, 15)),
  ChattyItem.fromAssistant(
    'Teveel om op te noemen...',
    createdAt: DateTime(2026, 5, 11, 8, 46),
  ),
];

var assistantItemIndex = -1;
var errorIsHandled = false;

/// Function needs to be implemented by caller. For example send to backend.
Future<ChattyItem> onPrompt(String prompt, {String? value}) async {
  await Future.delayed(Duration(milliseconds: 1000));

  if (assistantItemIndex == 2 && !errorIsHandled) {
    // Make exception
    errorIsHandled = true;
    final msg = myItems[assistantItemIndex];
    return msg.copyWith(
      error: 'Dit is niet het goede antwoord! Probeer het opnieuw!',
    );
  }

  // Net doen alsof we een exception krijgen vanuit de backend.
  // Nu 2 opties: als dit GEEN vraag was, dan gewoon error tonen als assistant message
  // Maar als dit antwoord op vraag is, dan Dezezelfde vraag nogmaals tonen, maar dan met deze error erbij gezet.

  assistantItemIndex += 1;
  if (assistantItemIndex < myItems.length) {
    final msg = myItems[assistantItemIndex];
    return msg.copyWith(
      content:
          'received prompt $prompt and value ${value ?? '-'} and new message is ${msg.content}',
    );
  } else {
    return ChattyItem.fromAssistant('I have no more answers for you...');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: SafeArea(
          minimum: EdgeInsets.all(20),
          child: ChattyWidget(
            promptPlaceHolder: 'Ask your question...',
            onPrompt: onPrompt,
            withDateSeparator: true,
            withDocuments: true,
            onDocumentClicked: (p0) {
              print(p0);
            },
            initialItems: initialItems.reversed.toList(),
          ),
        ),
      ),
    );
  }
}
