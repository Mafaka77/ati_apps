import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

extension MimeTypeHelper on String? {
  // Returns a Pretty Label: e.g. "application/pdf" -> "PDF Document"
  String get toFileLabel {
    if (this == null) return 'Unknown File';
    final mime = this!.toLowerCase();

    if (mime.contains('pdf')) return 'PDF Document';
    if (mime.contains('word') || mime.contains('officedocument.word'))
      return 'Word Doc';
    if (mime.contains('excel') || mime.contains('officedocument.spreadsheet'))
      return 'Excel Sheet';
    if (mime.contains('image')) return 'Image File';
    if (mime.contains('video')) return 'Video Clip';
    if (mime.contains('zip') || mime.contains('rar')) return 'Archive';

    return 'Document';
  }

  // Returns a Specific Icon based on type
  IconData get toFileIcon {
    if (this == null) return Ionicons.document_outline;
    final mime = this!.toLowerCase();

    if (mime.contains('pdf')) return Ionicons.document_text_outline;
    if (mime.contains('word')) return Ionicons.reader_outline;
    if (mime.contains('image')) return Ionicons.image_outline;
    if (mime.contains('video')) return Ionicons.videocam_outline;
    if (mime.contains('zip')) return Ionicons.archive_outline;

    return Ionicons.document_outline;
  }

  // Returns a color theme for the file type
  Color get toFileColor {
    if (this == null) return Colors.grey;
    final mime = this!.toLowerCase();

    if (mime.contains('pdf')) return Colors.redAccent;
    if (mime.contains('word')) return Colors.blueAccent;
    if (mime.contains('excel')) return Colors.green;
    if (mime.contains('video')) return Colors.purple;

    return Colors.blueGrey;
  }
}
