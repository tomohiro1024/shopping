import 'package:book_list2/add_book/add_book_page.dart';
import 'package:book_list2/book_list/book_list_model.dart';
import 'package:book_list2/domain/book.dart';
import 'package:book_list2/edit_book/edit_book_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('買い物リスト'),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Consumer<BookListModel>(builder: (context, model, child) {
            final List<Book>? books = model.books;

            if (books == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widgets = books
                .map(
                  (book) => Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    child: Container(
                      decoration: new BoxDecoration(
                        border: new Border(
                          bottom: new BorderSide(color: Colors.green),
                        ),
                      ),
                      child: ListTile(
                        title: Text(book.title),
                        subtitle: Text(book.author + '円'),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Edit',
                        color: Colors.cyanAccent,
                        icon: Icons.edit,
                        onTap: () async {
                          final String? title = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBookPage(book),
                            ),
                          );
                          if (title != null) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.greenAccent,
                              content: Text('『$title』を編集しました。'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                          model.fetchBookList();
                        },
                      ),
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () async {
                          await showConfirmDialog(context, book, model);
                        },
                      ),
                    ],
                  ),
                )
                .toList();
            return ListView(
              children: widgets,
            );
          }),
        ),
        floatingActionButton:
            Consumer<BookListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBookPage(),
                  fullscreenDialog: true,
                ),
              );
              if (added != null && added) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.greenAccent,
                  content: Text('新しく品物を追加しました。'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              model.fetchBookList();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
            backgroundColor: Colors.green,
          );
        }), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Future showConfirmDialog(
    BuildContext context,
    Book book,
    BookListModel model,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("削除の確認"),
          content: Text("『${book.title}』を削除しますか？"),
          actions: [
            TextButton(
              child: Text("NO"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("YES"),
              onPressed: () async {
                await model.delete(book);
                Navigator.pop(context);
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('『${book.title}』を削除しました。'),
                );
                model.fetchBookList();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }
}
