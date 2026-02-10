import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../core/event_service.dart';
import '../../../models/event_model.dart';
import '../../../widgets/custom_text_field.dart';
import 'package:get/get.dart' as getx;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class CreateEventDialog extends StatefulWidget {
  const CreateEventDialog({super.key});

  @override
  State<CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<CreateEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _service = AdminEventService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _rulesController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;
  bool _isLive = false;
  XFile? _selectedImage;
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _rulesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.black,
              surface: AppTheme.secondaryColor,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppTheme.secondaryColor,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: AppTheme.primaryColor,
                onPrimary: Colors.black,
                surface: AppTheme.secondaryColor,
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: AppTheme.secondaryColor,
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isStart) {
            _startDate = finalDateTime;
            _startDateController.text = "${finalDateTime.toLocal()}"
                .split('.')[0]
                .substring(0, 16);
          } else {
            _endDate = finalDateTime;
            _endDateController.text = "${finalDateTime.toLocal()}"
                .split('.')[0]
                .substring(0, 16);
          }
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImage = image;
          _webImage = bytes;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 500, // Fixed width for desktop/web
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Create Event',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Text(
                  'Banner Image',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                // Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selectedImage != null
                            ? AppTheme.primaryColor
                            : Colors.white10,
                        width: 2,
                      ),
                      image: _webImage != null
                          ? DecorationImage(
                              image: MemoryImage(_webImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add_photo_alternate_rounded,
                                size: 48,
                                color: Colors.white30,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Click to pick event banner',
                                style: TextStyle(color: Colors.white54),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
                if (_selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextButton.icon(
                      onPressed: () => setState(() {
                        _selectedImage = null;
                        _webImage = null;
                      }),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                        size: 16,
                      ),
                      label: const Text(
                        'Remove Image',
                        style: TextStyle(color: Colors.redAccent, fontSize: 12),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                const Text(
                  'Event Title',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Enter event title',
                  controller: _titleController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Title is required'
                      : null,
                  avatarColor: AppTheme.primaryColor,
                  avatarIcon: Icons.title,
                ),
                const SizedBox(height: 16),

                const Text(
                  'Description',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Enter event details...',
                  controller: _descriptionController,
                  maxLines: 4,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Description is required'
                      : null,
                  avatarColor: Colors.blueAccent,
                  avatarIcon: Icons.description,
                ),
                const SizedBox(height: 16),

                const Text(
                  'Start Date',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Select start date',
                  controller: _startDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, true),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Start date is required'
                      : null,
                  avatarColor: Colors.greenAccent,
                  avatarIcon: Icons.calendar_today_rounded,
                ),
                const SizedBox(height: 16),

                const Text(
                  'End Date',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Select end date',
                  controller: _endDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, false),
                  validator: (value) => value == null || value.isEmpty
                      ? 'End date is required'
                      : null,
                  avatarColor: Colors.redAccent,
                  avatarIcon: Icons.calendar_month_rounded,
                ),
                const SizedBox(height: 16),

                const Text(
                  'Upload Rules (optional)',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Enter rules for video uploads...',
                  controller: _rulesController,
                  maxLines: 3,
                  avatarColor: Colors.amberAccent,
                  avatarIcon: Icons.gavel_rounded,
                ),
                const SizedBox(height: 24),

                // Live Status Toggle
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
                    title: const Text(
                      'Live Status',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Make this event visible to users immediately',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    value: _isLive,
                    onChanged: (val) => setState(() => _isLive = val),
                    activeColor: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isLoading = true);

                              String? bannerUrl;
                              if (_selectedImage != null && _webImage != null) {
                                bannerUrl = await _service.uploadBanner(
                                  _webImage!,
                                  _selectedImage!.name,
                                );
                                if (bannerUrl == null) {
                                  if (mounted) {
                                    setState(() => _isLoading = false);
                                    getx.Get.snackbar(
                                      'Upload Error',
                                      'Failed to upload banner. Please ensure the backend server is running and accessible.',
                                      backgroundColor: AppTheme.errorColor,
                                      colorText: Colors.white,
                                      duration: const Duration(seconds: 5),
                                    );
                                  }
                                  return;
                                }
                              }

                              final newEvent = AdminEventModel(
                                id: '', // Generated by backend
                                title: _titleController.text,
                                description: _descriptionController.text,
                                bannerImage: bannerUrl,
                                startDate: _startDate!,
                                endDate: _endDate!,
                                uploadRules: _rulesController.text,
                                isLive: _isLive,
                              );

                              final success = await _service.createEvent(
                                newEvent,
                              );

                              if (mounted) {
                                setState(() => _isLoading = false);
                                if (success) {
                                  getx.Get.snackbar(
                                    'Success',
                                    'Event created successfully',
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                  Navigator.of(context).pop(true);
                                } else {
                                  getx.Get.snackbar(
                                    'Error',
                                    'Failed to create event',
                                    backgroundColor: AppTheme.errorColor,
                                    colorText: Colors.white,
                                  );
                                }
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'Create Live Event',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
