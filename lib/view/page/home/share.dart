import 'package:fl_lib/fl_lib.dart';
import 'package:material_ui/material_ui.dart';
import 'package:llmbox/data/res/build_data.dart';
import 'package:llmbox/data/res/l10n.dart';
import 'package:screenshot/screenshot.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';

final _screenshot = ScreenshotController();

/// Shares the chat's current branch as an image or as markdown.
Future<void> shareChat(BuildContext context, String chatId) async {
  final type = await context.showPickSingleSheet(
    title: l10n.share,
    items: const ['img', 'md'],
    display: (p0) => p0 == 'md' ? l10n.text : l10n.image,
  );
  if (type == null || !context.mounted) return;

  final title = LlmStores.chat.fetch(chatId)?.title ?? l10n.untitled;
  await Chats.borrow(chatId, (chat) async {
    if (type == 'md') {
      await Pfs.shareStr('# $title\n\n${Chats.toMarkdown(chat.entries.value)}', title: title);
      return;
    }
    if (!context.mounted) return;
    final widget = InheritedTheme.captureAll(
      context,
      Material(
        color: context.theme.scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 17),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
              for (final b in threadBlocks(chat.entries.value))
                ThreadBlockView(chat: null, block: b, forCapture: true),
              Text(
                '${l10n.shareFrom} ${BuildData.name} v1.0.${BuildData.build}',
                textAlign: TextAlign.center,
                style: UIs.text12Grey,
              ),
            ].joinWith(const SizedBox(height: 20)),
          ),
        ),
      ),
    );
    final (pic, err) = await context.showLoadingSheet(
      fn: () => _screenshot.captureFromLongWidget(
        widget,
        context: context,
        constraints: const BoxConstraints(maxWidth: 600),
        pixelRatio: MediaQuery.devicePixelRatioOf(context),
        delay: Durations.short4,
      ),
    );
    if (err != null || pic == null) return;
    await Pfs.shareBytes(bytes: pic, title: title, fileName: '$title.png', mime: 'image/png');
  });
}
