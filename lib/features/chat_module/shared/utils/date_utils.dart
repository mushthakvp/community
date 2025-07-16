import 'package:intl/intl.dart';

class ChatDateUtils {
  // Format message time based on how recent it is
  static String formatMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // If message is from today, show time only
    if (_isSameDay(dateTime, now)) {
      return DateFormat('HH:mm').format(dateTime);
    }

    // If message is from yesterday
    if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat('HH:mm').format(dateTime)}';
    }

    // If message is from this week (within 7 days)
    if (difference.inDays < 7) {
      return '${DateFormat('E').format(dateTime)} ${DateFormat('HH:mm').format(dateTime)}';
    }

    // If message is from this year
    if (dateTime.year == now.year) {
      return DateFormat('dd MMM HH:mm').format(dateTime);
    }

    // For older messages, include year
    return DateFormat('dd MMM yyyy HH:mm').format(dateTime);
  }

  // Format date header for message groups
  static String formatDateHeader(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // Today
    if (_isSameDay(dateTime, now)) {
      return 'Today';
    }

    // Yesterday
    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    // This week (show day name)
    if (difference.inDays < 7) {
      return DateFormat('EEEE').format(dateTime); // Full day name
    }

    // This year (show date without year)
    if (dateTime.year == now.year) {
      return DateFormat('dd MMMM').format(dateTime); // e.g., "15 March"
    }

    // Previous years (show full date)
    return DateFormat('dd MMMM yyyy').format(dateTime); // e.g., "15 March 2023"
  }

  // Format time for chat list (last message time)
  static String formatChatListTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // If today, show time
    if (_isSameDay(dateTime, now)) {
      return DateFormat('HH:mm').format(dateTime);
    }

    // If yesterday
    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    // If this week, show day
    if (difference.inDays < 7) {
      return DateFormat('E').format(dateTime); // Short day name
    }

    // If this year, show date
    if (dateTime.year == now.year) {
      return DateFormat('dd/MM').format(dateTime);
    }

    // Previous years
    return DateFormat('dd/MM/yy').format(dateTime);
  }

  // Format relative time (e.g., "2 minutes ago")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 30) {
      return 'Just now';
    } else if (difference.inMinutes < 1) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes minute${minutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours hour${hours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days day${days == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }

  // Format detailed timestamp for message info
  static String formatDetailedTimestamp(DateTime dateTime) {
    return DateFormat('EEEE, dd MMMM yyyy \'at\' HH:mm').format(dateTime);
    // e.g., "Monday, 15 March 2024 at 14:30"
  }

  // Format date for birthday wishes or special occasions
  static String formatBirthdayDate(DateTime dateTime) {
    final now = DateTime.now();

    // If birthday is today
    if (_isSameDay(dateTime, now)) {
      return 'Today';
    }

    // If birthday is tomorrow
    final tomorrow = now.add(const Duration(days: 1));
    if (_isSameDay(dateTime, tomorrow)) {
      return 'Tomorrow';
    }

    // Show day and date
    return DateFormat('EEEE, dd MMMM').format(dateTime);
  }

  // Format duration (e.g., for voice messages)
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
  }

  // Format seconds to mm:ss format
  static String formatSeconds(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Check if two dates are the same day
  static bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Check if date is today
  static bool isToday(DateTime dateTime) {
    return _isSameDay(dateTime, DateTime.now());
  }

  // Check if date is yesterday
  static bool isYesterday(DateTime dateTime) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _isSameDay(dateTime, yesterday);
  }

  // Check if date is this week
  static bool isThisWeek(DateTime dateTime) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return dateTime.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        dateTime.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  // Check if date is this month
  static bool isThisMonth(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year && dateTime.month == now.month;
  }

  // Check if date is this year
  static bool isThisYear(DateTime dateTime) {
    return dateTime.year == DateTime.now().year;
  }

  // Get start of day
  static DateTime startOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  // Get end of day
  static DateTime endOfDay(DateTime dateTime) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      23,
      59,
      59,
      999,
    );
  }

  // Get days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    from = startOfDay(from);
    to = startOfDay(to);
    return (to.difference(from).inHours / 24).round();
  }

  // Format time range (e.g., "2:30 PM - 4:00 PM")
  static String formatTimeRange(DateTime start, DateTime end) {
    final startTime = DateFormat('h:mm a').format(start);
    final endTime = DateFormat('h:mm a').format(end);
    return '$startTime - $endTime';
  }

  // Format date range
  static String formatDateRange(DateTime start, DateTime end) {
    if (_isSameDay(start, end)) {
      return formatDateHeader(start);
    }

    final startStr = DateFormat('dd MMM').format(start);
    final endStr = DateFormat('dd MMM yyyy').format(end);
    return '$startStr - $endStr';
  }

  // Get time of day greeting
  static String getTimeGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 6) {
      return 'Good night';
    } else if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else if (hour < 22) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  // Check if time is within business hours
  static bool isBusinessHours(DateTime dateTime) {
    final hour = dateTime.hour;
    final weekday = dateTime.weekday;

    // Monday to Friday, 9 AM to 5 PM
    return weekday >= 1 && weekday <= 5 && hour >= 9 && hour < 17;
  }

  // Format last seen time
  static String formatLastSeen(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Online';
    } else if (difference.inMinutes < 60) {
      return 'Last seen ${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return 'Last seen ${difference.inHours} hours ago';
    } else if (_isSameDay(dateTime, now.subtract(const Duration(days: 1)))) {
      return 'Last seen yesterday at ${DateFormat('HH:mm').format(dateTime)}';
    } else {
      return 'Last seen ${formatChatListTime(dateTime)}';
    }
  }

  // Format online status
  static String formatOnlineStatus(DateTime? lastSeen, bool isOnline) {
    if (isOnline) {
      return 'Online';
    } else if (lastSeen != null) {
      return formatLastSeen(lastSeen);
    } else {
      return 'Offline';
    }
  }

  // Get readable file modification time
  static String formatFileTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 5) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (_isSameDay(dateTime, now)) {
      return 'Today ${DateFormat('HH:mm').format(dateTime)}';
    } else if (isYesterday(dateTime)) {
      return 'Yesterday ${DateFormat('HH:mm').format(dateTime)}';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  // Parse various date formats
  static DateTime? parseFlexibleDate(String dateString) {
    // List of common date formats to try
    final formats = [
      'yyyy-MM-dd HH:mm:ss',
      'yyyy-MM-ddTHH:mm:ss.SSSZ',
      'yyyy-MM-ddTHH:mm:ssZ',
      'yyyy-MM-dd',
      'dd/MM/yyyy',
      'MM/dd/yyyy',
      'dd-MM-yyyy',
    ];

    for (final format in formats) {
      try {
        return DateFormat(format).parse(dateString);
      } catch (e) {
        // Try next format
        continue;
      }
    }

    // If no format works, try DateTime.parse as last resort
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
}
