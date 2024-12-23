import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ContentView extends StatefulWidget {
  const ContentView({Key? key}) : super(key: key);

  @override
  _ContentViewState createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {

  List<Map<String, dynamic>> lenta = [];

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  // Для Fire
  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      _fetchData(); // Fetch data from Firestore after initialization
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  // Загрузка из Fire
  Future<void> _fetchData() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance.collection('post').get();
      List<Map<String, dynamic>> data = [];
      for (var doc in querySnapshot.docs) {
        data.add({
          'id': doc.id,
          'title': doc['title'],
          'text': doc['text'],
        });
      }
      setState(() {
        lenta = data;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // Добаление и обновление
  void _showEditDialog({String? initialTitle, String? initialText, int? index}) {
    String title = initialTitle ?? '';
    String text = initialText ?? '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(index == null ? "Добавить запись" : "Редактировать запись"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Заголовок'),
                onChanged: (value) {
                  title = value;
                },
                controller: TextEditingController(text: initialTitle),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Текст',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                ),
                onChanged: (value) {
                  text = value;
                },
                controller: TextEditingController(text: initialText),
                maxLines: null, // Многострочный ввод
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Отмена"),
            ),


            ElevatedButton(
              onPressed: () async {
                if (title.isNotEmpty && text.isNotEmpty) {
                  try {
                    if (index == null) {
                      // Добавляем новую запись
                      var newDoc = await FirebaseFirestore.instance.collection('post').add({
                        'title': title,
                        'text': text,
                      });
                      setState(() {
                        lenta.add({
                          'id': newDoc.id,
                          'title': title,
                          'text': text,
                        });
                      });
                    } else {
                      // Обновляем существующую запись
                      await FirebaseFirestore.instance.collection('post').doc(lenta[index]['id']).update({
                        'title': title,
                        'text': text,
                      });
                      setState(() {
                        lenta[index] = {'id': lenta[index]['id'], 'title': title, 'text': text};
                      });
                    }
                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error saving data: $e');
                  }
                }
              },
              child: Text("Сохранить"),
            ),
          ],
        );
      },
    );
  }

  // удаления записи
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

// База
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Мои записи"),
        centerTitle: true,
      ),
      body: lenta.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: lenta.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(lenta[index]['id']),
            background: Container(color: Colors.deepOrangeAccent),
            onDismissed: (direction) {
              _deletePost(index);
            },
            child: Card(
              child: ListTile(
                title: Text(lenta[index]['title']),
                subtitle: Text(lenta[index]['text']),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditDialog(
                      initialTitle: lenta[index]['title'],
                      initialText: lenta[index]['text'],
                      index: index,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton( //Кнопка
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          _showEditDialog();
        },
        child: Icon(
          Icons.add_box,
          color: Colors.white,
        ),
      ),
    );
  }
}
