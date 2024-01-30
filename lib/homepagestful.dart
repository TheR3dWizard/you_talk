import 'package:flutter/material.dart';
import 'package:you_talk/utilities.dart';
import 'package:you_talk/stackPage.dart';

class HomePageStful extends StatefulWidget {
  const HomePageStful({super.key});

  @override
  State<HomePageStful> createState() => _HomePageStfulState();
}

class _HomePageStfulState extends State<HomePageStful> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();

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
                      setState(() {
                        createNewStack(
                            controllerName.text, controllerDescription.text);
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<List<String>>>(
          future: loadAccountdata(),
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
                      title: Text(snapshot.data![index][0]),
                      subtitle: Text(snapshot.data![index][1]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FutureBuilder<List<String>>(
                              future: loadStackData(snapshot.data![index]
                                  [0]), // asynchronous function call
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  // If the Future is complete, build the widget with the data
                                  return StackPage(itemList: snapshot.data);
                                } else {
                                  // Otherwise, show a loading indicator or handle the loading state
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                        );
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
}

class HomePageOld extends StatelessWidget {
  HomePageOld({super.key});

  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();

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
                      createNewStack(
                          controllerName.text, controllerDescription.text);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<List<String>>>(
          future: loadAccountdata(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, build the widget with the data
              print("snapshot data: ${snapshot.data}");
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Card(
                    child: ListTile(
                      title: Text(snapshot.data![index][0]),
                      subtitle: Text(snapshot.data![index][1]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FutureBuilder<List<String>>(
                              future: loadStackData(snapshot.data![index]
                                  [0]), // asynchronous function call
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  // If the Future is complete, build the widget with the data
                                  return StackPage(itemList: snapshot.data);
                                } else {
                                  // Otherwise, show a loading indicator or handle the loading state
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                        );
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
}

class StackIntro extends StatelessWidget {
  const StackIntro({super.key, required this.data});

  final List<String> data;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FutureBuilder<List<String>>(
              future: loadStackData(data[0]), // asynchronous function call
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, build the widget with the data
                  return StackPage(itemList: snapshot.data);
                } else {
                  // Otherwise, show a loading indicator or handle the loading state
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        );
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.blue,
            ),
            constraints: const BoxConstraints(
                minHeight: 50, minWidth: 50, maxWidth: 100, maxHeight: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data[0],
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(data[1]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
