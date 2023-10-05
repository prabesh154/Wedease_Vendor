import 'package:wedeaseseller/const/const.dart';
import 'package:wedeaseseller/views/widgets/normal_text.dart';

Widget customTextField(
    {label,
    hint,
    controller,
    isDesc = false,
    obscureText,
    onChanged,
    initialValue}) {
  return TextFormField(
    style: const TextStyle(color: black),
    maxLines: isDesc ? 4 : 1,
    controller: controller,
    onChanged: onChanged,
    initialValue: initialValue,
    decoration: InputDecoration(
        isDense: true,
        // label: normalText(text: label, color: black),
        // enabledBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(12),
        //     borderSide: const BorderSide(
        //       color: black,
        //     )),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: fontGrey,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: black,
            )),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38)),
  );
}
