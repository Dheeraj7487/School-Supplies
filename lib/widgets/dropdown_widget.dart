import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../utils/app_color.dart';

Widget appDropDown({required String? value,
  required String? hint,
  required void Function(String?)? onChanged,
  required List<String> items
})
{
  return DropdownButtonFormField2(
    iconDisabledColor: Colors.grey,
    buttonHeight: 55,
    buttonPadding: const EdgeInsets.only(left: 14, right: 14),
    buttonDecoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.black12.withOpacity(0.1),
    ),
    itemHeight: 40,
    dropdownMaxHeight: 200,
    itemPadding: null,
    dropdownDecoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: AppColor.appColor,
    ),
    scrollbarRadius: const Radius.circular(40),
    scrollbarAlwaysShow: true,
    decoration: const InputDecoration(
        border: UnderlineInputBorder(borderSide: BorderSide.none),
      contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
    ),
    value: value,
    validator: (value) {
      if (value == null) {
        return 'This field is required';
      }
      return null;
    },
    hint: Text(hint!, style:  const TextStyle(fontSize: 12, color: AppColor.whiteColor)),
    isExpanded: true,
    isDense: true,
    iconOnClick: const Icon(Icons.arrow_drop_up,color: AppColor.whiteColor),
    icon: const Icon(Icons.arrow_drop_down, color: AppColor.whiteColor),
    onChanged: onChanged,
    items: items.map<DropdownMenuItem<String>>((String className) {
      return DropdownMenuItem<String>(
          value: className,
          child: Row(
            children: [
              Text(
                className,
                style: const TextStyle(color: AppColor.whiteColor),
              )
            ],
          ));
    }).toList(),
  );
}
