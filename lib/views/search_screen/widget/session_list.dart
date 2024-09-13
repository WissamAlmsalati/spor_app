import 'package:flutter/material.dart';
import '../../../models/avilable_sesion_model.dart';
import 'TimeSelector.dart';

class SessionList extends StatelessWidget {
  final AvailableSession availableSession;
  final int selectedSessionId;
  final ValueChanged<int> onTimeSelected;

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