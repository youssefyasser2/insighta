import 'package:flutter/material.dart';

class StayConnectedCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const StayConnectedCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        const Text("Stay connected", style: TextStyle(color: Colors.black54)),
      ],
    );
  }
}
