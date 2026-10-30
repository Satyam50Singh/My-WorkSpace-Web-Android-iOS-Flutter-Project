import 'package:flutter/material.dart';

import '../../../domain/entities/ticket_report_entities/fetch_ticket_report_web_entity.dart';
import '../ticketing_my_request_action/scroll_button.dart';
import '../ticketing_my_request_action/ticket_count_card.dart';

class TicketReportCountHorizontalList extends StatefulWidget {
  final TicketReportStatusCountEntity? ticketRequestCount;
  final String selectedStatus;
  final void Function(String) onPressed;

  const TicketReportCountHorizontalList({
    super.key,
    this.ticketRequestCount,
    required this.selectedStatus,
    required this.onPressed,
  });

  @override
  State<TicketReportCountHorizontalList> createState() =>
      _TicketCountHorizontalListState();
}

class _TicketCountHorizontalListState
    extends State<TicketReportCountHorizontalList> {
  final ScrollController _ticketCountScrollController = ScrollController();
  bool _canScrollLeft = false;
  bool _canScrollRight = false;

  @override
  void initState() {
    super.initState();
    _ticketCountScrollController.addListener(_updateScrollButtons);
    // Allow ListView to complete layout before checking its scroll position.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollButtons();
    });
  }

  @override
  void didUpdateWidget(TicketReportCountHorizontalList oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollButtons();
    });
  }

  void _updateScrollButtons() {
    if (!_ticketCountScrollController.hasClients) return;

    final position = _ticketCountScrollController.position;
    final canScrollLeft = position.pixels > 0;
    final canScrollRight = position.pixels < position.maxScrollExtent;

    if (_canScrollLeft != canScrollLeft || _canScrollRight != canScrollRight) {
      if (mounted) {
        setState(() {
          _canScrollLeft = canScrollLeft;
          _canScrollRight = canScrollRight;
        });
      }
    }
  }

  void _scrollLeft() {
    if (!_ticketCountScrollController.hasClients) return;
    final position = _ticketCountScrollController.position;
    final target = (_ticketCountScrollController.offset - 152).clamp(
      0.0,
      position.maxScrollExtent,
    );
    _ticketCountScrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    if (!_ticketCountScrollController.hasClients) return;
    final position = _ticketCountScrollController.position;
    final target = (_ticketCountScrollController.offset + 152).clamp(
      0.0,
      position.maxScrollExtent,
    );
    _ticketCountScrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _ticketCountScrollController.removeListener(_updateScrollButtons);
    _ticketCountScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ticketRequestCount == null) return const SizedBox.shrink();

    final trc = widget.ticketRequestCount!;
    final List<(String, int?)> counts = [
      ('All', trc.total),
      ('Open', trc.open),
      ('Assigned', trc.assigned),
      ('Accepted', trc.accepted),
      ('In Progress', trc.inProgress),
      ('On Hold', trc.hold),
      ('Closed', trc.closed),
      ('Expired', trc.expired),
      ('Transferred', trc.transferred),
    ];

    return SizedBox(
      height: 90,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ListView.separated(
            controller: _ticketCountScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: counts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = counts[index];
              return InkWell(
                onTap: () => widget.onPressed(item.$1),
                child: TicketCountCard(
                  title: item.$1,
                  count: item.$2 ?? 0,
                  selectedStatus: widget.selectedStatus,
                ),
              );
            },
          ),
          if (_canScrollLeft)
            Positioned(
              left: 0,
              child: ScrollButton(
                icon: Icons.chevron_left,
                enabled: _canScrollLeft,
                onPressed: _scrollLeft,
              ),
            ),
          if (_canScrollRight)
            Positioned(
              right: 0,
              child: ScrollButton(
                icon: Icons.chevron_right,
                enabled: _canScrollRight,
                onPressed: _scrollRight,
              ),
            ),
        ],
      ),
    );
  }
}
