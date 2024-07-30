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
    required this.constraints,
    required this.count,
    required this.indexToItem,
    required this.itemToString,
  });

  final BoxConstraints constraints;
  final int count;
  final T Function(int index) indexToItem;
  final String Function(T item) itemToString;

  @override
  Widget build(BuildContext context) {
    WheelState<T> wheelState = Provider.of<WheelState<T>>(context, listen:false);
    FixedExtentScrollController controller = FixedExtentScrollController(initialItem: wheelState.index);

    void setWheelState(int index) {
      wheelState.index = index;
      wheelState.item = indexToItem(index);
    }

    final textStyle = TextStyle(
      fontSize: (constraints.maxWidth < 200 || constraints.maxHeight < 200) ? 16 : 24, // accomodate small displays
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,  // without this, large text wraps and disappears
    );

    // guard against selected index exceeding count - 1
    if (wheelState.index >= count) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.jumpToItem(count - 1);
        setWheelState(count - 1);
      });
    }

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
          if (index < 0 || index >= count) return null;
          return Text(itemToString(indexToItem(index)), style: textStyle);
        },
      ),
      controller: controller,
      diameterRatio: 1.3,
      itemExtent: textStyle.fontSize! * 1.4 * MediaQuery.of(context).textScaler.scale(1),  // text size in device settings
      magnification: 1.1,
      onSelectedItemChanged: (index) => setWheelState(index),
      overAndUnderCenterOpacity: 0.5,
      physics: const FixedExtentScrollPhysics(),
      useMagnifier: true,
    );
  }
}
