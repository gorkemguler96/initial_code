import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grock/grock.dart';
import 'package:http/http.dart' as http;
import 'package:inital_code/constant/constant.dart';
import 'package:inital_code/view/Home/details.dart';

class Library extends StatefulWidget {
  const Library({
    Key? key,
    required this.addFavorite,
  }) : super(key: key);
  final void Function(Object newFavorite) addFavorite;

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  List<Map<String, dynamic>> _books = [];

  @override
  void initState() {
    fetchBooks().then((value) {
      setState(() {
        _books = value;
      });
    });
    super.initState();
  }

  Future<List<Map<String, dynamic>>> fetchBooks() async {
    final response = await http.get(
      Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=Tolkien&maxResults=10&startIndex=10&orderBy=relevance',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> books = [];

      for (final item in data['items']) {
        final Map<String, dynamic> book = {
          'title': item['volumeInfo']['title'],
          'thumbnail': item['volumeInfo']['imageLinks']['thumbnail'],
          'id': item['id'],
        };
        books.add(book);
      }

      return books;
    } else {
      throw Exception(
          'Failed to fetch books, status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _books.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: (_books.length / 2).ceil(),
            itemBuilder: (context, index) {
              final int firstIndex = index * 2;
              final int secondIndex = firstIndex + 1;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBookWidget(_books[firstIndex]),
                    if (secondIndex < _books.length)
                      _buildBookWidget(_books[secondIndex]),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildBookWidget(Map<String, dynamic> book) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Grock.to(Details(book['id'], addFavorite: widget.addFavorite));
        },
        child: Container(
          width: 200,
          height: 250,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Constant.darkWhite,
            border: Border.all(color: Constant.yellow, width: 2.0),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                book['thumbnail'],
                width: 100,
                height: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8),
              Text(
                book['title'] != null
                    ? (book['title'].toString().length <= 45
                        ? book['title']
                        : book['title'].toString().substring(0, 45))
                    : '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
