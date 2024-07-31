import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view/list_wheel_effects.dart';
import '../view/list_wheel_state.dart';

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
  final T Function(int index) indexToItem;
  final String Function(T item) itemToString;
  final int maxIndex;
  final TextStyle textStyle;

  const ListWheel({
    required this.indexToItem,
    required this.itemToString,
    required this.maxIndex,
    required this.textStyle,
  });

  @override
  build(context) {
    const magnification = 1.1;
    var deviceTextScale = MediaQuery.of(context).textScaler.scale(1);  // from device settings
    var itemExtent = textStyle.fontSize! * 1.4 * deviceTextScale;  // accomodate various text sizes
    var wheelState = Provider.of<ListWheelState<T>>(context, listen:false);
    var controller = FixedExtentScrollController(initialItem: wheelState.index);

    // guard against selected index exceeding the maximum e.g. when changing from Revelation 7 to Jude
    if (wheelState.index > maxIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.jumpToItem(0);  // hack: without this, ListWheelScrollView sometimes partially renders
        controller.jumpToItem(maxIndex);
        wheelState.index = maxIndex;
      });
    }

    // workaround bug in ListWheelScrollView where a changing textStyle.fontSize -> itemExtent
    // renders badly. In this case jumpToItem on next frame
    workaroundItemExtentBug(child) =>
      NotificationListener(
        onNotification: (SizeChangedLayoutNotification notification) {
          WidgetsBinding.instance.addPostFrameCallback((_) => controller.jumpToItem(wheelState.index));
          return true;  // cancel bubbling
        },
        child: SizeChangedLayoutNotifier(child: child)
      );

    return Stack(
      children: [
        const ListWheelGradient(begin: Alignment.topCenter, end:Alignment.bottomCenter),
        const ListWheelGradient(begin: Alignment.bottomCenter, end:Alignment.topCenter),
        ListWheelHighlight(height: itemExtent * magnification),
        workaroundItemExtentBug(
          ListWheelScrollView.useDelegate(
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (_, int index) {
                if (index < 0 || index > maxIndex) return null;
                return Text(itemToString(indexToItem(index)), style: textStyle);
              },
            ),
            controller: controller,
            diameterRatio: 1.1,
            itemExtent: itemExtent,
            magnification: magnification,
            onSelectedItemChanged: (index) => wheelState.index = index,
            overAndUnderCenterOpacity: 0.7,
            physics: const FixedExtentScrollPhysics(),
            useMagnifier: true,
          )
        ),
      ]
    );
  }
}
