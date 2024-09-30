import 'package:flutter/material.dart';

Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Confirmation',style: TextStyle(fontWeight: FontWeight.w600),),
        content: const Text('Are you sure you want to delete this?',style: TextStyle(fontWeight: FontWeight.w400)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  ) ?? false; 
}

Future<bool> showConfirmConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Installment Confirmation',style: TextStyle(fontWeight: FontWeight.w600),),
        content: const Text('Are you sure you want to process this installment?',style: TextStyle(fontWeight: FontWeight.w400)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  ) ?? false;
}
