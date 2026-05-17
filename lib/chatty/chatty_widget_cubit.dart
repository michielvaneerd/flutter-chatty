import 'package:chatty/chatty/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ChattyWidgetState contains the state for the ChattyWidget
class ChattyWidgetState extends Equatable {
  final bool busy;

  /// This error is only for errors that are not displayed as assistant messages.
  final String? error;
  final List<ChattyItem> items;

  const ChattyWidgetState({this.busy = false, this.error, required this.items});
  @override
  List<Object?> get props => [busy, error, items];

  ChattyWidgetState copyWith({
    List<ChattyItem>? items,
    bool busy = false,
    String? error,
    bool removeError = true,
  }) {
    return ChattyWidgetState(
      items: items ?? this.items,
      busy: busy,
      error: removeError ? null : (error ?? this.error),
    );
  }
}

class ChattyWidgetCubit extends Cubit<ChattyWidgetState> {
  ChattyWidgetCubit({required this.onPrompt, this.initialItems})
    : super(ChattyWidgetState(items: initialItems ?? []));
  final Future<ChattyItem> Function(String content, {String? value}) onPrompt;
  final List<ChattyItem>? initialItems;

  /// Handle new user prompt
  void prompt(String prompt, {String? value}) async {
    List<ChattyItem> newItems = List.from(state.items);

    if (state.items.isNotEmpty && state.items.first.question != null) {
      // This is an answer to this question. We remove the question from this item, so then it will be a normal assistant message without answering options anymore.
      newItems[0] = newItems.first.copyWith(removeQuestion: true);
    }

    // Add the user answer to the items
    newItems.insert(0, ChattyItem.fromUser(prompt));

    emit(state.copyWith(busy: true, items: newItems));

    final response = await onPrompt(prompt, value: value);

    emit(state.copyWith(items: List.from(state.items)..insert(0, response)));
  }
}
