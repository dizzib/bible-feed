import 'package:flutter/material.dart';

// known issues with various wheel pickers...
//
// - selector_wheel (https://github.com/AlexLomm/selector_wheel)
//    - non standard grab behaviour (see https://github.com/AlexLomm/selector_wheel/issues/2)
//    - poor performance on Moto E5 plus
//
// - wheel_picker (https://pub.dev/packages/wheel_picker)
//    - does not seem to rebuild as expected
//    - cannot set the width (https://github.com/stavgafny/wheel_picker/issues/4)
//
class ListWheel extends StatefulWidget {
  const ListWheel({
    super.key,
    required this.constraints,
    required this.count,
    required this.convertIndexToValue,
    required this.getSelectedItemIndex,
    required this.onSelectedItemChanged,
  });

  final BoxConstraints constraints;
  final int count;
  final String Function(int index) convertIndexToValue;
  final int Function() getSelectedItemIndex;
  final void Function(int index) onSelectedItemChanged;

  // final _ListWheelState appState = new _ListWheelState();
  // void selectItem(int index) {
  //   ._controller.jumpToItem(index);
  //   // WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // _ListWheelState()._controller.jumpToItem(index);
  //   // }
  // }

  @override
  State<ListWheel> createState() => _ListWheelState();
}

class _ListWheelState extends State<ListWheel> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: widget.getSelectedItemIndex());
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: (widget.constraints.maxWidth < 200 || widget.constraints.maxHeight < 200) ? 16 : 24, // accomodate small displays
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,  // without this, large text wraps and disappears
    );

    // print('---');
    // print(widget.getSelectedItemIndex());
    // print(widget.count);
    // if (widget.getSelectedItemIndex() >= widget.count) {
    //   print('ERROR');
    // }

    // workaround bug in ListWheelScrollView where changing textStyle.fontSize -> itemExtent
    // renders badly. In this case let's jumpToItem on next frame
    // Widget workaroundItemExtentBug({
    //   required void Function(Duration) postFrameCallback,
    //   required ListWheelScrollView child
    // }) {
    //   return NotificationListener(
    //     onNotification: (SizeChangedLayoutNotification notification) {
    //       WidgetsBinding.instance.addPostFrameCallback(postFrameCallback);
    //       return true;  // cancel bubbling
    //     },
    //     child: SizeChangedLayoutNotifier(child: child)
    //   );
    // }

    return ListWheelScrollView.useDelegate(
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (BuildContext _, int index) {
          if (index < 0 || index >= widget.count) return null;
          return Text(widget.convertIndexToValue(index), style: textStyle);
        },
      ),
      controller: _controller,
      diameterRatio: 1.3,
      itemExtent: textStyle.fontSize! * 1.4 * MediaQuery.of(context).textScaler.scale(1),  // text size in device settings
      magnification: 1.1,
      onSelectedItemChanged: widget.onSelectedItemChanged,
      overAndUnderCenterOpacity: 0.5,
      physics: const FixedExtentScrollPhysics(),
      useMagnifier: true,
    );
  }
}
