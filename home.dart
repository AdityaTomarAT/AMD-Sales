import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hexcolor/hexcolor.dart';

import 'battery_model.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key:key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

  String imageUrl = '';
  String model = '';
  List searchResults = [];
  var resultData;
  String documentId='';
  List<Battery> searchedItems = [];

  final TextEditingController searchController = TextEditingController();
  bool isSearchEmpty = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void searchFromFirebase(String query) async {
    searchedItems.clear();
    for (var element in batteries) {
      var name = element.model.toLowerCase();
      if(name.contains(query.toLowerCase())) {
        searchedItems.add(element);
      }
    }
  }

  Future<void> update(Battery batteryDetails) async {
    if (batteryDetails != null) {
      _nameController.text = batteryDetails.name;
      _modelController.text = batteryDetails.model;
      _quantityController.text = batteryDetails.quantity;
    }
    print("_update documentId : $documentId");
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery
                    .of(ctx)
                    .viewInsets
                    .bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _modelController,
                  decoration: const InputDecoration(
                    labelText: 'Model',
                  ),
                ),
                TextField(
                  controller: _quantityController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor("#e30608")
                      ),
                      child: const Text('Update'),
                      onPressed: () async {
                        final String name = _nameController.text;
                        final String model = _modelController.text;
                        final String quantity = _quantityController.text;
                        {
                          print("onPressed edit documentId : $documentId");
                          await battery!.doc(batteryDetails.documentId).update(
                              {'name': name, 'model': model, 'quantity': quantity,
                              });
                          // _nameController.text = '';
                          // _modelController.text = '';
                          // _quantityController.text = '';
                          // Navigator.of(context).pop();
                         await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                              builder: (context)=>home()),
                                  (route) => false);
                        }
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:HexColor("#e30608")),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Text('Back'))
                  ],
                )
              ],
            ),
          );
        }
    );
  }
  Future<void> create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery
                    .of(ctx)
                    .viewInsets
                    .bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _modelController,
                  decoration: const InputDecoration(
                    labelText: 'Model',
                  ),
                ),
                TextField(
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
                  controller: _quantityController,
                  decoration: const InputDecoration(
                      labelText: 'Quantity'
                  ),
                ),
                const SizedBox(
                  height: 20,
                  width: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor("#e30608")
                      ),
                      child: const Text('Create'),
                      onPressed: () async {

                        final String name = _nameController.text;
                        final String model = _modelController.text;
                        final String quantity = _quantityController.text;

                        if (name!= null) {
                          await battery!.add({'name': name, 'model': model, 'quantity': quantity,});
                          _nameController.text = '';
                          _modelController.text = '';
                          _quantityController.text = '';
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:HexColor("#e30608")),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('Back'))
                  ],
                )
              ],
            ),
          );
        });
  }
  Future<void> delete(Battery batterydetails ) async {
    await battery!.doc(batterydetails.documentId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  CollectionReference battery=FirebaseFirestore.instance.collection('battery');
  List<Battery> batteries = [];

  Future<void> fetchBatteryData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('battery').get();
    List<Battery> batteryList = querySnapshot.docs.map((doc) {
      return Battery.fromJson(doc.data() as Map<String, dynamic>, doc.id);}).toList();
    setState(() {
      batteries = batteryList;
    });
    // fetchBatteryData();
  }
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {

      _nameController.text = documentSnapshot['name'];
      _modelController.text = documentSnapshot['model'];
      _quantityController.text = documentSnapshot['quantity'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
                  controller: _modelController,
                  decoration: const InputDecoration(
                    labelText: 'Model',
                  ),
                ),
                TextField(
                  controller: _quantityController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:HexColor("#e30608")),
                      child: const Text( 'Update'),
                      onPressed: () async {
                        final String name = _nameController.text;
                        final String model = _modelController.text;
                        final String quantity = _quantityController.text;
                        if (name != null) {

                          await battery.doc(documentSnapshot!.id)
                              .update({"name": name, "model": model, "quantity": quantity});
                          _nameController.text = '';
                          _modelController.text = '';
                          _quantityController.text = '';
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:HexColor("#e30608")),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('Back'))
                  ],
                )
              ],
            ),
          );
        });
  }
  Future<void> _delete(String productId) async {
    await battery.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }
  @override
  void initState() {
    // TODO: implement initState
    battery = FirebaseFirestore.instance.collection('battery');
    fetchBatteryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: HexColor("#e30608"),
        title: const Text('AMD SALES'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(24)),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Battery",
                prefixIcon: Icon(Icons.search),
                prefixIconColor: HexColor("#e30608")
              ),
              onChanged: (query) => {
                setState(() {
                  if ((searchController.text).replaceAll(" ", "") == "") {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context)=>home()),
                            (route) => false);
                  }
                  model=query;
                  searchFromFirebase(query);
                }),
              },
            ),
          ),
          Expanded(
            child: searchedItems.isEmpty || model.isEmpty
                ? StreamBuilder(
                  stream: battery.snapshots(),
                     builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return
                            Container(
                            height: 300,
                                child: ListView.builder(
                                    itemCount: streamSnapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      final DocumentSnapshot documentSnapshot =
                                          streamSnapshot.data!.docs[index];
                                      return
                                        ListTileTheme(
                                          minVerticalPadding: 10,
                                          child: ListTile(
                                              title: Text(documentSnapshot['name']),
                                              subtitle: Text('Model: ${documentSnapshot['model']}'),
                                              leading: CircleAvatar(
                                                backgroundColor: HexColor("#e30608"),
                                                child: Text(documentSnapshot['quantity'],
                                                style: const TextStyle(
                                                  color: Colors.white
                                                ))),
                                              trailing: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: HexColor("#e30608")
                                                ),
                                                height: 40,
                                                width: 99,
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () async {
                                                       await _update(documentSnapshot);
                                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                                            builder: (context)=>home()),
                                                                (route) => false);
                                                      },
                                                      icon: Icon(Icons.edit),
                                                      color: Colors.white,
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible: false,
                                                            builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                title: Text("Delete Battery"),
                                                                content: Text("Do You Want to Delete Battery ?"),
                                                                actions: <Widget>[
                                                                  ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor:HexColor("#e30608")
                                                                      ),
                                                                      child: Text('Yes'),
                                                                      onPressed: () => {
                                                                       _delete(documentSnapshot.id),
                                                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                                                            builder: (context)=>home()),
                                                                                (route) => false)
                                                                      }),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor:HexColor("#e30608")
                                                                    ),
                                                                    child: Text('No'),
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                  ),

                                                                ],
                                                              );
                                                            });
                                                      },
                                                      icon: const Icon(Icons.delete),
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              )
                                          ),
                                        );
                                    }),
                              );
                        }
                        return const
                        Center(
                          child: CircularProgressIndicator(),
                        );
                      })
                  : Container(
                    height: 400,
                    child: ListView.builder(
                      itemCount: searchedItems.length,
                      itemBuilder: (context, index) {
                        Battery battery = searchedItems[index];
                        return ListTile(
                          title: Text(battery.name),
                          subtitle:
                          Text('Model: ${battery.model}'),
                          leading: CircleAvatar(
                            backgroundColor: HexColor("#e30608"),
                            child: Text("${battery.quantity}",
                              style: const TextStyle(
                                color: Colors.white
                            ),)),
                            trailing: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor("#e30608")
                              ),
                              height: 40,
                              width: 99,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                     await update(searchedItems[index]);
                                     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                         builder: (context)=>home()),
                                             (route) => false);
                                    },
                                    icon: Icon(Icons.edit),
                                    color: Colors.white,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Delete Battery"),
                                              content: Text("Do You Want to Delete Battery ?"),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:HexColor("#e30608")
                                                  ),
                                                  child: Text('Yes'),
                                                  onPressed: () async {
                                                    await delete(searchedItems[index]);
                                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                                        builder: (context)=>home()),
                                                            (route) => false);
                                                  }),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:HexColor("#e30608")
                                                  ),
                                                  child: Text('No'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),

                                              ],
                                            );
                                          });
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor("#e30608"),
          child: Icon(Icons.add,
          color: Colors.white,),
          onPressed: ()=> create()),
    );
  }
}

