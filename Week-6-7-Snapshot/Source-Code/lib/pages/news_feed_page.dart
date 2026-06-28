import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  List<Post> _posts = [];
  List<Post> _filtered = [];
  final _searchController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final posts = await ApiService.fetchPosts();
      setState(() {
        _posts = posts;
        _filtered = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _onSearch() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? _posts
          : _posts
              .where((p) =>
                  p.title.toLowerCase().contains(q) ||
                  p.description.toLowerCase().contains(q) ||
                  p.tags.any((t) => t.toLowerCase().contains(q)))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFB),
      appBar: AppBar(
        title: const Text('Campus News Feed',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _isLoading ? null : _fetchPosts,
            tooltip: 'Refresh',
          ),
          if (_posts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Text(
                  '${_filtered.length} article${_filtered.length == 1 ? '' : 's'}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          if (_posts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search articles...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF1565C0)),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.blueGrey),
                          onPressed: () {
                            _searchController.clear();
                            _onSearch();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF1565C0)),
                        SizedBox(height: 16),
                        Text('Loading news feed...',
                            style: TextStyle(color: Colors.blueGrey)),
                      ],
                    ),
                  )
                : _errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wifi_off,
                                  size: 72, color: Colors.blue.shade200),
                              const SizedBox(height: 16),
                              Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.blueGrey, fontSize: 15),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: _fetchPosts,
                                icon: const Icon(Icons.refresh,
                                    color: Colors.white),
                                label: const Text('Retry',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1565C0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off,
                                    size: 64, color: Colors.blue.shade200),
                                const SizedBox(height: 16),
                                const Text('No articles found',
                                    style: TextStyle(
                                        color: Colors.blueGrey, fontSize: 16)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: _filtered.length,
                            itemBuilder: (_, i) => _postCard(_filtered[i]),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _postCard(Post post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.blue.shade100,
              blurRadius: 6,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              post.title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1)),
            ),
            const SizedBox(height: 8),

            // Description
            if (post.description.isNotEmpty)
              Text(
                post.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 13, color: Colors.blueGrey, height: 1.5),
              ),

            // Tags
            if (post.tags.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: post.tags
                    .take(3)
                    .map((tag) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('#$tag',
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF1565C0),
                                  fontWeight: FontWeight.w600)),
                        ))
                    .toList(),
              ),
            ],

            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFE3F2FD)),
            const SizedBox(height: 8),

            // Footer: author, date, reading time
            Row(
              children: [
                const Icon(Icons.person_outline,
                    size: 14, color: Colors.blueGrey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(post.authorName,
                      style: const TextStyle(
                          fontSize: 11, color: Colors.blueGrey),
                      overflow: TextOverflow.ellipsis),
                ),
                const Icon(Icons.access_time,
                    size: 13, color: Colors.blueGrey),
                const SizedBox(width: 4),
                Text('${post.readingTime} min read',
                    style: const TextStyle(
                        fontSize: 11, color: Colors.blueGrey)),
                const SizedBox(width: 10),
                Text(post.publishedAt,
                    style: const TextStyle(
                        fontSize: 11, color: Colors.blueGrey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
