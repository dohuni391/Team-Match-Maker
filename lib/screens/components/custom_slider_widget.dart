import 'package:flutter/material.dart';
import 'package:team_maker/style.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({
    Key? key,
    required this.name,
    required this.min,
    required this.max,
    this.divisions,
    required this.value,
    this.showValue = false,
    this.displayValue = "",
    required this.onChanged,
  }) : super(key: key);

  final String name;
  final double min;
  final double max;
  final int? divisions;
  final double value;
  final bool showValue;
  final String displayValue;
  final onChanged;

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('${widget.name}: ', style: smallTextStyle),
            Visibility(visible: widget.showValue, child: Text(widget.displayValue, style: mediumTextStyle))
          ],
        ),
        const Padding(padding: EdgeInsets.only(bottom: 2)),
        Slider(
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          value: widget.value,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}