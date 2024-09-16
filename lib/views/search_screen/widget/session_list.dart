import 'package:flutter/material.dart';
import '../../../models/avilable_sesion_model.dart';
import 'TimeSelector.dart';

typedef OnTimeSelected = void Function(int sessionId, String time);

class SessionList extends StatelessWidget {
  final AvailableSession availableSession;
  final int selectedSessionId;
  final OnTimeSelected onTimeSelected;

  const SessionList({
    super.key,
    required this.availableSession,
    required this.selectedSessionId,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        TimeSelector(
          sessions: availableSession.sessions,
          selectedSessionId: selectedSessionId,
          onTimeSelected: onTimeSelected,
        ),
      ],
    );
  }
}