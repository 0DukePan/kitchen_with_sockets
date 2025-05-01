import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  final String? prefix;
  final String? title;
  EntryField(this.prefix, this.title);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          prefixIcon: prefix != null
              ? Container(
                  height: 15,
                  width: 15,
                  child: Center(
                      child: Text(
                    prefix??'',
                    textAlign: TextAlign.center,
                  )))
              : SizedBox.shrink(),
          prefixStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.black),
          border: InputBorder.none,
          hintText: title,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.grey)),
    );
  }
}
