import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:inital_code/constant/constant.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late FocusNode _focusNode;
  TextEditingController _searchController = TextEditingController();
  List<Book> _searchResults = [];
  bool _showPagination = false;
  int _currentPage = 1;
  int _totalPages = 0;
  bool _isLoading = false;
  bool _noResults = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String value) async {
    setState(() {
      _currentPage = 1;
      _isLoading = true;
      _searchResults.clear();
      _noResults = false;
    });

    String searchQuery = value;
    String url =
        'https://www.googleapis.com/books/v1/volumes?q=intitle:$searchQuery&maxResults=40';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('items')) {
        List<Book> books = (data['items'] as List<dynamic>).map((item) {
          var authorsData = item['volumeInfo']['authors'];
          var authors = (authorsData is List<dynamic>)
              ? authorsData.cast<String>()
              : ['Unknown Author'];
          return Book(
            title: item['volumeInfo']['title'],
            authors: authors,
            thumbnailUrl: item['volumeInfo']['imageLinks']?['thumbnail'] ?? '',
          );
        }).toList();

        setState(() {
          _searchResults = books;
          _showPagination = _searchResults.length > 7;
          _totalPages = (_searchResults.length / 7).ceil();
          _isLoading = false;
          if (_searchResults.isEmpty) {
            _noResults = true;
          }
        });
      } else {
        setState(() {
          _searchResults.clear();
          _showPagination = false;
          _isLoading = false;
          _noResults = true;
        });
      }
    } else {
      print('Error: ${response.statusCode}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constant.white),
        backgroundColor: Constant.orange,
        title: TextField(
          controller: _searchController,
          onSubmitted: _handleSearch,
          style: TextStyle(color: Constant.white),
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Constant.white),
            border: InputBorder.none,
          ),
          enabled: !_isLoading,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _noResults
              ? Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(
                        color: Constant.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                )
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    if (index >= (_currentPage - 1) * 7 &&
                        index < _currentPage * 7) {
                      Book book = _searchResults[index];
                      return GestureDetector(
                        child: Card(
                          elevation: 0,
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Constant.orange, width: 2),
                          ),
                          child: ListTile(
                            title: Text(
                              book.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Constant.black),
                            ),
                            subtitle: Text(book.authors.join(' '),
                                style: TextStyle(
                                    fontSize: 14, color: Constant.gray)),
                            leading: book.thumbnailUrl != ''
                                ? Image.network(
                                    book.thumbnailUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/img_splash.jpg',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
      bottomNavigationBar: _showPagination
          ? BottomAppBar(
              color: Constant.orange,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      color: Constant.white,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          if (_currentPage > 1) {
                            _currentPage--;
                          }
                        });
                      },
                    ),
                    Text(
                      '$_currentPage / $_totalPages',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Constant.white),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      color: Constant.white,
                      onPressed: () {
                        setState(() {
                          if (_currentPage < _totalPages) {
                            _currentPage++;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

class Book {
  final String title;
  final List<String> authors;
  final String thumbnailUrl;

  Book(
      {required this.title, required this.authors, required this.thumbnailUrl});
}
