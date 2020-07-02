import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:list_spanish_words/list_spanish_words.dart';
import 'dart:math';

List listRandom(List items, int numberItems) {
  List ramdom = [];
  for (int i = 0; i < numberItems; i++) {
    var random = new Random();
    var z = random.nextInt(items.length);
    ramdom.add(items[z]);
  }
  return ramdom;
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Hello",
        theme:
            ThemeData(primaryColor: Colors.red[300], canvasColor: Colors.white),
        home: RandomWords());
  }
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <dynamic>[];
  final _saved = <String>{};
  final _biggerFont = TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        /*  llama al callback itembuilder por cada palabra sugerida*/
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          /*  ~/ devuelve la división entera */
          final index = i ~/ 2;

          if (index >= _suggestions.length) {
            _suggestions.addAll(listRandom(list_spanish_words, 10));
          }

          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(String word) {
    final alreadySaved = _saved.contains(word);
    return ListTile(
      title: Text(
        word,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          /* llama al metodo built lo que hace que se refresque la app */
          if (alreadySaved) {
            _saved.remove(word);
          } else {
            _saved.add(word);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final tiles = _saved.map((String word) => ListTile(
            title: Text(
              word,
              style: _biggerFont,
            ),
          ));
      final divide =
          ListTile.divideTiles(tiles: tiles, context: context).toList();
      return Scaffold(
        appBar: AppBar(
          title: Text("Tus favoritos"),
        ),
        body: ListView(
          children: divide,
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Palabras Aleatorias"), actions: [
        IconButton(
          icon: Icon(Icons.view_list),
          onPressed: _pushSaved,
        )
      ]),
      body: _buildSuggestions(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<RandomWords> createState() => _RandomWordsState();
}
