import 'package:chatty/chatty/chatty_rich_text.dart';
import 'package:chatty/chatty/chatty_widget_cubit.dart';
import 'package:chatty/chatty/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChattyItemWidget extends StatelessWidget {
  const ChattyItemWidget({super.key, required this.item, this.extraWidget});
  final ChattyItem item;
  final Widget? extraWidget;

  static final dateFormat = DateFormat('y-MM-dd');

  static const _customInputQuestionTypes = [
    ChattyQuestionType.date,
    ChattyQuestionType.singleChoice,
  ];

  static bool hasCustomInput(ChattyQuestionType type) {
    return _customInputQuestionTypes.contains(type);
  }

  List<Widget> getAnswers(BuildContext context) {
    if (item.question == null) {
      return [];
    }
    switch (item.question!.type) {
      case ChattyQuestionType.date:
        return [
          FilledButton(
            onPressed: () async {
              final minDate = item.question?.min != null
                  ? dateFormat.parse(item.question!.min!)
                  : DateTime.now();
              final maxDate = item.question?.max != null
                  ? dateFormat.parse(item.question!.max!)
                  : DateTime.now();

              final date = await showDatePicker(
                context: context,
                firstDate: minDate,
                lastDate: maxDate,
              );

              if (date != null && context.mounted) {
                BlocProvider.of<ChattyWidgetCubit>(context).prompt(
                  DateFormat.yMd().format(date),
                  value: dateFormat.format(date),
                );
              }
            },
            child: Text('Enter date'),
          ),
        ];
      case ChattyQuestionType.singleChoice:
        return item.question!.answers!
            .map(
              (e) => FilledButton(
                onPressed: () {
                  BlocProvider.of<ChattyWidgetCubit>(
                    context,
                  ).prompt(e.content, value: e.value);
                },
                child: Text(e.content),
              ),
            )
            .toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainText = item.getMainContent();
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10,
        left: item.source == ChattyItemSource.assistant ? 10 : 40,
        right: item.source == ChattyItemSource.user ? 10 : 40,
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: item.error == null ? Colors.black : Colors.red,
            width: 1,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            bottomRight: item.source == ChattyItemSource.assistant
                ? Radius.circular(10)
                : Radius.zero,
            bottomLeft: item.source == ChattyItemSource.user
                ? Radius.circular(10)
                : Radius.zero,
          ),
          color: item.source == ChattyItemSource.assistant
              ? Colors.limeAccent
              : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mainText.isNotEmpty) ChattyRichText(text: mainText),
            ...getAnswers(context),
            ?extraWidget,
            if (item.error != null)
              Text(
                item.error!,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
