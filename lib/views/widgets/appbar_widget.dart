import 'package:intl/intl.dart' as intl;
import 'package:wedeaseseller/const/const.dart';
import 'package:wedeaseseller/views/widgets/normal_text.dart';

AppBar appbarWidget(title) {
  return AppBar(
    backgroundColor: white,
    automaticallyImplyLeading: false,
    
    title: boldText(text: title, color: darkGrey, size: 20.0),
    actions: [
      Center(
        child: normalText(
            text: intl.DateFormat('EEE,MMM d, ' 'yyyy').format(DateTime.now()),
            color: purpleColor),
      ),
      10.widthBox,
    ],
  );
}
