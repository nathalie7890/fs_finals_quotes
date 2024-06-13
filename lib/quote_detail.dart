import 'package:flutter/material.dart';
import 'package:quotes/quote_service.dart';

class QuoteDetailPage extends StatelessWidget {
  final String quoteId;
  final QuoteService quoteService;

  const QuoteDetailPage({
    Key? key,
    required this.quoteId,
    required this.quoteService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Quote Details'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: quoteService
            .fetchQuoteById(int.parse(quoteId)), // Fetch quote by ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load quote'),
            );
          } else {
            final quoteData = snapshot.data!;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Quote ID: ${quoteData['id']}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      quoteData['quote']!,
                      style: const TextStyle(
                          fontSize: 24.0, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      '- ${quoteData['author']}',
                      style: const TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 16.0),
                    Center(
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
              ),
            );
          }
        },
      ),
    );
  }
}
