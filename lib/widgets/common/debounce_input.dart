import 'dart:async';

import 'package:flutter/material.dart';

class DebounceInput extends StatefulWidget {
  final Function(String inputText) onInputChange;
  final int debounceMs;
  final InputDecoration inputDecoration;

  DebounceInput({
    @required this.onInputChange,
    @required this.inputDecoration,
    this.debounceMs = 500,
  });

  @override
  _DebounceInputState createState() => _DebounceInputState();
}

class _DebounceInputState extends State<DebounceInput> {
  final _inputController = TextEditingController();
  Timer _debounce;
  
  @override
  void initState() {
    super.initState();
    _inputController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _inputController.removeListener(_onInputChanged);
    _inputController.dispose();
    _debounce.cancel();
    super.dispose();
  }

  _onInputChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(
        Duration(milliseconds: widget.debounceMs),
        () => widget.onInputChange(_inputController.text)
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: _inputController,
        decoration: widget.inputDecoration,
      );
  }
}