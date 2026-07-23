import 'dart:async';
import 'package:flutter/material.dart';
import '../router/app_router.dart';

enum ToastType { error, restriction, success, info }

class AppToast {
  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  static void show(
    BuildContext? context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(milliseconds: 3500),
  }) {
    _dismissTimer?.cancel();
    _currentEntry?.remove();
    _currentEntry = null;

    OverlayState? overlay;
    if (context != null && context.mounted) {
      try {
        overlay = Navigator.of(context, rootNavigator: true).overlay;
      } catch (_) {
        overlay = rootNavigatorKey.currentState?.overlay;
      }
    } else {
      overlay = rootNavigatorKey.currentState?.overlay;
    }

    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (overlayContext) => _ToastOverlayWidget(
        message: message,
        type: type,
        onDismiss: () {
          _dismissCurrent();
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);

    _dismissTimer = Timer(duration, () {
      _dismissCurrent();
    });
  }

  static void showError(BuildContext context, String message) {
    show(context, message: message, type: ToastType.error);
  }

  static void showRestriction(BuildContext context, String message) {
    show(context, message: message, type: ToastType.restriction);
  }

  static void showSuccess(BuildContext context, String message) {
    show(context, message: message, type: ToastType.success);
  }

  static void showInfo(BuildContext context, String message) {
    show(context, message: message, type: ToastType.info);
  }

  static void _dismissCurrent() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    if (_currentEntry != null) {
      _currentEntry?.remove();
      _currentEntry = null;
    }
  }
}

class _ToastOverlayWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;

  const _ToastOverlayWidget({
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  @override
  State<_ToastOverlayWidget> createState() => _ToastOverlayWidgetState();
}

class _ToastOverlayWidgetState extends State<_ToastOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  Future<void> _handleDismiss() async {
    if (_controller.isAnimating || _controller.isDismissed) return;
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final bottomSafeArea = mediaQuery.padding.bottom;
    final bottomPadding = bottomInset > 0 ? bottomInset + 12 : bottomSafeArea + 16;

    final theme = Theme.of(context);
    final (iconData, iconColor, borderColor, bgColor) = switch (widget.type) {
      ToastType.error => (
          Icons.error_outline_rounded,
          const Color(0xFFF87171),
          const Color(0xFF991B1B).withValues(alpha: 0.5),
          const Color(0xFF1E1B1E),
        ),
      ToastType.restriction => (
          Icons.warning_amber_rounded,
          const Color(0xFFFBBF24),
          const Color(0xFF92400E).withValues(alpha: 0.5),
          const Color(0xFF1E1C1A),
        ),
      ToastType.success => (
          Icons.check_circle_outline_rounded,
          const Color(0xFF34D399),
          const Color(0xFF065F46).withValues(alpha: 0.5),
          const Color(0xFF1A1E1C),
        ),
      ToastType.info => (
          Icons.info_outline_rounded,
          theme.colorScheme.primary,
          theme.colorScheme.primary.withValues(alpha: 0.3),
          const Color(0xFF1B1E24),
        ),
    };

    return Positioned(
      left: 16,
      right: 16,
      bottom: bottomPadding,
      child: Material(
        type: MaterialType.transparency,
        child: SlideTransition(
          position: _offsetAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity != null && details.primaryVelocity! > 100) {
                  _handleDismiss();
                }
              },
              onTap: _handleDismiss,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: bgColor.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        iconData,
                        color: iconColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: _handleDismiss,
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white54,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
