import 'package:flutter/material.dart';
import 'package:you_talk/utilities.dart';

class StackPage extends StatefulWidget {
  const StackPage({Key? key, this.itemList}) : super(key: key);
  final List<String>? itemList;

  @override
  State<StackPage> createState() => StackPageState(itemList: itemList);
}

class StackPageState extends State<StackPage> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<List<String>> _itemListNotifier;
  List<String>? itemList;

  StackPageState({this.itemList})
      : _itemListNotifier = ValueNotifier<List<String>>(itemList ?? []);

  @override
  void dispose() {
    _itemListNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => saveStackData("stack1", _itemListNotifier.value),
        child: const Icon(Icons.save),
      ),
      appBar: AppBar(
        title: const Text('youTalk'),
      ),
      body: Center(
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
            ValueListenableBuilder<List<String>>(
              valueListenable: _itemListNotifier,
              builder: (context, itemList, _) {
                if (itemList.isNotEmpty) {
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red),
                    child:
                        ItemContainer(info: itemList.lastOrNull ?? "No Info"),
                    onDismissed: (direction) => {
                      setState(() {
                        // ignore: no_leading_underscores_for_local_identifiers
                        List<String> _itemList = _itemListNotifier.value;
                        _itemList.removeLast();
                        _itemListNotifier.value = [
                          ..._itemList,
                        ];
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
                  return CustomScrollView(shrinkWrap: true, slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ItemContainer(
                              info: itemList.reversed.toList()[index + 1]);
                        },
                        childCount: itemList.length - 1,
                      ),
                    ),
                  ]);
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
    _controller.clear();
  }
}
