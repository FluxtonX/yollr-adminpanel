import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/event_service.dart';
import '../../models/event_model.dart';
import 'event_detail_view.dart';
import 'widgets/create_event_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  final _service = AdminEventService();
  List<AdminEventModel> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() => _isLoading = true);
    final events = await _service.fetchAllEvents();
    if (mounted) {
      setState(() {
        _events = events;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteEvent(AdminEventModel event) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.secondaryColor,
          title:
              const Text('Delete Event', style: TextStyle(color: Colors.white)),
          content: Text(
            'Are you sure you want to delete "${event.title}"?\nThis action cannot be undone.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white70)),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (!mounted) return;
      setState(() => _isLoading = true);
      final bool success = await _service.deleteEvent(event.id);
      if (success) {
        _fetchEvents();
      } else {
        if (!mounted) return;
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete event')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Events Management',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: _buildCreateButton(),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Events Management',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buildCreateButton(),
                    ],
                  ),
            SizedBox(height: isMobile ? 24 : 32),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  )
                : _events.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.event_rounded,
                            size: 64,
                            color: AppTheme.textSecondaryColor,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No events found',
                            style:
                                TextStyle(color: AppTheme.textSecondaryColor),
                          ),
                          const SizedBox(height: 24),
                          TextButton.icon(
                            onPressed: _fetchEvents,
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Refresh'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = 1;
                          if (constraints.maxWidth > 1400) {
                            crossAxisCount = 4;
                          } else if (constraints.maxWidth > 1100) {
                            crossAxisCount = 3;
                          } else if (constraints.maxWidth > 700) {
                            crossAxisCount = 2;
                          }

                          // Higher aspect ratio for mobile/small cards to give more vertical space
                          double aspectRatio = constraints.maxWidth < 500
                              ? 1.5
                              : (constraints.maxWidth < 800 ? 1.3 : 1.1);

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                              childAspectRatio: aspectRatio,
                            ),
                            itemCount: _events.length,
                            itemBuilder: (context, index) {
                              final event = _events[index];
                              return _buildEventCard(context, event);
                            },
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => const CreateEventDialog(),
        );
        if (result == true) {
          _fetchEvents();
        }
      },
      icon: const Icon(Icons.add_rounded),
      label: const Text('Create Event'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, AdminEventModel event) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventDetailView(event: event),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Banner Placeholder
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        image: event.bannerImage != null
                            ? DecorationImage(
                                image: NetworkImage(event.bannerImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: event.bannerImage == null
                          ? const Center(
                              child: Icon(
                                Icons.image_rounded,
                                size: 40,
                                color: Colors.white10,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            _deleteEvent(event);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: Text(
                                event.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _buildStat(
                                icon: Icons.videocam_rounded,
                                label: '${event.videoCount}',
                                color: Colors.white60,
                              ),
                              const SizedBox(width: 12),
                              _buildStat(
                                icon: Icons.person_rounded,
                                label: '${event.participantCount}',
                                color: Colors.white60,
                              ),
                            ],
                          ),
                          if (DateTime.now().isBefore(event.endDate))
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: event.isLive
                                      ? Colors.red.withOpacity(0.1)
                                      : Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  event.isLive ? 'LIVE' : 'UPCOMING',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        event.isLive ? Colors.red : Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
