import 'package:flutter/material.dart';
import 'package:team_maker/screens/components/components.dart';
import 'package:team_maker/style.dart';

class PlayerAddBottomSheet extends StatefulWidget {
  const PlayerAddBottomSheet({Key? key, required this.onSave, this.isEdit = false, this.initName = '', this.initRating = 5}) : super(key: key);

  final void Function(String name, double rating) onSave;
  final bool isEdit;
  final String initName;
  final int initRating;

  @override
  State<PlayerAddBottomSheet> createState() => _PlayerAddBottomSheetState();
}

class _PlayerAddBottomSheetState extends State<PlayerAddBottomSheet> {

  final formKey = GlobalKey<FormState>();
  final shakeKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  late double rating;

  @override
  void initState() {
    nameController.text = widget.initName;
    rating = widget.initRating.roundToDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(bottom: 8)),

            !widget.isEdit ? const Text('Add New Player', style: mediumTitleTextStyle) : const Text('Edit Player', style: mediumTitleTextStyle),
            const Padding(padding: EdgeInsets.only(bottom: 24)),

            CustomTextField(
              name: 'Name',
              formKey: formKey,
              controller: nameController,
              hintText: 'Enter Player Name...',
              validator: (value) {
                if (value == null || value.isEmpty){
                  return 'Enter player name';
                }
                return null;
              },
            ),
            const Padding(padding: EdgeInsets.only(bottom: 24)),

            CustomSlider(
              name: 'Rating',
              min: 1,
              max: 100,
              value: rating,
              displayValue: rating.round().toString(),
              onChanged: (newValue){setState(() {rating = newValue;});},
              showValue: true,
            ),
            const Spacer(),

            Center(
              child: CustomTextButton(
                text: 'Save',
                onPressed: (){
                  if(formKey.currentState!.validate()) {
                    widget.onSave(nameController.value.text, rating);
                  }
                },
              )
            )
          ],
        ),
      ),
    );
  }
}
