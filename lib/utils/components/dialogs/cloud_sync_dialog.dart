import 'package:flutter/material.dart';
import 'package:trackher/sessions/user_session.dart';
import '../../extensions/build_context.dart';

void showCloudSyncDialog(BuildContext context) {
  context.showAnimatedDialog(
    builder: (context) => AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_sync, color: Colors.deepPurpleAccent),
          SizedBox(width: 8),
          Text(
            "Cloud Sync",
            style: TextStyle(
              color: Colors.deepPurpleAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      content: Text(
        "Do you want to sync your data to the cloud?",
        style: TextStyle(color: Colors.deepPurple),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // TODO: Add logic for opting out of sync
            Navigator.of(context).pop(); // Close dialog
          },
          child: Text("No", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () async {
            // TODO: Add logic for opting out of sync
            Navigator.of(context).pop(); // Close dialog
            UserSession().syncPeriodData();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
          child: const Text('Yes', style: TextStyle(
            color: Colors.white
          ),),
        ),
      ],
    ),
  );
}
