import 'package:flutter/material.dart';
import 'package:you_talk/utilities/customWidgets.dart';
import 'package:you_talk/utilities/customFunctions.dart';
import 'package:flutter/services.dart';
import 'package:you_talk/audioPage.dart';

class StackQueuePage extends StatefulWidget {
  const StackQueuePage({Key? key, this.itemList, this.title, this.isStack})
      : super(key: key);
  final List<String>? itemList;
  final String? title;
  final bool? isStack;

  @override
  State<StackQueuePage> createState() =>
      StackQueuePageState(itemList: itemList, title: title, isStack: isStack);
}

class StackQueuePageState extends State<StackQueuePage> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<List<String>> _itemListNotifier;
  List<String>? itemList;
  String? title;
  List<String> audioList = [];
  bool? isStack;

  StackQueuePageState({this.itemList, this.title, this.isStack})
      : _itemListNotifier = ValueNotifier<List<String>>(itemList ?? []);

  @override
  void dispose() {
    _itemListNotifier.dispose();
    super.dispose();
  }

  void onNewList(List<String> newList) {
    setState(() {
      itemList = newList;
      _itemListNotifier.value = newList;
    });
    saveStackData(title ?? "Just please dont be null",
                            _itemListNotifier.value);
    print("New List is $newList");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: Export Button
      //floatingActionButton: FloatingActionButton(onPressed: onPressed),
      appBar: AppBar(
        title: const Text('youTalk'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            LabelledTextField.readable(
                label: "Add Topic", controller: _controller),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
              child: OutlinedButton(
                onPressed: _addItem,
                child: const Text('Add Topic'),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tight(const Size(500, 100)),
              child: AudioPage(
                list: itemList ?? [],
                onNewList: onNewList,
              ),
            ),
            ValueListenableBuilder<List<String>>(
              valueListenable: _itemListNotifier,
              builder: (context, itemList, _) {
                if (itemList.isNotEmpty) {
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red),
                    child: ItemContainer(
                        info: isStack ?? true
                            ? itemList.last
                            : itemList.firstOrNull ?? "No Info"),
                    onDismissed: (direction) => {
                      setState(() {
                        // ignore: no_leading_underscores_for_local_identifiers
                        List<String> _itemList = _itemListNotifier.value;
                        isStack ?? true
                            ? itemList.removeLast()
                            : itemList.removeAt(0);
                        _itemListNotifier.value = [
                          ..._itemList,
                        ];
                        saveStackData(title ?? "Just please dont be null",
                            _itemListNotifier.value);
                      }),
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
            ValueListenableBuilder<List<String>>(
              valueListenable: _itemListNotifier,
              builder: (context, itemList, _) {
                if (itemList.isNotEmpty) {
                  return Container(
                    constraints: BoxConstraints.tight(const Size(500, 437.5)),
                    child: CustomScrollView(shrinkWrap: true, slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return ItemContainer(
                                info: isStack ?? true
                                    ? itemList.reversed.toList()[index + 1]
                                    : itemList.toList()[index + 1]);
                          },
                          childCount: itemList.length - 1,
                        ),
                      ),
                    ]),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addItem() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _itemListNotifier.value = [
          ..._itemListNotifier.value,
          _controller.text
        ];
      }
    });
    saveStackData(title ?? "Just please dont be null", _itemListNotifier.value);
    _controller.clear();
  }
}
