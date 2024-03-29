import 'package:flutter/material.dart';
import 'package:you_talk/utilities.dart';
import 'package:flutter/services.dart';
import 'package:you_talk/audioPage.dart';

class QueuePage extends StatefulWidget {
  const QueuePage({Key? key, this.itemList, this.title}) : super(key: key);
  final List<String>? itemList;
  final String? title;

  @override
  State<QueuePage> createState() =>
      QueuePageState(itemList: itemList, title: title);
}

class QueuePageState extends State<QueuePage> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<List<String>> _itemListNotifier;
  List<String>? itemList;
  String? title;
  List<String> audioList = [];

  QueuePageState({this.itemList, this.title})
      : _itemListNotifier = ValueNotifier<List<String>>(itemList ?? []);

  @override
  void dispose() {
    _itemListNotifier.dispose();
    super.dispose();
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
                wordList: audioList,
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
                        ItemContainer(info: itemList.firstOrNull ?? "No Info"),
                    onDismissed: (direction) => {
                      setState(() {
                        // ignore: no_leading_underscores_for_local_identifiers
                        List<String> _itemList = _itemListNotifier.value;
                        _itemList.removeAt(0);
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
                                info: itemList.toList()[index + 1]);
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
