import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showEditDialog({
  required BuildContext context,
  Map<String, dynamic>? item,
  required Function(Map<String, dynamic>) onSave,
}) {
  final TextEditingController titleController =
  TextEditingController(text: item?['title'] ?? '');
  final TextEditingController textController =
  TextEditingController(text: item?['text'] ?? '');
  final TextEditingController imageUrlController =
  TextEditingController(text: item?['imageUrl'] ?? '');

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(item == null ? "Добавить запись" : "Редактировать запись"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Заголовок'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Текст'),
              maxLines: null,
            ),
            SizedBox(height: 10),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(labelText: 'URL изображения'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Отмена"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newItem = {
                'title': titleController.text,
                'text': textController.text,
                'imageUrl': imageUrlController.text,
              };

              if (item == null) {
                // Создание новой записи
                var newDoc = await FirebaseFirestore.instance.collection('post').add(newItem);
                newItem['id'] = newDoc.id;
              } else {
                // Обновление существующей записи
                await FirebaseFirestore.instance.collection('post').doc(item['id']).update(newItem);
                newItem['id'] = item['id'];
              }

              onSave(newItem);
              Navigator.pop(context);
            },
            child: Text("Сохранить"),
          ),
        ],
      );
    },
  );
}
