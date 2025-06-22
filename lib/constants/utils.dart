// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

XFile? selectedMedia;
// CroppedFile? croppedMedia;

/// Convert a [timestamp] into a Date and Time format. eg. May 19, 2023 at 12:53 pm
String convertDateTimeStringFromTimestamp(String timestamp) {
  final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp));
  String formattedDate = DateFormat('MMMM d, yyyy \'at\' h:mm a').format(date);
  return formattedDate;
}

String convertToDateTime(String timestamp) {
  final date = DateTime.parse(timestamp);
  String formattedDate = DateFormat('MMMM d, yyyy \'at\' h:mm a').format(date);
  return formattedDate;
}
