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
  List<String> _categories = ['Работа', 'Личное', 'Учеба'];

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Заголовок"),
_buildTextField(
  controller: _titleController,
  hint: "Введите заголовок заметки...",
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

              const SizedBox(height: 24),
              _buildLabel("Заметка"),
_buildTextField(
  controller: _contentController,
  hint: "Напишите о вашей цели...",
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

              const SizedBox(height: 16),
              _buildCategoryField(),
              const SizedBox(height: 16),
              _buildDeadlineField(),
              const SizedBox(height: 30),
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

  Widget _buildTextField({
  required TextEditingController controller,
  required String hint,
  required String? Function(String?) validator,
  int maxLines = 1,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(
          color: Colors.redAccent,
          fontSize: 13,
        ),
      ),
    ),
  );
}


Widget _buildCategoryField() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: DropdownButtonFormField<String>(
      value: _category,
      decoration: const InputDecoration(
        border: InputBorder.none,
        labelText: 'Категория',
        labelStyle: TextStyle(
          color: Colors.black38,
          fontSize: 14,
        ),
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
        if (value == null) {
          return 'Выберите категорию';
        }
        return null;
      },
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
    ),
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
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _deadlineDate != null
                ? 'Срок выполнения: ${_deadlineDate!.toLocal().toString().split(' ')[0]}'
                : 'Выберите срок выполнения',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
            ),
          ),
          const Icon(
            Icons.calendar_today_rounded,
            color: Colors.black38,
          ),
        ],
      ),
    ),
  );
}


  Widget _buildSaveButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
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
                Provider.of<NotesProvider>(context, listen: false)
                    .addNote(newNote);
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
            shadowColor: Colors.blueAccent.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
