import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:inital_code/constant/constant.dart';

final favoriteItemsProvider = StateProvider<List<dynamic>>((ref) => []);

class Details extends StatefulWidget {
  final dynamic id;
  // final favoriteItemsProvider = StateProvider<List<dynamic>>((ref) => []);

  const Details(this.id, {Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Map<String, dynamic> _bookDetails = {};

  @override
  void initState() {
    super.initState();
    fetchBookDetails();
  }

  Future<void> fetchBookDetails() async {
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/books/v1/volumes/${widget.id}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _bookDetails = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load book details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constant.orange,
        title: Text(_bookDetails.isNotEmpty
            ? _bookDetails['volumeInfo']['title']
            : 'Loading...'),
        titleTextStyle: TextStyle(
          color: Constant.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontStyle: FontStyle.italic,
        ),
        iconTheme: IconThemeData(color: Constant.white),
        actions: [
          IconButton(
            color: Constant.red,
            onPressed: () {
              addToFavorites(context, _bookDetails);
              print('Item added to favorites: $_bookDetails');
            },
            icon: Icon(Icons.favorite),
            iconSize: 35,
          ),
        ],
      ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: Center(
            child: _bookDetails.isNotEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(
                  _bookDetails['volumeInfo']['imageLinks']['thumbnail'],
                  width: 100,
                  height: 150,
                ),
                SizedBox(height: 16),
                Text(
                      'Price: ${_bookDetails['saleInfo']['saleability'] == "NOT_FOR_SALE" ? "Not For Sale" : _bookDetails['saleInfo']['listPrice']['amount']} ${_bookDetails['saleInfo']['saleability'] == "NOT_FOR_SALE" ? " " : _bookDetails['saleInfo']['listPrice']['currencyCode']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color:_bookDetails['saleInfo']['saleability'] == "NOT_FOR_SALE" ? Constant.red : Constant.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Constant.white, width: 1.0),
                    ),
                  ),
                ),
                Text(
                  'Authors: ${_bookDetails['volumeInfo']['authors'][0]}',
                  style: TextStyle(fontSize: 16, color: Constant.white,fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Constant.white, width: 1.0),
                    ),
                  ),
                ),
                Text(
                  'Publisher: ${_bookDetails['volumeInfo']['publisher']}',
                  style: TextStyle(fontSize: 16, color: Constant.white,fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Constant.white, width: 1.0),
                    ),
                  ),
                ),
                Text(
                  'Publisher Date: ${_bookDetails['volumeInfo']['publishedDate']}',
                  style: TextStyle(fontSize: 16, color: Constant.white,fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Constant.white, width: 1.0),
                    ),
                  ),
                ),
                Text(
                  'Category: ${_bookDetails['volumeInfo']['categories'] != null ? _bookDetails['volumeInfo']['categories'][0] : "Not Available"}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Constant.white,fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Constant.white, width: 1.0),
                    ),
                  ),
                ),
                Text(
                  'Maturity Rating: ${_bookDetails['volumeInfo']['maturityRating']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Constant.white,fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Constant.white, width: 1.0),
                    ),
                  ),
                ),
              ],
            )
                : CircularProgressIndicator(),
          ),
        ),
    );
  }

  void addToFavorites(BuildContext context, Map<String, dynamic> bookDetails) {}
}
