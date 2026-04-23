class Trip {
  final String id;
  final String from;
  final String to;
  final String departureTime;
  final String duration;
  final double price;
  final String date;
  final String imageUrl;
  final String? videoId; // YouTube video ID, optional

  const Trip({
    required this.id,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.duration,
    required this.price,
    required this.date,
    required this.imageUrl,
    this.videoId,
  });
}

// Dummy trip data with destination-contextual images
final List<Trip> dummyTrips = [
  const Trip(
    id: '1',
    from: 'Jazan',
    to: 'Abha',
    departureTime: '07:00 AM',
    duration: '3h 30m',
    price: 75.0,
    date: 'Thu, Apr 24',
    imageUrl:
        'https://images.unsplash.com/photo-1586724237569-f3d0c1dee8c6?w=400&h=300&fit=crop&q=80',
    videoId: 'o66HxHB0mF4',
  ),
  const Trip(
    id: '2',
    from: 'Jazan',
    to: 'Abha',
    departureTime: '11:00 AM',
    duration: '3h 30m',
    price: 85.0,
    date: 'Thu, Apr 24',
    imageUrl:
        'https://images.unsplash.com/photo-1586724237569-f3d0c1dee8c6?w=400&h=300&fit=crop&q=80',
    videoId: 'o66HxHB0mF4',
  ),
  const Trip(
    id: '3',
    from: 'Jazan',
    to: 'Riyadh',
    departureTime: '09:30 AM',
    duration: '8h 00m',
    price: 145.0,
    date: 'Thu, Apr 24',
    imageUrl:
        'https://images.unsplash.com/photo-1586724237569-f3d0c1dee8c6?w=400&h=300&fit=crop&q=80',
    videoId: 'o66HxHB0mF4',
  ),
  const Trip(
    id: '4',
    from: 'Jazan',
    to: 'Jeddah',
    departureTime: '06:00 AM',
    duration: '5h 30m',
    price: 110.0,
    date: 'Thu, Apr 24',
    imageUrl:
        'https://images.unsplash.com/photo-1586724237569-f3d0c1dee8c6?w=400&h=300&fit=crop&q=80',
  ),
  const Trip(
    id: '5',
    from: 'Jazan',
    to: 'Abha',
    departureTime: '03:00 PM',
    duration: '3h 30m',
    price: 80.0,
    date: 'Thu, Apr 24',
    imageUrl:
        'https://images.unsplash.com/photo-1586724237569-f3d0c1dee8c6?w=400&h=300&fit=crop&q=80',
    videoId: 'o66HxHB0mF4',
  ),
];
