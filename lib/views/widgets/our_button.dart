import 'package:wedeaseseller/const/const.dart';
import 'package:wedeaseseller/views/widgets/normal_text.dart';

Widget ourButton({title, color = purpleColor, onPress}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        backgroundColor: color,
        padding: const EdgeInsets.all(12.0)),
    onPressed: onPress,
    child: boldText(text: title, size: 16.0),
  );
}
