abstract class LayoutState {}

class LayoutInitial extends LayoutState {}

class LayoutError extends LayoutState {
  final String message;
  LayoutError(this.message);
}

class LayoutLoaded extends LayoutState {}
