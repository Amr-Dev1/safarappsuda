import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _fromCtrl =
      TextEditingController(text: 'Jazan');
  final TextEditingController _toCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();
  List<Trip> _results = [];
  bool _searched = false;

  // Palette
  static const Color _seaBlue = Color(0xFF2E86C1);
  static const Color _lightBlue = Color(0xFFD6EAF8);
  static const Color _bg = Color(0xFFF8FBFE);
  static const Color _textDark = Color(0xFF1A2D40);
  static const Color _textMid = Color(0xFF4A6572);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateCtrl.text =
        '${_weekday(now.weekday)}, ${_month(now.month)} ${now.day}';
  }

  String _weekday(int d) =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][d - 1];
  String _month(int m) => [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m - 1];

  void _search() {
    FocusScope.of(context).unfocus();
    setState(() {
      _results = dummyTrips;
      _searched = true;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: _seaBlue),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _dateCtrl.text =
            '${_weekday(picked.weekday)}, ${_month(picked.month)} ${picked.day}';
      });
    }
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Safar',
          style: TextStyle(
            color: _seaBlue,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 0.8,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none_rounded,
                color: _textMid, size: 24),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Header
          const Text(
            'Where are you\nheaded today?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _textDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),

          // Search card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _seaBlue.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSearchField(
                  controller: _fromCtrl,
                  label: 'From',
                  icon: Icons.trip_origin_rounded,
                  iconColor: _seaBlue,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: Divider(height: 1, color: Color(0xFFEAF2F8)),
                ),
                _buildSearchField(
                  controller: _toCtrl,
                  label: 'To',
                  hint: 'e.g. Abha',
                  icon: Icons.location_on_rounded,
                  iconColor: const Color(0xFFE67E22),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: Divider(height: 1, color: Color(0xFFEAF2F8)),
                ),
                _buildSearchField(
                  controller: _dateCtrl,
                  label: 'Date',
                  icon: Icons.calendar_today_rounded,
                  iconColor: _textMid,
                  readOnly: true,
                  onTap: _pickDate,
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _search,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _seaBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_rounded, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Search',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          if (_searched) ...[
            Row(
              children: [
                const Text(
                  'Available Trips',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_results.length} found',
                  style: const TextStyle(
                    fontSize: 13,
                    color: _textMid,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._results.map((trip) => _TripCard(trip: trip)),
          ] else ...[
            // Placeholder hint
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Icon(Icons.directions_bus_rounded,
                      size: 64, color: _lightBlue),
                  const SizedBox(height: 12),
                  const Text(
                    'Search for available trips',
                    style: TextStyle(color: _textMid, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    required Color iconColor,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _textMid,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              TextField(
                controller: controller,
                readOnly: readOnly,
                onTap: onTap,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _textDark,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: hint ?? '',
                  hintStyle: TextStyle(
                    color: _textMid.withValues(alpha: 0.5),
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TripCard extends StatelessWidget {
  final Trip trip;
  const _TripCard({required this.trip});

  static const Color _seaBlue = Color(0xFF2E86C1);
  static const Color _textDark = Color(0xFF1A2D40);
  static const Color _textMid = Color(0xFF4A6572);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailsScreen(trip: trip)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _seaBlue.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // ── Destination thumbnail ──
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 72,
                height: 72,
                child: Image.network(
                  trip.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: const Color(0xFFD6EAF8),
                      child: const Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: _seaBlue,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFD6EAF8),
                    child: const Icon(
                      Icons.landscape_rounded,
                      color: _seaBlue,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // ── Trip info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route row
                  Row(
                    children: [
                      const Icon(Icons.trip_origin_rounded,
                          size: 12, color: _seaBlue),
                      const SizedBox(width: 5),
                      Text(
                        trip.from,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(Icons.arrow_forward_rounded,
                            size: 14, color: _textMid),
                      ),
                      Text(
                        trip.to,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.location_on_rounded,
                          size: 12, color: Color(0xFFE67E22)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Time + duration
                  Row(
                    children: [
                      _infoChip(Icons.access_time_rounded, trip.departureTime),
                      const SizedBox(width: 12),
                      _infoChip(Icons.timer_outlined, trip.duration),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Price badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6EAF8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'SAR ${trip.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _seaBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ── Chevron hint ──
            const Icon(Icons.chevron_right_rounded,
                color: _textMid, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: _textMid),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: _textMid,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
