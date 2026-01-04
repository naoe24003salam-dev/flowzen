import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_time_utils.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/models/task.dart';
import '../../providers/task_provider.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Planner'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = _focusedDay;
              });
              HapticUtils.selection();
            },
            tooltip: 'Today',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildCalendar(),
            Expanded(
              child: _buildTaskSchedule(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addScheduledTask(context),
        child: const Icon(Icons.add),
        tooltip: 'Schedule Task',
      ).animate().scale(delay: 300.ms),
    );
  }

  Widget _buildCalendar() {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Consumer<TaskProvider>(
          builder: (context, provider, _) {
            return TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 3,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonDecoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                formatButtonTextStyle: const TextStyle(color: AppColors.primary),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                HapticUtils.selection();
              },
              onFormatChanged: (format) {
                setState(() => _calendarFormat = format);
                HapticUtils.selection();
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: (day) {
                return provider.getTasksForDate(day);
              },
            );
          },
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildTaskSchedule() {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final tasksForDay = _selectedDay != null
            ? provider.getTasksForDate(_selectedDay!)
            : <Task>[];

        if (tasksForDay.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_available,
                  size: 64,
                  color: AppColors.textTertiary,
                ).animate().fadeIn().scale(delay: 200.ms),
                const SizedBox(height: 16),
                Text(
                  'No tasks scheduled for\n${DateTimeUtils.friendlyDate(_selectedDay ?? DateTime.now())}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => _addScheduledTask(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Schedule a Task'),
                ).animate().fadeIn(delay: 400.ms),
              ],
            ),
          );
        }

        // Group tasks by hour
        final tasksByHour = <int, List<Task>>{};
        for (var task in tasksForDay) {
          if (task.dueDate != null) {
            final hour = task.dueDate!.hour;
            tasksByHour.putIfAbsent(hour, () => []).add(task);
          }
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 24, // 24 hours
          itemBuilder: (context, index) {
            final hour = index;
            final hourTasks = tasksByHour[hour] ?? [];
            
            return _buildHourSlot(context, hour, hourTasks, provider);
          },
        );
      },
    );
  }

  Widget _buildHourSlot(
    BuildContext context,
    int hour,
    List<Task> tasks,
    TaskProvider provider,
  ) {
    final timeString = DateTimeUtils.formatTime(
      TimeOfDay(hour: hour, minute: 0),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            timeString,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (tasks.isEmpty)
                Container(
                  height: 48,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                )
              else
                ...tasks.map((task) => _buildTaskCard(context, task, provider)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task, TaskProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: CheckboxListTile(
        value: task.isCompleted,
        onChanged: (_) {
          HapticUtils.lightImpact();
          provider.toggleTaskComplete(task.id);
        },
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? AppColors.textTertiary : null,
          ),
        ),
        subtitle: (task.description ?? '').isNotEmpty
            ? Text(
                task.description ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getPriorityColor(task.priority).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.circle,
            size: 12,
            color: _getPriorityColor(task.priority),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.2, end: 0);
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return AppColors.error;
      case Priority.medium:
        return AppColors.warning;
      case Priority.low:
        return AppColors.success;
    }
  }

  void _addScheduledTask(BuildContext context) {
    HapticUtils.mediumImpact();
    
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    Priority selectedPriority = Priority.medium;
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Schedule Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Priority>(
                  value: selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  items: Priority.values.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedPriority = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.access_time),
                  title: Text('Time: ${selectedTime.format(context)}'),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (time != null) {
                      setDialogState(() => selectedTime = time);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  final scheduledDate = DateTime(
                    _selectedDay!.year,
                    _selectedDay!.month,
                    _selectedDay!.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  Provider.of<TaskProvider>(context, listen: false).createTask(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    priority: selectedPriority,
                    dueDate: scheduledDate,
                  );

                  Navigator.pop(context);
                  HapticUtils.mediumImpact();
                }
              },
              child: const Text('Schedule'),
            ),
          ],
        ),
      ),
    );
  }
}
