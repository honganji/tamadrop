import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/layout/presentation/cubits/layout_states.dart';
import 'package:tamadrop/features/playlist/presentation/pages/playlist_page.dart';

class LayoutCubit extends Cubit<LayoutState> {
  Widget _page = const PlaylistPage();
  String _title = "TamaDrop";
  LayoutCubit() : super(LayoutLoaded());

  Widget get page => _page;
  String get title => _title;

  void switchPage(Widget page, String? newTitle) {
    _page = page;
    _title = newTitle ?? "TamaDrop";
    emit(LayoutLoaded());
  }

  void emitError(String message) {
    emit(LayoutError(message));
  }
}
