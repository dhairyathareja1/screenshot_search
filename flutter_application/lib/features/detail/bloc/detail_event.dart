import '../../../core/models/screenshot_model.dart';

abstract class DetailEvent {}

class LoadDetailEvent extends DetailEvent {
  final ScreenshotModel screenshot;
  LoadDetailEvent(this.screenshot);
}
