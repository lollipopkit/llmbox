import 'package:animations/animations.dart';
import 'package:material_ui/material_ui.dart';

/// Swaps its [child] with Material's fade through: for content that is
/// replaced by something unrelated in the same place — another chat, another
/// settings page. Key the child by what it shows.
class FadeThroughSwitcher extends StatelessWidget {
  const FadeThroughSwitcher({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: MediaQuery.disableAnimationsOf(context) ? Durations.short2 : Durations.medium2,
      transitionBuilder: (child, anim, secondary) => FadeThroughTransition(
        animation: anim,
        secondaryAnimation: secondary,
        fillColor: Colors.transparent,
        child: child,
      ),
      child: child,
    );
  }
}

/// Swaps its [child] the way Material pushes a page: the new one slides in
/// from the right as the old one slides away left, and [reverse] pops. For
/// going one level in within a pane, where a route would take the whole
/// window.
class PushSwitcher extends StatelessWidget {
  const PushSwitcher({super.key, required this.child, this.reverse = false});

  final Widget child;
  final bool reverse;

  // No ground of its own: the pane's shows through, as it does around it.
  static const _push = FadeForwardsPageTransitionsBuilder(backgroundColor: Colors.transparent);

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      reverse: reverse,
      duration: MediaQuery.disableAnimationsOf(context) ? Durations.short2 : _push.transitionDuration,
      transitionBuilder: (child, anim, secondary) => _push.buildTransitions<void>(null, context, anim, secondary, child),
      child: child,
    );
  }
}
