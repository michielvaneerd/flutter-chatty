import 'package:chatty/chatty/chatty_animated_dots.dart';
import 'package:chatty/chatty/chatty_item_widget.dart';
import 'package:chatty/chatty/chatty_widget_cubit.dart';
import 'package:chatty/chatty/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ChattyWidget is the main widget that contains the chat items and the textfield for the prompt.
class ChattyWidget extends StatefulWidget {
  const ChattyWidget({
    super.key,
    required this.onPrompt,
    this.initialItems,
    this.withDateSeparator = false,
  });

  static const paddingDefault = 12.0;
  static const paddingSmall = 6.0;
  static const paddingBig = 24.0;
  static const borderRadiusDefault = 18.0;

  /// Handle new user prompt: send this prompt to the LLM api and
  /// return the response as a ChattyItem - this is up to the caller.
  final Future<ChattyItem> Function(String prompt, {String? value}) onPrompt;
  final List<ChattyItem>? initialItems;
  final bool withDateSeparator;

  @override
  State<ChattyWidget> createState() => _ChattyWidgetState();
}

class _ChattyWidgetState extends State<ChattyWidget> {
  final promptController = TextEditingController();

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChattyWidgetCubit>(
      create: (context) => ChattyWidgetCubit(
        onPrompt: widget.onPrompt,
        initialItems: widget.initialItems,
      ),
      child: BlocConsumer<ChattyWidgetCubit, ChattyWidgetState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = BlocProvider.of<ChattyWidgetCubit>(context);
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    return ChattyItemWidget(
                      item: state.items[index],
                      extraWidget: index == 0 && state.busy
                          ? ChattyAnimatedDots()
                          : null,
                    );
                  },
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed:
                        state.busy ||
                            (state.items.isNotEmpty &&
                                state.items.first.question != null &&
                                ChattyItemWidget.hasCustomInput(
                                  state.items.first.question!.type,
                                ))
                        ? null
                        : () {
                            cubit.prompt(promptController.text);
                            promptController.clear();
                          },
                    icon: Icon(Icons.arrow_forward_ios),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      ChattyWidget.borderRadiusDefault,
                    ),
                  ),
                ),
                controller: promptController,
              ),
            ],
          );
        },
      ),
    );
  }
}
