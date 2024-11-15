import 'package:flutter/material.dart';
import '../../../models/session_model.dart';
import 'hour_pricker.dart';

typedef OnTimeSelected = void Function(int sessionId, String time);

class TimeSelector extends StatelessWidget {
  final List<Session> sessions;
  final int selectedSessionId;
  final OnTimeSelected onTimeSelected;

  const TimeSelector({
    super.key,
    required this.sessions,
    required this.selectedSessionId,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: sessions.map((session) {
          final isSelected = session.sessionId == selectedSessionId;
          return SelectableTimeTile(
            time: session.startTime,
            isSelected: isSelected,
            isReserved: session.isReserved,
            isLocked: session.isLocked,
            onTap: () => onTimeSelected(session.sessionId, session.startTime),
          );
        }).toList(),
      ),
    );
  }
}