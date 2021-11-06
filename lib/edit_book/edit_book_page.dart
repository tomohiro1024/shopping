import 'package:book_list2/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_book_model.dart';

class EditBookPage extends StatelessWidget {
  final Book book;
  EditBookPage(this.book);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditBookModel>(
      create: (_) => EditBookModel(book),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '編集',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.cyanAccent,
        ),
        body: Center(
          child: Consumer<EditBookModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    cursorColor: Colors.cyanAccent,
                    controller: model.titleController,
                    decoration: InputDecoration(
                      hintText: '商品名',
                    ),
                    onChanged: (text) {
                      model.setTitle(text);
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    cursorColor: Colors.cyanAccent,
                    keyboardType: TextInputType.number,
                    controller: model.authorController,
                    decoration: InputDecoration(
                      hintText: '価格',
                    ),
                    onChanged: (text) {
                      model.setAuthor(text);
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: model.isUpdated()
                        ? () async {
                            try {
                              await model.update();
                              Navigator.of(context).pop(model.title);
                            } catch (e) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        : null,
                    child: Text(
                      '更新する',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.cyanAccent,
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
