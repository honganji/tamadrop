import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/layout/domain/repos/layout_repo.dart';
import 'package:tamadrop/features/layout/presentation/cubits/layout_states.dart';
import 'package:tamadrop/features/playlist/presentation/pages/playlist_page.dart';

class LayoutCubit extends Cubit<LayoutState> {
  final LayoutRepo layoutRepo;
  Widget _page = const PlaylistPage();
  LayoutCubit({required this.layoutRepo}) : super(LayoutLoaded());

  Widget get page => _page;

  void switchPage(Widget page) {
    _page = page;
    emit(LayoutLoaded());
  }

  void emitError(String message) {
    emit(LayoutError(message));
  }
}
