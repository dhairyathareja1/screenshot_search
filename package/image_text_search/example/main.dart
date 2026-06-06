import 'package:flutter/material.dart';
import 'package:image_text_search/image_text_search.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'image_text_search Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  List<IndexedImage> _indexedImages = [];
  List<SearchResult> _searchResults = [];
  bool _isIndexing = false;
  int _indexingProgress = 0;
  int _indexingTotal = 0;
  String _statusMessage = 'Press "Index Images" to start.';

  final SearchEngine _engine = SearchEngine();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _runIndexing() async {
    setState(() {
      _isIndexing = true;
      _indexingProgress = 0;
      _statusMessage = 'Indexing images...';
      _indexedImages = [];
      _searchResults = [];
    });

    final List<Map<String, String>> fakeData = [
      {
        'path': '/screenshots/amazon_order.png',
        'text':
            'Amazon Order #12345\nTotal: ₹1,499\nEstimated delivery: Tomorrow',
      },
      {
        'path': '/screenshots/zomato_bill.png',
        'text':
            'Zomato\nOrder from Pizza Hut\nButter Chicken Pizza x1\nTotal ₹499\nPayment via UPI',
      },
      {
        'path': '/screenshots/bank_statement.png',
        'text':
            'HDFC Bank\nAccount Statement\nBalance: ₹24,500\nLast transaction: Swiggy ₹350',
      },
      {
        'path': '/screenshots/netflix_receipt.png',
        'text':
            'Netflix India\nMonthly subscription renewed\n₹649 charged to your card ending 4242',
      },
      {
        'path': '/screenshots/whatsapp_message.png',
        'text':
            'Hey! Are you coming to the party tonight?\nBring something to eat please',
      },
    ];

    setState(() => _indexingTotal = fakeData.length);

    final List<IndexedImage> results = [];
    for (int i = 0; i < fakeData.length; i++) {
      await Future.delayed(const Duration(milliseconds: 400));

      final keywords = KeywordGenerator().generate(fakeData[i]['text']!);
      results.add(
        IndexedImage(
          id: i.toString(),
          path: fakeData[i]['path']!,
          extractedText: fakeData[i]['text']!,
          indexedAt: DateTime.now(),
          keywords: keywords,
        ),
      );

      setState(() => _indexingProgress = i + 1);
    }

    setState(() {
      _indexedImages = results;
      _isIndexing = false;
      _statusMessage = 'Indexed ${results.length} images. Try searching below!';
    });
  }

  void _runSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    final List<SearchResult> results = _engine.search(
      query: query,
      images: _indexedImages,
      minScore: 0.1,
    );
    setState(() => _searchResults = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('image_text_search Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- STATUS MESSAGE ---
            Text(_statusMessage, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isIndexing ? null : _runIndexing,
                icon: _isIndexing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.image_search),
                label: Text(_isIndexing ? 'Indexing...' : 'Index Images'),
              ),
            ),

            if (_isIndexing) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _indexingTotal > 0
                    ? _indexingProgress / _indexingTotal
                    : 0,
              ),
              const SizedBox(height: 4),
              Text('$_indexingProgress / $_indexingTotal images indexed'),
            ],

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            TextField(
              controller: _searchController,
              enabled: _indexedImages.isNotEmpty,
              decoration: InputDecoration(
                hintText: 'Search screenshots... (try "amazon" or "pizza")',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _runSearch('');
                        },
                      )
                    : null,
              ),
              onChanged: _runSearch,
            ),

            const SizedBox(height: 12),

            if (_searchController.text.isNotEmpty)
              Text(
                '${_searchResults.length} result(s) found',
                style: Theme.of(context).textTheme.bodySmall,
              ),

            const SizedBox(height: 8),

            Expanded(
              child: _searchResults.isEmpty && _searchController.text.isNotEmpty
                  ? const Center(child: Text('No results found.'))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final SearchResult result = _searchResults[index];
                        return _SearchResultCard(result: result);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final SearchResult result;
  const _SearchResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final int scorePercent = (result.score * 100).round();

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.image, size: 16, color: Colors.blue),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    result.image.path,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _scoreColor(result.score),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$scorePercent%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              result.preview,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Color _scoreColor(double score) {
    if (score >= 0.7) return Colors.green;
    if (score >= 0.4) return Colors.orange;
    return Colors.red;
  }
}
