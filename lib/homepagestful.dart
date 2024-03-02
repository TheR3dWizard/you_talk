import 'package:flutter/material.dart';
import 'package:you_talk/utilities.dart';
import 'package:you_talk/stackPage.dart';
import 'package:you_talk/queuePage.dart';

class HomePageStful extends StatefulWidget {
  const HomePageStful({super.key});

  @override
  State<HomePageStful> createState() => _HomePageStfulState();
}

class _HomePageStfulState extends State<HomePageStful> {
  int randomvar = 1;

  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();

  late Future<List<List<String>>>? _stackData;

  @override
  void initState() {
    super.initState();
    // Initialize the future in the initState
    _stackData = loadAccountdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('youTalk'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return stackCreator();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<List<String>>>(
          future: _stackData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, build the widget with the data
              print("snapshot data: ${snapshot.data}");
              if (snapshot.data?.isEmpty ?? true) {
                return const Center(
                  child: Text("No Stacks"),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Card(
                    child: ListTile(
                      title: Text(
                          "${snapshot.data![index][2]}: ${snapshot.data![index][0]}"),
                      subtitle: Text(snapshot.data![index][1]),
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Delete Stack"),
                                content: const Text(
                                    "Are you sure you want to delete this stack?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();

                                        setState(() {
                                          removeStack(snapshot.data![index][0]);
                                        });
                                      },
                                      child: const Text("Delete"))
                                ],
                              );
                            });
                      },
                      onTap: () {
                        if (snapshot.data![index][2] == "Stack") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FutureBuilder<List<String>>(
                                future: loadStackData(snapshot.data![index]
                                    [0]), // asynchronous function call
                                builder: (context, snapshot1) {
                                  if (snapshot1.connectionState ==
                                      ConnectionState.done) {
                                    // If the Future is complete, build the widget with the data
                                    print(
                                        "Title when stackPage is called: ${snapshot.data![index][0]}");
                                    return StackPage(
                                      itemList: snapshot1.data,
                                      title: snapshot.data![index][0],
                                    );
                                  } else {
                                    // Otherwise, show a loading indicator or handle the loading state
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FutureBuilder<List<String>>(
                                future: loadStackData(snapshot.data![index]
                                    [0]), // asynchronous function call
                                builder: (context, snapshot1) {
                                  if (snapshot1.connectionState ==
                                      ConnectionState.done) {
                                    // If the Future is complete, build the widget with the data
                                    print(
                                        "Title when stackPage is called: ${snapshot.data![index][0]}");
                                    return QueuePage(
                                      itemList: snapshot1.data,
                                      title: snapshot.data![index][0],
                                    );
                                  } else {
                                    // Otherwise, show a loading indicator or handle the loading state
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ));
                },
              );
            } else {
              // Otherwise, show a loading indicator or handle the loading state
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  FutureBuilder<List<String>> stackCreator() {
    return FutureBuilder<List<String>>(
        future: loadStackNames(),
        builder: (context, snapshot) {
          return AlertDialog(
            title: const Text('Create New Stack'),
            content: NewStackDialog(
              controllerName: controllerName,
              controllerDescription: controllerDescription,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  randomvar = -1 * randomvar;
                  if (snapshot.data?.contains(controllerName.text) == false) {
                    setState(() {
                      createNewStack(
                          controllerName.text, controllerDescription.text);
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Stack Exists"),
                          content: const Text(
                              "A stack with this name already exists. Please choose a different name."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Create'),
              ),
            ],
          );
        });
  }
}

class NewStackDialog extends StatelessWidget {
  const NewStackDialog(
      {super.key,
      required this.controllerName,
      required this.controllerDescription});

  final TextEditingController controllerName;
  final TextEditingController controllerDescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tight(const Size(300, 300)),
      child: Column(
        children: [
          LabelledTextField.readable(label: "Name", controller: controllerName),
          LabelledTextField.readable(
              label: "Description", controller: controllerDescription),
        ],
      ),
    );
  }
}
