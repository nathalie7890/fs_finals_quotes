import 'package:flutter/material.dart';
import 'package:quotes/quote_detail.dart';
import 'package:quotes/quote_service.dart';

class QuoteListPage extends StatefulWidget {
  const QuoteListPage({Key? key}) : super(key: key);

  @override
  State<QuoteListPage> createState() => _QuoteListPageState();
}

class _QuoteListPageState extends State<QuoteListPage> {
  List<Map<String, String>> _quotes = [];
  bool _isLoading = false;

  final QuoteService _quoteService = QuoteService();

  void _fetchQuotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final quotes = await _quoteService.fetchQuotes();
      print('Quotes fetched: $quotes');
      setState(() {
        _quotes = quotes;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _quotes = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchQuotes();
  }

  void _navigateToQuoteDetail(String quoteId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuoteDetailPage(
          quoteId: quoteId,
          quoteService: _quoteService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('All Quotes'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _quotes.length,
                    itemBuilder: (context, index) {
                      final quote = _quotes[index];
                      return GestureDetector(
                        onTap: () {
                          _navigateToQuoteDetail(quote['id']!);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Card(
                            elevation:
                                5, // You can adjust the elevation to control the shadow
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(quote['quote'] ?? 'No content'),
                              subtitle: Text(
                                '- ${quote['author'] ?? 'Unknown'}',
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Background color
                      foregroundColor: Colors.white, // Text color
                    ),
                    child: const Text('Back'),
                  ),
                ),
              ],
            ),
    );
  }
}
