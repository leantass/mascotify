import '../mascotify_data_source.dart';

/// Future remote-backed implementation boundary.
///
/// This is intentionally abstract and inactive: it documents where a REST,
/// GraphQL, Firebase, or other backend adapter can live later without adding
/// network calls, endpoints, credentials, or dependencies today.
abstract interface class RemoteMascotifyDataSource
    implements MascotifyDataSource {
  const RemoteMascotifyDataSource();
}
