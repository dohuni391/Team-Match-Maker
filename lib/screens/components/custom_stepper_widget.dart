import 'package:flutter/material.dart';

class CustomStepper extends StatefulWidget {
  const CustomStepper({
    Key? key,
    required this.steps,
    this.currentStep = 0,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
  })  : assert(steps != null),
        assert(currentStep != null),
        assert(0 <= currentStep && currentStep < steps.length),
        super(key: key);

  final List<Step> steps;
  final int currentStep;
  final ValueChanged<int>? onStepTapped;
  final VoidCallback? onStepContinue;
  final VoidCallback? onStepCancel;
  final ControlsWidgetBuilder? controlsBuilder;

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  Widget _buildHeader(int stepIndex) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child:
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(padding: EdgeInsets.only(bottom: 8)),
          widget.steps[stepIndex].title,
          const Padding(padding: EdgeInsets.only(bottom: 16)),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            tween: Tween<double>(
              begin: 0,
              end: stepIndex/widget.steps.length,
            ),
            builder: (context, value, _) =>
                LinearProgressIndicator(value: value),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 8)),
        ]));
  }

  Widget _buildVerticalControls(int stepIndex) {
    return widget.controlsBuilder!(
      context,
      ControlsDetails(
        currentStep: widget.currentStep,
        onStepContinue: widget.onStepContinue,
        onStepCancel: widget.onStepCancel,
        stepIndex: stepIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> stepPanels = <Widget>[];
    for (int i = 0; i < widget.steps.length; i += 1) {
      stepPanels.add(
        Visibility(
          maintainState: true,
          visible: i == widget.currentStep,
          child: widget.steps[i].content,
        ),
      );
    }

    return Column(
      children: <Widget>[
        _buildHeader(widget.currentStep),
        Expanded(
          child: ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            children: <Widget>[
              AnimatedSize(
                curve: Curves.fastOutSlowIn,
                duration: kThemeAnimationDuration,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: stepPanels),
              ),
              _buildVerticalControls(widget.currentStep),
            ],
          ),
        ),
      ],
    );
  }
}
