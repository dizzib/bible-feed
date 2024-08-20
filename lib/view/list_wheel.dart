import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../model/list_wheel_state.dart';
import '../view/list_wheel_effects.dart';
import '../util/build_context.dart';

// known issues with various wheel pickers...
//
// - selector_wheel (https://github.com/AlexLomm/selector_wheel)
//    - non standard grab behaviour (see https://github.com/AlexLomm/selector_wheel/issues/2)
//
// - wheel_picker (https://pub.dev/packages/wheel_picker)
//    - does not seem to rebuild as expected
//
class ListWheel<T> extends StatelessWidget {
  final T Function(int index) indexToItem;
  final String Function(T item) itemToString;
  final int maxIndex;

  const ListWheel({
    required this.indexToItem,
    required this.itemToString,
    required this.maxIndex,
  });

  @override
  build(context) {
    const magnification = 1.1;
    var itemExtent = DefaultTextStyle.of(context).style.fontSize! * 1.4 * context.deviceTextScale;  // accomodate various text sizes
    var wheelState = di<ListWheelState<T>>();
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
                return Text(itemToString(indexToItem(index)));
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
