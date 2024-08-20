// Widget ValueNotifyingStacks(context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.done) {
//       // If the Future is complete, build the widget with the data
//       final ValueNotifier<List<List<String>>> snapshotNotifier =
//           ValueNotifier<List<List<String>>>(snapshot.data!);
//       print("snapshot data: ${snapshot.data}");
//       if (snapshot.data?.isEmpty ?? true) {
//         return const Center(
//           child: Text("No Stacks"),
//         );
//       }
//       return ValueListenableBuilder(
//         valueListenable: snapshotNotifier,
//         builder: (context, value, child) {
//           return ListView.builder(
//             itemCount: value.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Card(
//                   child: ListTile(
//                     title: Text(value[index][0]),
//                     subtitle: Text(value[index][1]),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => FutureBuilder<List<String>>(
//                             future: loadStackData(snapshot.data![index]
//                                 [0]), // asynchronous function call
//                             builder: (context, snapshot1) {
//                               if (snapshot1.connectionState ==
//                                   ConnectionState.done) {
//                                 // If the Future is complete, build the widget with the data
//                                 print(
//                                     "Title when stackPage is called: ${snapshot.data![index][0]}");
//                                 return StackPage(
//                                   itemList: snapshot1.data,
//                                   title: snapshot.data![index][0],
//                                 );
//                               } else {
//                                 // Otherwise, show a loading indicator or handle the loading state
//                                 return const CircularProgressIndicator();
//                               }
//                             },
//                           ),
//                         ),
//                       );
//                     },
//                     onLongPress: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: const Text("Delete Stack"),
//                             content: const Text(
//                                 "Are you sure you want to delete this stack?"),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: const Text("Cancel"),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                   setState(() {
//                                     removeStack(value[index][0]);
//                                     randomvar = -1 * randomvar;
//                                   });
//                                 },
//                                 child: const Text("Delete"),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       );
//     } else {
//       // Otherwise, show a loading indicator or handle the loading state
//       return const CircularProgressIndicator();
//     }
//   }