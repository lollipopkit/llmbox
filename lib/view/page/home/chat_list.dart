import 'dart:async';

import 'package:fl_lib/fl_lib.dart';
import 'package:material_ui/material_ui.dart';
import 'package:llmbox/data/res/build_data.dart';
import 'package:llmbox/data/res/l10n.dart';
import 'package:llmbox/data/store/all.dart';
import 'package:llmbox/view/page/home/share.dart';
import 'package:intl/intl.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';

/// The sidebar while chatting: the app's name and a new chat, search, the
/// chats grouped by day, and the settings at the foot.
class ChatSidebar extends StatefulWidget {
  const ChatSidebar({super.key, required this.onNewChat, required this.onOpenSettings, this.onPicked});

  final VoidCallback onNewChat;
  final VoidCallback onOpenSettings;

  /// After a chat is picked — the drawer closes itself with it.
  final VoidCallback? onPicked;

  static _ChatSidebarState? _mounted;
  static var _searchPending = false;

  /// Focuses the search field; for the keyboard shortcut. A sidebar not
  /// built yet (a drawer opening) takes it when it is.
  static void requestSearch() {
    final s = _mounted;
    if (s != null && s.mounted) {
      s._queryFocus.requestFocus();
    } else {
      _searchPending = true;
    }
  }

  @override
  State<ChatSidebar> createState() => _ChatSidebarState();
}

class _ChatSidebarState extends State<ChatSidebar> {
  final _query = TextEditingController();
  final _queryFocus = FocusNode();

  /// The chats matching the query; null while there is none.
  final _found = nvn<List<ChatMeta>>();
  Timer? _debounce;
  var _searchSeq = 0;

  @override
  void initState() {
    super.initState();
    ChatSidebar._mounted = this;
    if (ChatSidebar._searchPending) {
      ChatSidebar._searchPending = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => _queryFocus.requestFocus());
    }
    LlmStores.chat.changes.addListener(_searchSoon);
  }

  @override
  void dispose() {
    if (ChatSidebar._mounted == this) ChatSidebar._mounted = null;
    LlmStores.chat.changes.removeListener(_searchSoon);
    _debounce?.cancel();
    _query.dispose();
    _queryFocus.dispose();
    _found.dispose();
    super.dispose();
  }

  /// Searches once typing pauses; a later search wins over an earlier one.
  void _searchSoon() {
    _debounce?.cancel();
    final q = _query.text.trim();
    if (q.isEmpty) {
      _searchSeq++;
      _found.value = null;
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      final seq = ++_searchSeq;
      final res = await Chats.search(q);
      if (mounted && seq == _searchSeq) _found.value = res;
    });
  }

  void _pick(String id) {
    Chats.current.value = id;
    widget.onPicked?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(17, 3, 7, 7),
          child: Row(
            children: [
              const Expanded(child: Text(BuildData.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
              Btn.icon(
                icon: const Icon(Icons.add_comment_outlined, size: 20),
                text: l10n.newChat,
                onTap: widget.onNewChat,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11),
          child: Input(
            controller: _query,
            node: _queryFocus,
            hint: libL10n.search,
            icon: Icons.search,
            onChanged: (_) => _searchSoon(),
          ),
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: Listenable.merge([LlmStores.chat.changes, Chats.current, _found]),
            builder: (context, _) {
              final found = _found.value;
              final q = found != null;
              final chats = found ?? LlmStores.chat.all();
              if (chats.isEmpty) return Center(child: Text(libL10n.empty, style: UIs.textGrey));
              final rows = <Widget>[];
              String? group;
              for (final m in chats) {
                // Searching, the order is the match's: no day headings.
                final g = q ? null : _groupOf(m.updatedAt);
                if (g != null && g != group) {
                  rows.add(Padding(padding: const EdgeInsets.only(top: 13), child: SideBarSection(g)));
                  group = g;
                }
                rows.add(_tile(m));
              }
              return ListView(padding: const EdgeInsets.only(bottom: 13), children: rows);
            },
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(border: Border(top: BorderSide(color: Hairline.color(context)))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Llm.configured.listenVal((set) {
              return SideBarTile(
                icon: Icons.settings_outlined,
                title: libL10n.setting,
                trailing: Text(l10n.providersCountFmt(set.length), style: UIs.text12Grey),
                onTap: widget.onOpenSettings,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _tile(ChatMeta m) {
    return SideBarTile(
      title: m.title ?? l10n.untitled,
      selected: m.id == Chats.current.value,
      trailing: Padding(
        padding: const EdgeInsetsDirectional.only(start: 9, end: 3),
        child: Text(
          _timeOf(m.updatedAt),
          style: UIs.text12Grey.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
        ),
      ),
      onTap: () => _pick(m.id),
      onMenu: (at) => chatMenu(context, m, at: at),
    );
  }

  static String _groupOf(DateTime t) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (!t.isBefore(today)) return l10n.today;
    if (!t.isBefore(today.subtract(const Duration(days: 1)))) return libL10n.yesterday;
    return l10n.earlier;
  }

  /// `now`, `3 h` today; the time yesterday; the date before that.
  static String _timeOf(DateTime t) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (!t.isBefore(today)) {
      final d = now.difference(t);
      if (d.inMinutes < 1) return l10n.now;
      if (d.inHours < 1) return l10n.minutesFmt(d.inMinutes);
      return l10n.hoursFmt(d.inHours);
    }
    if (!t.isBefore(today.subtract(const Duration(days: 1)))) return DateFormat.Hm(l10n.localeName).format(t);
    return DateFormat.MMMd(l10n.localeName).format(t);
  }
}

/// What can be done to a chat: rename, share, delete — at the pointer.
Future<void> chatMenu(BuildContext context, ChatMeta m, {Offset? at}) {
  return showContextMenu(
    context,
    chatActions(context, m),
    title: m.title ?? l10n.untitled,
    at: at,
  );
}

List<ContextMenuAction> chatActions(BuildContext context, ChatMeta m) => [
      ContextMenuAction(text: l10n.rename, icon: Icons.edit_outlined, onTap: () => _rename(context, m)),
      ContextMenuAction(text: l10n.share, icon: Icons.ios_share, onTap: () => shareChat(context, m.id)),
      ContextMenuAction(
        text: libL10n.delete,
        icon: Icons.delete_outline,
        destructive: true,
        onTap: () async {
          if (Stores.setting.confrimDel.get()) {
            final ok = await context.showSheet<bool>(
              title: libL10n.delete,
              child: Text(l10n.delFmt(m.title ?? l10n.untitled, l10n.chat)),
              actions: Btnx.cancelRedOk,
            );
            if (ok != true) return;
          }
          if (Chats.current.value == m.id) Chats.current.value = null;
          await Chats.trash(m.id);
        },
      ),
    ];

Future<void> _rename(BuildContext context, ChatMeta m) async {
  final title = await context.showInputSheet(title: l10n.rename, initial: m.title);
  if (title != null && title.trim().isNotEmpty) Chats.rename(m.id, title.trim());
}
