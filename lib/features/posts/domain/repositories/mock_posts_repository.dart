import '../../domain/entities/author.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/posts_repository.dart';

/// TEMPORARY in-memory repository so the Home page can run before the real
/// feed data layer exists. Replace it once the real [PostsRepository] is wired in.
class MockPostsRepository implements PostsRepository {
  @override
  Future<List<Post>> getPosts() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final published = DateTime.now().subtract(const Duration(days: 14));

    return [
      Post(
        id: 'p1',
        author: const Author(
          id: 'a1',
          name: 'Abdullah',
          headline: 'Lead Architect',
        ),
        title: 'The Future of Web Development',
        excerpt:
            'Discover how AI-assisted compiler routines, edge rendering '
            'architecture, and resilient micro-frameworks are drastically '
            'reshaping front-end development.',
        coverImageUrl: 'https://picsum.photos/seed/wordspace-1/800/500',
        tag: 'Deep Technical Dive',
        readTimeMinutes: 7,
        publishedAt: published,
        likeCount: 18,
        commentCount: 5,
        isFeatured: true,
      ),
      Post(
        id: 'p2',
        author: const Author(id: 'a2', name: 'Abdullah', isFollowing: true),
        title: 'Why Laravel is a Great PHP Framework',
        excerpt:
            'From expressive Eloquent querying to elegant job queues and '
            'frictionless testing utilities, explore why Laravel remains a '
            'top choice for modern PHP applications.',
        coverImageUrl: 'https://picsum.photos/seed/wordspace-2/800/400',
        readTimeMinutes: 6,
        publishedAt: published,
        likeCount: 32,
        commentCount: 11,
      ),
      Post(
        id: 'p3',
        author: const Author(id: 'a3', name: 'Abdullah'),
        title: 'Getting Started with MySQL',
        excerpt:
            'Master the fundamentals of schema design, index optimization '
            'patterns, and relational query performance in MySQL.',
        coverImageUrl: 'https://picsum.photos/seed/wordspace-3/800/400',
        tag: 'Deep Dive',
        readTimeMinutes: 8,
        publishedAt: published,
        likeCount: 24,
        commentCount: 8,
      ),
    ];
  }

  @override
  Future<void> setLike({required String postId, required bool liked}) =>
      Future<void>.delayed(const Duration(milliseconds: 300));

  @override
  Future<void> setFollow({required String authorId, required bool follow}) =>
      Future<void>.delayed(const Duration(milliseconds: 500));
}