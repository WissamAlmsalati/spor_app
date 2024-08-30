import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(date); // Same day, show hour
    } else if (difference.inDays == 1) {
      return 'منذ يوم';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام'; // Less than a week
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      if (weeks == 1) {
        return 'منذ أسبوع';
      } else if (weeks == 2) {
        return 'منذ أسبوعين';
      } else {
        return 'منذ $weeks أسابيع';
      }
    } else {
      final months = (difference.inDays / 30).floor();
      if (months == 1) {
        return 'منذ شهر';
      } else if (months == 2) {
        return 'منذ شهرين';
      } else if (months == 3) {
        return 'منذ 3 أشهر';
      } else if (months == 4) {
        return 'منذ 4 أشهر';
      } else if (months == 5) {
        return 'منذ 5 أشهر';
      } else if (months == 6) {
        return 'منذ 6 أشهر';
      } else if (months == 7) {
        return 'منذ 7 أشهر';
      } else if (months == 8) {
        return 'منذ 8 أشهر';
      } else if (months == 9) {
        return 'منذ 9 أشهر';
      } else if (months == 10) {
        return 'منذ 10 أشهر';
      } else if (months == 11) {
        return 'منذ 11 أشهر';
      } else {
        return 'منذ $months أشهر';
      }
    }
  }
}