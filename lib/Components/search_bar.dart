import 'package:flutter/material.dart';
import 'package:dynet_controls_v2/constants.dart';

class SearchBar extends StatefulWidget {
  SearchBar({
    required this.onChanged,
    required this.text,
    this.hintText,
    this.expandSearchBar,
    this.expandSearchChild,
    this.leadingChild,
    this.trailingChild,
  });

  final ValueChanged<String> onChanged;
  final String? hintText;
  final String text;
  final bool? expandSearchBar;
  final Widget? expandSearchChild;
  final Widget? leadingChild;
  final Widget? trailingChild;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: widget.expandSearchBar! ? 82 : 55,
      child: Material(
        color: kBackgroundColour,
        elevation: 10,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (widget.leadingChild != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            backgroundColor: kCardColour,
                            radius: 17.5,
                            child: FittedBox(
                              child: widget.leadingChild,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Container(
                          height: 35,
                          child: TextField(
                            style: kPresetButtonStyle,
                            cursorColor: kItemColour,
                            decoration: kSearchBarDecoration.copyWith(
                              hintText: widget.hintText,
                              suffixIcon: widget.text.isNotEmpty
                                  ? GestureDetector(
                                      child: const Icon(Icons.close,
                                          color: Colors.white30),
                                      onTap: () {
                                        controller.clear();
                                        widget.onChanged('');
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      },
                                    )
                                  : null,
                            ),
                            controller: controller,
                            onChanged: widget.onChanged,
                          ),
                        ),
                      ),
                      if (widget.trailingChild != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: CircleAvatar(
                            backgroundColor: kCardColour,
                            radius: 17.5,
                            child: FittedBox(
                              child: widget.trailingChild,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (widget.expandSearchBar!)
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: widget.expandSearchChild,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
