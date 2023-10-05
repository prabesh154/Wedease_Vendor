import 'package:flutter/material.dart';
import 'package:wedeaseseller/const/const.dart';
import 'package:wedeaseseller/views/widgets/normal_text.dart';
import 'const/colors.dart';

getRowData(data, value) {
  var childrens = [];

  for (var i = 0; i < data.length; i++) {
    childrens.add(Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: normalText(
            text: data[i],
            size: 16.0,
            color: black,
          ),
        ),
        10.widthBox,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flexible(
            child: normalText(
              text: value[i],
              size: 16.0,
              color: fontGrey,
            ),
          ),
        ),
      ],
    ));
  }

  return Column(children: [...childrens]);
}
