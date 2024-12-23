import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tovar.dart';
import 'addbtn.dart';

class ContentView extends StatefulWidget {
  @override
  _ContentViewState createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  List<Map<String, dynamic>> lenta = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Загрузка данных из Firestore
  Future<void> _fetchData() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance.collection('post').get();
      List<Map<String, dynamic>> data = [];
      for (var doc in querySnapshot.docs) {
        data.add({
          'id': doc.id,
          'title': doc['title'],
          'text': doc['text'],
          'imageUrl': doc.data().containsKey('imageUrl') ? doc['imageUrl'] : '',
        });
      }
      setState(() {
        lenta = data;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // Удаление записи
  void _deletePost(int index) async {
    try {
      String docId = lenta[index]['id'];
      await FirebaseFirestore.instance.collection('post').doc(docId).delete();
      setState(() {
        lenta.removeAt(index);
      });
    } catch (e) {
      print('Error deleting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Мои записи"), centerTitle: true),
      body: lenta.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 3 / 4,
        ),
        padding: EdgeInsets.all(10.0),
        itemCount: lenta.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(lenta[index]['id']),
            background: Container(color: Colors.deepOrangeAccent),
            onDismissed: (_) => _deletePost(index),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailsPage(item: lenta[index]),
                ),
              ),
              child: Card(
                child: Column(
                  children: [
                    if (lenta[index]['imageUrl'].isNotEmpty)
                      Image.network(
                        lenta[index]['imageUrl'],
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lenta[index]['title'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            lenta[index]['text'],
                            style: TextStyle(fontSize: 14),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => showEditDialog(
                        context: context,
                        item: lenta[index],
                        onSave: (updatedItem) {
                          setState(() {
                            lenta[index] = updatedItem;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () => showEditDialog(
          context: context,
          onSave: (newItem) {
            setState(() {
              lenta.add(newItem);
            });
          },
        ),
        child: Icon(Icons.add_box, color: Colors.white),
      ),
    );
  }
}
