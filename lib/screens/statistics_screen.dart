import 'package:flutter/material.dart';
import '../providers/notes_provider.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
        elevation: 0,
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, _) {
          final allNotes = notesProvider.notes;
          final completedNotes = allNotes.where((note) => note.isDone).length;
          final totalNotes = allNotes.length;
          
          // Группировка по категориям
          final categoriesMap = <String, int>{};
          for (var note in allNotes) {
            categoriesMap[note.category] = (categoriesMap[note.category] ?? 0) + 1;
          }
          
          // Статистика по дедлайнам
          final now = DateTime.now();
          final overdue = allNotes.where((note) => 
            !note.isDone && note.deadline.isBefore(now)).length;
          final upcoming = allNotes.where((note) => 
            !note.isDone && note.deadline.isAfter(now)).length;
          
          final completePercentage = totalNotes > 0 
            ? ((completedNotes / totalNotes) * 100).toStringAsFixed(1)
            : '0.0';

          return LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth >= 600;
              final isPc = constraints.maxWidth >= 1200;
              
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.withOpacity(0.05),
                      Colors.blue.withOpacity(0.02),
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isPc ? 32 : isTablet ? 24 : 16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isPc ? 1400 : isTablet ? 900 : double.infinity,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Основные метрики - адаптивная сетка
                          _AdaptiveMetricsGrid(
                            isTablet: isTablet,
                            isPc: isPc,
                            totalNotes: totalNotes,
                            completedNotes: completedNotes,
                            completePercentage: completePercentage,
                          ),
                          
                          SizedBox(height: isPc ? 32 : 24),
                          
                          // Блок прогресса для мобильного
                          if (!isTablet)
                            _ProgressCard(
                              completed: completedNotes,
                              total: totalNotes,
                            ),
                          
                          if (!isTablet)
                            SizedBox(height: 16),
                          
                          // Двухколоночный layout для планшета и ПК
                          if (isTablet && !isPc)
                            _TabletLayout(
                              overdue: overdue,
                              upcoming: upcoming,
                              categoriesMap: categoriesMap,
                              totalNotes: totalNotes,
                              completedNotes: completedNotes,
                            )
                          else if (isPc)
                            _PcLayout(
                              overdue: overdue,
                              upcoming: upcoming,
                              categoriesMap: categoriesMap,
                              totalNotes: totalNotes,
                              completedNotes: completedNotes,
                            )
                          else
                            _MobileLayout(
                              overdue: overdue,
                              upcoming: upcoming,
                              categoriesMap: categoriesMap,
                              totalNotes: totalNotes,
                              completedNotes: completedNotes,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Адаптивная сетка метрик
class _AdaptiveMetricsGrid extends StatelessWidget {
  final bool isTablet;
  final bool isPc;
  final int totalNotes;
  final int completedNotes;
  final String completePercentage;

  const _AdaptiveMetricsGrid({
    required this.isTablet,
    required this.isPc,
    required this.totalNotes,
    required this.completedNotes,
    required this.completePercentage,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = isPc ? 4 : isTablet ? 3 : 2;
    final spacing = isPc ? 24.0 : isTablet ? 20.0 : 16.0;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      childAspectRatio: isPc ? 1.1 : 1.0,
      children: [
        _StatCard(
          title: 'Всего заметок',
          value: totalNotes.toString(),
          icon: Icons.note_alt_outlined,
          color: Colors.blue,
          isLarge: isPc,
        ),
        _StatCard(
          title: 'Выполнено',
          value: completedNotes.toString(),
          icon: Icons.check_circle_outline,
          color: Colors.green,
          isLarge: isPc,
        ),
        _StatCard(
          title: 'В процессе',
          value: (totalNotes - completedNotes).toString(),
          icon: Icons.pending_actions,
          color: Colors.orange,
          isLarge: isPc,
        ),
        if (isPc)
          _StatCard(
            title: 'Прогресс',
            value: '$completePercentage%',
            icon: Icons.trending_up,
            color: Colors.purple,
            isLarge: true,
          ),
      ],
    );
  }
}

// Layout для мобильного
class _MobileLayout extends StatelessWidget {
  final int overdue;
  final int upcoming;
  final Map<String, int> categoriesMap;
  final int totalNotes;
  final int completedNotes;

  const _MobileLayout({
    required this.overdue,
    required this.upcoming,
    required this.categoriesMap,
    required this.totalNotes,
    required this.completedNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionCard(
          title: 'Дедлайны',
          children: [
            _InfoRow(
              icon: Icons.warning_amber,
              label: 'Просроченные',
              value: overdue.toString(),
              valueColor: overdue > 0 ? Colors.red : Colors.grey,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.schedule,
              label: 'Предстоящие',
              value: upcoming.toString(),
              valueColor: Colors.blue,
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (categoriesMap.isNotEmpty)
          _SectionCard(
            title: 'По категориям',
            children: [
              ...categoriesMap.entries.map((entry) => [
                _InfoRow(
                  icon: Icons.label_outline,
                  label: entry.key,
                  value: entry.value.toString(),
                  valueColor: Colors.blue,
                ),
                if (entry.key != categoriesMap.entries.last.key)
                  const Divider(height: 24),
              ]).expand((i) => i),
            ],
          ),
        const SizedBox(height: 16),
        _ProgressCard(
          completed: completedNotes,
          total: totalNotes,
        ),
      ],
    );
  }
}

// Layout для планшета (2 колонны)
class _TabletLayout extends StatelessWidget {
  final int overdue;
  final int upcoming;
  final Map<String, int> categoriesMap;
  final int totalNotes;
  final int completedNotes;

  const _TabletLayout({
    required this.overdue,
    required this.upcoming,
    required this.categoriesMap,
    required this.totalNotes,
    required this.completedNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _SectionCard(
                title: 'Дедлайны',
                children: [
                  _InfoRow(
                    icon: Icons.warning_amber,
                    label: 'Просроченные',
                    value: overdue.toString(),
                    valueColor: overdue > 0 ? Colors.red : Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.schedule,
                    label: 'Предстоящие',
                    value: upcoming.toString(),
                    valueColor: Colors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _ProgressCard(
                completed: completedNotes,
                total: totalNotes,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (categoriesMap.isNotEmpty)
          _SectionCard(
            title: 'По категориям',
            children: [
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 12,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categoriesMap.length,
                itemBuilder: (context, index) {
                  final entry = categoriesMap.entries.elementAt(index);
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            entry.value.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
      ],
    );
  }
}

// Layout для ПК (3 колонны)
class _PcLayout extends StatelessWidget {
  final int overdue;
  final int upcoming;
  final Map<String, int> categoriesMap;
  final int totalNotes;
  final int completedNotes;

  const _PcLayout({
    required this.overdue,
    required this.upcoming,
    required this.categoriesMap,
    required this.totalNotes,
    required this.completedNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _SectionCard(
                title: 'Дедлайны',
                children: [
                  _InfoRow(
                    icon: Icons.warning_amber,
                    label: 'Просроченные',
                    value: overdue.toString(),
                    valueColor: overdue > 0 ? Colors.red : Colors.grey,
                    isLarge: true,
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    icon: Icons.schedule,
                    label: 'Предстоящие',
                    value: upcoming.toString(),
                    valueColor: Colors.blue,
                    isLarge: true,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _ProgressCard(
                completed: completedNotes,
                total: totalNotes,
                isLarge: true,
              ),
            ),
            const SizedBox(width: 24),
            if (categoriesMap.isNotEmpty)
              Expanded(
                child: _SectionCard(
                  title: 'По категориям',
                  children: [
                    ...categoriesMap.entries.map((entry) => [
                      _CategoryItem(
                        category: entry.key,
                        count: entry.value,
                      ),
                      if (entry.key != categoriesMap.entries.last.key)
                        const Divider(height: 20),
                    ]).expand((i) => i),
                  ],
                ),
              )
            else
              Expanded(
                child: _SectionCard(
                  title: 'По категориям',
                  children: [
                    Center(
                      child: Text(
                        'Нет категорий',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isLarge;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = isLarge ? 32.0 : 28.0;
    final padding = isLarge ? 20.0 : 16.0;
    final iconSize = isLarge ? 32.0 : 28.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: iconSize),
            ),
            Column(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isLarge ? 13 : 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final bool isLarge;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: isLarge ? 24 : 20),
            SizedBox(width: isLarge ? 14 : 12),
            Text(
              label,
              style: TextStyle(
                fontSize: isLarge ? 15 : 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isLarge ? 14 : 12,
            vertical: isLarge ? 8 : 6,
          ),
          decoration: BoxDecoration(
            color: valueColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: isLarge ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String category;
  final int count;

  const _CategoryItem({
    required this.category,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.label_outline, color: Colors.grey[600], size: 20),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final int completed;
  final int total;
  final bool isLarge;

  const _ProgressCard({
    required this.completed,
    required this.total,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? completed / total : 0.0;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isLarge ? 24 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Общий прогресс',
                  style: TextStyle(
                    fontSize: isLarge ? 17 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '${(percentage * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: isLarge ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: isLarge ? 18 : 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: isLarge ? 14 : 12,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.lerp(Colors.orange, Colors.green, percentage)!,
                ),
              ),
            ),
            SizedBox(height: isLarge ? 14 : 12),
            Text(
              'Выполнено $completed из $total заметок',
              style: TextStyle(
                fontSize: isLarge ? 14 : 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
