import 'package:flutter/material.dart';
import 'package:hexolt/provider/Api_Provider.dart';
import 'package:hexolt/services/database_helper.dart';
import 'package:hexolt/widget/custom_loading_widget.dart';
import 'package:hexolt/widget/error_dialogBox.dart';
import 'package:hexolt/widget/no_data_widget.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _posts = [];
  bool _loading = true;
  bool _isDataAvailable = false;

  @override
  void initState() {
    super.initState();
    _fetchAndStorePosts();
  }

  // Fetch from API and store in SQLite
  Future<void> _fetchAndStorePosts() async {
    final apiService = ApiService();
    final dbHelper = DatabaseHelper();

    // Clear old data first
    await dbHelper.clearPosts();

    try {
      // Fetch posts from API
      final posts = await apiService.fetchPosts();

      if (posts.isNotEmpty) {
        // Insert posts into the database
        for (var post in posts) {
          await dbHelper.insertPost({
            'id': post['id'],
            'userId': post['userId'],
            'title': post['title'],
            'body': post['body'],
          });
        }

        // Load posts from database and display
        final storedPosts = await dbHelper.getPosts();

        setState(() {
          _posts = storedPosts;
          _loading = false;
          _isDataAvailable = true; // Data is available
        });
      } else {
        setState(() {
          _loading = false;
          _isDataAvailable = false; // No data available
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      // Show error dialog when an error occurs
      ErrorDialog.showErrorDialog(context, 'Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        title: const Text(
          'Posts',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              radius: 20,
              child: IconButton(
                icon: Icon(
                  Icons.refresh,
                  size: 25,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _loading = true;
                  });
                  _fetchAndStorePosts();
                },
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? CustomLoadingWidget()
          : _isDataAvailable
          ? ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['title'].toString().toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(post['body'], style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        },
      )
          : CustomNoDataWidget(),
    );
  }
}

