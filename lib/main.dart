import 'package:flutter/material.dart';
import 'package:you_talk/utilities.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key, this.itemList}) : super(key: key);
  final List<String>? itemList;

  @override
  State<MainApp> createState() => _MainAppState(itemList: itemList);
}

class _MainAppState extends State<MainApp> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<List<String>> _itemListNotifier;
  List<String>? itemList;

  _MainAppState({this.itemList})
      : _itemListNotifier = ValueNotifier<List<String>>(itemList ?? []);

  @override
  void dispose() {
    _itemListNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            LabelledTextField.readable(
                label: "Add Topic", controller: _controller),
            OutlinedButton(
              onPressed: _addItem,
              child: const Text('Add Topic'),
            ),
            ValueListenableBuilder<List<String>>(
              valueListenable: _itemListNotifier,
              builder: (context, itemList, _) {
                return Dismissible(
                  key: UniqueKey(), //probably not the best way to do this
                  child: ItemContainer(info: itemList.lastOrNull ?? "No Info"),
                  onDismissed: (direction) => {
                    setState(() {
                      List<String> _itemList = _itemListNotifier.value;
                      _itemList.removeLast();
                      _itemListNotifier.value = [
                        ..._itemList,
                      ];
                    }),
                  },
                );
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
    print(_itemListNotifier.value);
  }
}

class ItemContainer extends StatelessWidget {
  const ItemContainer({
    super.key,
    this.info,
  });

  final String? info;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
        child: Container(
          width: 500,
          height: 50,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(100, 0, 0, 0),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 4.0), // shadow direction: bottom right
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 0.0),
                )
              ]),
          child: Center(
              child: Text(
            info ?? "No Info",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ));
  }
}
