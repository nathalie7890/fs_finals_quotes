import 'package:flutter/material.dart';
import 'package:quotes/quote_detail.dart';
import 'package:quotes/quote_list.dart';
import 'package:quotes/quote_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Quote of The Day'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _quote = 'Press the button to get a random quote';
  bool _isLoading = false;
  String? _quoteId;
  String? _authorName;

  final List<String> _images = [
    'asset/img1.png',
    'asset/img2.png',
    'asset/img3.png'
  ];
  int _currentImageIndex = 0;

  final QuoteService _quoteService = QuoteService();

  void _fetchQuote() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final quoteData = await _quoteService.fetchRandomQuote();
      setState(() {
        _quoteId = quoteData['id'];
        _quote = quoteData['quote'] ?? "";
        _authorName = quoteData['author'];
      });
      _currentImageIndex = (_currentImageIndex + 1) % _images.length;
    } catch (e) {
      setState(() {
        _quote = 'Failed to fetch quote';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToQuoteDetail() {
    if (_quoteId != null && _authorName != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuoteDetailPage(
            quoteId: _quoteId!,
            quoteService: _quoteService,
          ),
        ),
      );
    }
  }

  void _navigateToQuoteList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuoteListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _navigateToQuoteDetail,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.asset(
                              _images[_currentImageIndex],
                              height: 200.0,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _quote,
                            style: const TextStyle(
                                fontSize: 24.0, fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: _navigateToQuoteDetail,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.indigo[300],
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft,
                              ),
                              child: const Text('View More'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _fetchQuote,
                                child: const Text('Refresh'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _navigateToQuoteList,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.black, // Background color
                                  foregroundColor: Colors.white, // Text color
                                ),
                                child: const Text('Show All'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
