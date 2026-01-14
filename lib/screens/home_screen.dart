
import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../api/tmdb_client.dart';
import '../models/media_item.dart';
import '../components/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<MediaItem>> _trendingFuture;
  late Future<List<MediaItem>> _popularFuture;
  late Future<List<MediaItem>> _topRatedFuture;

  @override
  void initState() {
    super.initState();
    final client = context.read<TmdbClient>();
    _trendingFuture = client.getTrending();
    _popularFuture = client.getPopularMovies();
    _topRatedFuture = client.getTopRatedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StreamFlix', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
               context.push('/search');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Trending Now', _trendingFuture, isLarge: true),
            const SizedBox(height: 24),
            _buildSection('Popular Movies', _popularFuture),
            const SizedBox(height: 24),
            _buildSection('Top Rated', _topRatedFuture),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Future<List<MediaItem>> future, {bool isLarge = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(title, style: Theme.of(context).textTheme.large),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: isLarge ? 300 : 200,
          child: FutureBuilder<List<MediaItem>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No media found'));
              }

              final items = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Container(
                    width: isLarge ? 200 : 140,
                    margin: const EdgeInsets.only(right: 12),
                    child: MovieCard(movie: item, isPoster: true)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: (50 * index).ms)
                        .slideX(begin: 0.1),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
