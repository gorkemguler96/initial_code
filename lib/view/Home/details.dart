import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inital_code/constant/constant.dart';

class Details extends StatefulWidget {
  const Details(this.id, {Key? key, required this.addFavorite})
      : super(key: key);
  final void Function(Object newFavorite) addFavorite;
  final dynamic id;

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
              widget.addFavorite(_bookDetails);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Constant.orange, width: 2.0),
                    ),
                    backgroundColor: Constant.dark,
                    title: Text(
                      'Successful',
                      style: TextStyle(
                        color: Constant.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    content: Text(
                      'The book has been added to your favorite list',
                      style: TextStyle(color: Constant.white),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Okay',
                          style: TextStyle(
                            color: Constant.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.favorite),
            iconSize: 35,
          ),
        ],
      ),
      body: Center(
        child: _bookDetails.isNotEmpty
            ? Card(
                elevation: 4,
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Constant.orange, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Constant.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          _bookDetails['volumeInfo']['imageLinks']['thumbnail'],
                          width: 100,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Constant.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Price: ${_bookDetails['saleInfo']['saleability'] == "NOT_FOR_SALE" ? "Not For Sale" : _bookDetails['saleInfo']['listPrice']['amount']} ${_bookDetails['saleInfo']['saleability'] == "NOT_FOR_SALE" ? " " : _bookDetails['saleInfo']['listPrice']['currencyCode']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: _bookDetails['saleInfo']['saleability'] ==
                                    "NOT_FOR_SALE"
                                ? Constant.red
                                : Constant.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Constant.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Authors: ${_bookDetails['volumeInfo']['authors'][0]}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Constant.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Publisher: ${_bookDetails['volumeInfo']['publisher']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Constant.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Publisher Date: ${_bookDetails['volumeInfo']['publishedDate']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Constant.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Category: ${_bookDetails['volumeInfo']['categories'] != null ? _bookDetails['volumeInfo']['categories'][0] : "Not Available"}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Constant.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Maturity Rating: ${_bookDetails['volumeInfo']['maturityRating']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
