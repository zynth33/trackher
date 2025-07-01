import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String content;

  const ConfirmDeleteDialog({
    super.key,
    this.title = 'Delete Entry',
    this.content = 'Are you sure you want to delete this journal entry?',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, textAlign: TextAlign.center,),
      content: Text(content, textAlign: TextAlign.center,),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel', style: TextStyle(
            color: Colors.deepPurple
          ),),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
