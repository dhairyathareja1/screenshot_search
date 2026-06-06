import '../../../core/models/screenshot_model.dart';

abstract class DetailState {}

class DetailInitial extends DetailState {}

class DetailLoaded extends DetailState {
  final ScreenshotModel screenshot;
  DetailLoaded(this.screenshot);
}
