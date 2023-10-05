import 'package:wedeaseseller/const/const.dart';
import 'package:wedeaseseller/controllers/services_controllers.dart';
import 'package:wedeaseseller/views/widgets/normal_text.dart';

Widget serviceCategoryDropdown(
  hint,
  List<String> list,
  dropvalue,
  ServicesController controller,
  bool isEnabled,
  // Add isEnabled parameter
) {
  return Obx(
    () => DropdownButtonHideUnderline(
      child: DropdownButton(
        hint: normalText(text: "$hint", color: fontGrey),
        value: dropvalue.value == '' ? null : dropvalue.value,
        isExpanded: true,
        items: list.map((e) {
          return DropdownMenuItem(
            value: e,
            child: e.toString().text.make(),
          );
        }).toList(),
        onChanged: isEnabled
            ? (newValue) {
                if (hint == "Category") {
                  controller.subcategoryvalue.value = '';

                  controller.populateSubcategory(newValue.toString());
                }
                dropvalue.value = newValue.toString();
              }
            : null, // Use isEnabled to conditionally set onChanged to null
      ),
    )
        .box
        .color(purpleColor.withOpacity(0.8))
        .padding(const EdgeInsets.symmetric(horizontal: 4))
        .roundedSM
        .make(),
  );
}
