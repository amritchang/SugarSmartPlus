import 'package:flutter/material.dart';

class DismissKeyboardOnScroll extends StatefulWidget {
  final Widget child;
  final double scrollThreshold;

  DismissKeyboardOnScroll({
    required this.child,
    this.scrollThreshold = 100.0, // Adjust this threshold as needed
  });

  @override
  _DismissKeyboardOnScrollState createState() =>
      _DismissKeyboardOnScrollState();
}

class _DismissKeyboardOnScrollState extends State<DismissKeyboardOnScroll> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        if (_scrollController.offset > widget.scrollThreshold) {
          // Dismiss the keyboard when scroll position is below the threshold
          FocusScope.of(context).unfocus();
        }
        return false;
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        child: widget.child,
      ),
    );
  }
}
