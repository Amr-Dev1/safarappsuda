import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/trip_model.dart';

class DetailsScreen extends StatefulWidget {
  final Trip trip;
  const DetailsScreen({super.key, required this.trip});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  // Palette
  static const Color _seaBlue = Color(0xFF2E86C1);
  static const Color _bg = Color(0xFFF8FBFE);
  static const Color _textDark = Color(0xFF1A2D40);
  static const Color _textMid = Color(0xFF4A6572);
  static const Color _priceAccent = Color(0xFF1A6392);

  // Video state
  bool _videoTapped = false;
  bool _videoLoaded = false;
  bool _videoError = false;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _videoLoaded = true);
          },
          onWebResourceError: (_) {
            if (mounted) setState(() => _videoError = true);
          },
        ),
      );
  }

  void _onPlayTapped() {
    final videoId = widget.trip.videoId;
    if (videoId == null) return;
    setState(() => _videoTapped = true);
    _webViewController.loadHtmlString(_buildIframeHtml(videoId));
  }

  String _buildIframeHtml(String videoId) {
    return '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { background: #000; }
  iframe {
    position: absolute; top: 0; left: 0;
    width: 100%; height: 100%;
    border: none;
  }
  html, body { width: 100%; height: 100%; }
</style>
</head>
<body>
<iframe
  src="https://www.youtube.com/embed/$videoId?autoplay=1&rel=0&modestbranding=1"
  allow="autoplay; encrypted-media"
  allowfullscreen>
</iframe>
</body>
</html>
''';
  }

  void _showBookingConfirmation() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFD5F5E3),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(Icons.check_rounded,
                  color: Color(0xFF27AE60), size: 30),
            ),
            const SizedBox(height: 16),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your seat on the ${widget.trip.from} → ${widget.trip.to} trip at ${widget.trip.departureTime} has been reserved.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: _textMid,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _seaBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // ── Hero image with app bar overlay ──
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  backgroundColor: _seaBlue,
                  leading: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded,
                            color: _textDark, size: 18),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Destination hero image
                        Image.network(
                          trip.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF2E86C1),
                                    Color(0xFF1A5276),
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white54,
                                  strokeWidth: 2.5,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF2E86C1),
                                  Color(0xFF1A5276),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Icon(Icons.landscape_rounded,
                                  color: Colors.white38, size: 56),
                            ),
                          ),
                        ),
                        // Gradient overlay for readability
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.1),
                                Colors.black.withValues(alpha: 0.5),
                              ],
                              stops: const [0.4, 1.0],
                            ),
                          ),
                        ),
                        // Destination label at bottom
                        Positioned(
                          bottom: 16,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trip.to,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.trip_origin_rounded,
                                      size: 11, color: Colors.white70),
                                  const SizedBox(width: 5),
                                  Text(
                                    'From ${trip.from}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      color: Colors.white38,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.timer_outlined,
                                      size: 11, color: Colors.white70),
                                  const SizedBox(width: 4),
                                  Text(
                                    trip.duration,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Scrollable content ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Route info card ──
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF2E86C1), Color(0xFF1A5276)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: _seaBlue.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Route',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white60,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    trip.from,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Icon(Icons.arrow_forward_rounded,
                                        color: Colors.white70, size: 20),
                                  ),
                                  Text(
                                    trip.to,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _whiteChip(Icons.access_time_rounded,
                                      trip.departureTime),
                                  const SizedBox(width: 12),
                                  _whiteChip(
                                      Icons.timer_outlined, trip.duration),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Price card ──
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBF5FB),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: const Color(0xFFD6EAF8), width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          child: Row(
                            children: [
                              const Icon(Icons.local_offer_rounded,
                                  color: _seaBlue, size: 20),
                              const SizedBox(width: 10),
                              const Text(
                                'Ticket Price',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: _textMid,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'SAR ${trip.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: _priceAccent,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Description (moved ABOVE video) ──
                        const Text(
                          'About This Trip',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Travel through the scenic highlands connecting Jazan\'s '
                          'warm coastal city to the cool heights of ${trip.to}. '
                          'Enjoy a comfortable, air-conditioned ride with modern '
                          'seating and on-board amenities. Buses depart on schedule '
                          'and stop at designated rest areas along the way.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: _textMid,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Video Section (only if videoId exists) ──
                        if (trip.videoId != null) _buildVideoSection(),

                        const SizedBox(height: 100), // space above fixed button
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Fixed Book Now button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _showBookingConfirmation,
              style: ElevatedButton.styleFrom(
                backgroundColor: _seaBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.confirmation_number_outlined, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────── VIDEO SECTION ────────────────────────────

  Widget _buildVideoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Destination Preview',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: _videoError
                ? _buildErrorFallback()
                : !_videoTapped
                    ? _buildThumbnailPlayer()
                    : Stack(
                        children: [
                          WebViewWidget(controller: _webViewController),
                          if (!_videoLoaded) _buildSkeleton(),
                        ],
                      ),
          ),
        ),
      ],
    );
  }

  /// Thumbnail with play button overlay (no autoplay)
  Widget _buildThumbnailPlayer() {
    final videoId = widget.trip.videoId!;
    return GestureDetector(
      onTap: _onPlayTapped,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // YouTube thumbnail via network
          Image.network(
            'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFFD6EAF8),
              child: const Icon(Icons.image_not_supported_rounded,
                  color: Color(0xFF2E86C1), size: 40),
            ),
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return _buildSkeleton();
            },
          ),
          // Dark overlay
          Container(color: Colors.black.withValues(alpha: 0.25)),
          // Play button
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                size: 36,
                color: Color(0xFF2E86C1),
              ),
            ),
          ),
          // Label
          Positioned(
            bottom: 10,
            left: 12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Tap to play • Destination video',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shimmer-style skeleton while video loads
  Widget _buildSkeleton() {
    return Container(
      color: const Color(0xFFD6EAF8),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF2E86C1),
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  /// Fallback when video fails to load
  Widget _buildErrorFallback() {
    return Container(
      color: const Color(0xFFEBF5FB),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, color: Color(0xFF5DADE2), size: 40),
          SizedBox(height: 10),
          Text(
            'Video unavailable',
            style: TextStyle(
              color: Color(0xFF4A6572),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Check your connection and try again.',
            style: TextStyle(color: Color(0xFF7F8C8D), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _whiteChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white70),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
