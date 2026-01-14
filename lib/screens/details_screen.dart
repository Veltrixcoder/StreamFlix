
import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../api/tmdb_client.dart';
import '../models/media_item.dart';

class DetailsScreen extends StatefulWidget {
  final int id;
  final String type;

  const DetailsScreen({super.key, required this.id, required this.type});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<MediaItem> _detailsFuture;
  late Future<List<Cast>> _castFuture;

  @override
  void initState() {
    super.initState();
    final client = context.read<TmdbClient>();
    _detailsFuture = client.getDetails(widget.id, widget.type);
    _castFuture = client.getCast(widget.id, widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MediaItem>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Not found'));
          }

          final movie = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: movie.fullBackdropUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title, style: Theme.of(context).textTheme.h2)
                          .animate().fadeIn().slideY(begin: 0.2),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Badge(child: Text(movie.releaseDate.split('-')[0])),
                          const SizedBox(width: 8),
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(movie.voteAverage.toStringAsFixed(1)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(movie.overview, style: Theme.of(context).textTheme.p),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        onPressed: () {
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('Playing functionality coming soon!')),
                           );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_arrow),
                            SizedBox(width: 8),
                            Text('Watch Now'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text('Cast', style: Theme.of(context).textTheme.h3),
                      const SizedBox(height: 12),
                      _buildCastList(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCastList() {
    return FutureBuilder<List<Cast>>(
      future: _castFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final cast = snapshot.data!;
        
        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            itemBuilder: (context, index) {
              final actor = cast[index];
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: actor.profilePath != null 
                        ? NetworkImage(actor.fullProfileUrl) 
                        : null,
                      child: actor.profilePath == null ? const Icon(Icons.person) : null,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      actor.name, 
                      maxLines: 2, 
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.small,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
