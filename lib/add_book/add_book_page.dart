import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_book_model.dart';

class AddBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddBookModel>(
      create: (_) => AddBookModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('商品を追加'),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: Consumer<AddBookModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    cursorColor: Colors.orange,
                    decoration: InputDecoration(
                      hintText: '商品名',
                    ),
                    onChanged: (text) {
                      model.title = text;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    cursorColor: Colors.orange,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '価格',
                    ),
                    onChanged: (text) {
                      model.author = text;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await model.addBook();
                        Navigator.of(context).pop(true);
                      } catch (e) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text('追加する'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
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
