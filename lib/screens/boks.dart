import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

//String abcd="";
// var url =
//     'https://www.googleapis.com/books/v1/volumes?q=title:python&maxResults=20';
//String search='';

class BookFind extends StatefulWidget {
  final String search;
  BookFind({@required this.search});
  @override
  _BookFindState createState() => _BookFindState(search: search);
}

class _BookFindState extends State<BookFind> {
  final String search;
  _BookFindState({this.search});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book'),
        // leading: Icon(Icons.error),
      ),
      body: FutureBuilder(
          future: _fetchPotterBooks(search),
          builder: (context, AsyncSnapshot<List<Book>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return ListView(
                    children: snapshot.data.map((b) => BookTile(b)).toList());
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class BookTile extends StatelessWidget {
  final Book book;
  BookTile(this.book);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(book.thumbnailUrl),
      ),
      title: Text(book.title),
      subtitle: Text(book.author),
      onTap: () => _navigateToDetailsPage(book, context),
    );
  }
}

// List<Book> _fetchBooks() {
//   return List.generate(100, (i) => Book(title: 'Book $i', author: 'Author $i'));
// }

Future<List<Book>> _fetchPotterBooks(String search) async {
  // var url =
  //     'https://www.googleapis.com/books/v1/volumes?q=title:python&maxResults=20';

// if(search==""){
//   abcd="Python";
// }
// else{
//   abcd=search;
// }
  final url = Uri.encodeFull(
      'https://www.googleapis.com/books/v1/volumes?q=title:${search}');//&maxResult=30');

  final res = await http.get(url);
  print(url);
  //print(res.body);
  if (res.statusCode == 200) {
    return _parseBookJson(res.body);
  } else {
    throw Exception('Error: ${res.statusCode}');
  }
}

List<Book> _parseBookJson(String jsonStr) {
  final jsonMap = json.decode(jsonStr);
  final jsonList = (jsonMap['items'] as List);
  try{
    return jsonList
      .map((jsonBook) => Book(
            title: jsonBook['volumeInfo']['title'],
            author: (jsonBook['volumeInfo']['authors'] as List).join(', '),
            thumbnailUrl: jsonBook['volumeInfo']['imageLinks']['thumbnail'],
            description: jsonBook['volumeInfo']['description'],
          ))
      .toList();
  }
  catch(e){
    print(e);
  }
}

class Book {
  final String title;
  final String author;
  final String thumbnailUrl;
  final String description;

  Book(
      {@required this.title,
      @required this.author,
      this.thumbnailUrl,
      this.description})
      : assert(title != null),
        //  assert(description != null),
        assert(author != null);
}

void _navigateToDetailsPage(Book book, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => BookDetailsPage(book),
  ));
}

class BookDetailsPage extends StatelessWidget {
  final Book book;
  BookDetailsPage(this.book);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BookDetails(book),
      ),
    );
  }
}

class BookDetails extends StatelessWidget {
  final Book book;
  BookDetails(this.book);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(book.thumbnailUrl),
          SizedBox(height: 10.0),
          Text(book.title),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(book.author,
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: checkValue(),
            // child: Text(book.description,
            //     style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget checkValue() {
    if (book.description == null) {
      return Text("No Description");
    } else {
      return Text(book.description);
    }
  }
}
