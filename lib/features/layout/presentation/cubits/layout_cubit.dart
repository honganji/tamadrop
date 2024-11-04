import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/layout/domain/entities/layout.dart';
import 'package:tamadrop/features/layout/domain/repos/layout_repo.dart';

class LayoutCubit extends Cubit<bool> {
  final LayoutRepo layoutRepo;
  Layout layout = Layout(isDownloadPage: false);
  LayoutCubit({required this.layoutRepo}) : super(true);
  bool get isDownloadPage => layout.isDownloadPage;
  void switchPage(bool isDownloadPage) {
    emit(!isDownloadPage);
    layout.isDownloadPage = layoutRepo.switchPage(isDownloadPage);
    emit(!isDownloadPage);
  }
}
