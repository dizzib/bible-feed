import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view/wheel_state.dart';

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
class ListWheel<T> extends StatelessWidget {
  const ListWheel({
    super.key,
    required this.count,
    required this.indexToItem,
    required this.itemToString,
    required this.textStyle,
  });

  final int count;
  final T Function(int index) indexToItem;
  final String Function(T item) itemToString;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    var itemExtent = textStyle.fontSize! * 1.4 * mq.textScaler.scale(1);  // accomodate text size from device settings
    var isDarkMode = mq.platformBrightness == Brightness.dark;
    var wheelState = Provider.of<WheelState<T>>(context, listen:false);
    var controller = FixedExtentScrollController(initialItem: wheelState.index);

    Widget highlight() =>
      Align(
        alignment: Alignment.center,
        child: Container(
          height: itemExtent,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.red : Colors.orange[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
        )
      );

    // workaround bug in ListWheelScrollView where a changing textStyle.fontSize -> itemExtent
    // renders badly. In this case jumpToItem on next frame
    Widget workaroundItemExtentBug(Widget child) {
      return NotificationListener(
        onNotification: (SizeChangedLayoutNotification notification) {
          WidgetsBinding.instance.addPostFrameCallback((_) => controller.jumpToItem(wheelState.index));
          return true;  // cancel bubbling
        },
        child: SizeChangedLayoutNotifier(child: child)
      );
    }

    // always keep index and item in sync
    void setWheelState(int index) {
      wheelState.index = index;
      wheelState.item = indexToItem(index);
    }

    // guard against selected index exceeding count - 1
    if (wheelState.index >= count) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.jumpToItem(0);  // bugfix: without this, ListWheelScrollView sometimes partially renders
        controller.jumpToItem(count - 1);
        setWheelState(count - 1);
      });
    }

    return Stack(
      children: [
        highlight(),
        workaroundItemExtentBug(
          ListWheelScrollView.useDelegate(
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (BuildContext _, int index) {
                // print(count);
                if (index < 0 || index >= count) return null;
                return Text(itemToString(indexToItem(index)), style: textStyle);
              },
            ),
            controller: controller,
            diameterRatio: 1.3,
            itemExtent: textStyle.fontSize! * 1.4 * MediaQuery.of(context).textScaler.scale(1),  // text size in device settings
            onSelectedItemChanged: (index) => setWheelState(index),
            overAndUnderCenterOpacity: 0.9,
            physics: const FixedExtentScrollPhysics(),
          )
        )
      ]
    );
  }
}
