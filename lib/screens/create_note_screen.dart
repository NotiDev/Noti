import 'package:flutter/material.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import 'package:provider/provider.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _category;
  DateTime? _deadlineDate;
  final List<String> _categories = ['Работа', 'Личное', 'Учеба'];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text(
          'Создать заметку',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLabel('Заголовок'),
              _fieldCard(
                child: _buildTextField(
                  controller: _titleController,
                  hint: 'Введите заголовок заметки...',
                  icon: Icons.title_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите заголовок';
                    }
                    if (value.trim().length < 3) {
                      return 'Минимум 3 символа';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 18),
              _buildLabel('Заметка'),
              _fieldCard(
                child: _buildTextField(
                  controller: _contentController,
                  hint: 'Напишите о вашей цели...',
                  icon: Icons.note_alt_outlined,
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите описание';
                    }
                    if (value.trim().length < 10) {
                      return 'Минимум 10 символов';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 18),
              _buildLabel('Категория'),
              _fieldCard(
                child: DropdownButtonFormField<String>(
                  value: _category,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Выберите категорию',
                  ),
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _category = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Выберите категорию';
                    }
                    return null;
                  },
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                ),
              ),

              const SizedBox(height: 18),
              _buildLabel('Срок выполнения'),
              _fieldCard(
                child: _buildDeadlineField(),
              ),

              const SizedBox(height: 26),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF3C3C3C),
            fontSize: 16,
          ),
        ),
      );

  Widget _fieldCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: child,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Row(
      children: [
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(icon, color: Colors.grey[500], size: 20),
          ),
        Expanded(
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black38),
              isCollapsed: true,
              border: InputBorder.none,
              errorStyle: const TextStyle(
                color: Colors.redAccent,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeadlineField() {
    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: _deadlineDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2101),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.blueAccent,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          setState(() {
            _deadlineDate = pickedDate;
          });
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _deadlineDate != null
                    ? 'Срок выполнения: ${_deadlineDate!.toLocal().toString().split(' ')[0]}'
                    : 'Выберите срок выполнения',
                style: TextStyle(
                  color: _deadlineDate != null ? Colors.black87 : Colors.black54,
                  fontSize: 15,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {
          final title = _titleController.text.trim();
          final content = _contentController.text.trim();

          if (_formKey.currentState?.validate() ?? false) {
            if (title.isNotEmpty && content.isNotEmpty) {
              final newNote = Note(
                title: title,
                content: content,
                category: _category ?? '',
                deadline: _deadlineDate ?? DateTime.now(),
              );
              Provider.of<NotesProvider>(context, listen: false).addNote(newNote);
              Navigator.pop(context);
            }
          }
        },
        icon: const Icon(Icons.save_rounded, color: Colors.white),
        label: const Text(
          'Сохранить заметку',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
          shadowColor: Colors.blueAccent.withOpacity(0.25),
        ),
      ),
    );
  }
}