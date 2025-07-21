import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/build_context.dart';
import '/model/list_wheel_state.dart';
import '/view/list_wheel_effects.dart';

// known issues with various wheel pickers...
//
// - selector_wheel (https://github.com/AlexLomm/selector_wheel)
//    - non standard grab behaviour (see https://github.com/AlexLomm/selector_wheel/issues/2)
//
// - wheel_picker (https://pub.dev/packages/wheel_picker)
//    - does not seem to rebuild as expected
//
class ListWheel<T> extends StatelessWidget {
  const ListWheel({
    required Key key,
    required T Function(int) indexToItem,
    required String Function(T) itemToString,
    required int maxIndex,
  }) : _maxIndex = maxIndex, _itemToString = itemToString, _indexToItem = indexToItem, super(key: key);

  final T Function(int index) _indexToItem;
  final String Function(T item) _itemToString;
  final int _maxIndex;

  @override
  build(context) {
    const magnification = 1.1;
    var itemExtent =
        DefaultTextStyle.of(context).style.fontSize! * 1.4 * context.deviceTextScale; // accomodate various text sizes
    var wheelState = sl<ListWheelState<T>>();
    var controller = FixedExtentScrollController(initialItem: wheelState.index);

    // guard against selected index exceeding the maximum e.g. when changing from Revelation 7 to Jude
    if (wheelState.index > _maxIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.jumpToItem(0); // hack: without this, ListWheelScrollView sometimes partially renders
        controller.jumpToItem(_maxIndex);
        wheelState.index = _maxIndex;
      });
    }

    // workaround bug in ListWheelScrollView where a changing textStyle.fontSize -> itemExtent
    // renders badly. In this case jumpToItem on next frame
    workaroundItemExtentBug(child) {
      return NotificationListener(
        onNotification: (SizeChangedLayoutNotification notification) {
          WidgetsBinding.instance.addPostFrameCallback((_) => controller.jumpToItem(wheelState.index));
          return true; // cancel bubbling
        },
        child: SizeChangedLayoutNotifier(child: child),
      );
    }

    return Stack(children: [
      const ListWheelGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter),
      const ListWheelGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter),
      ListWheelHighlight(height: itemExtent * magnification),
      workaroundItemExtentBug(ListWheelScrollView.useDelegate(
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (_, int index) {
            if (index < 0 || index > _maxIndex) return null;
            return Text(_itemToString(_indexToItem(index)));
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
      )),
    ]);
  }
}
