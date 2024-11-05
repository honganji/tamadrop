import 'package:tamadrop/features/layout/domain/repos/layout_repo.dart';

class LayoutChangeRepo implements LayoutRepo {
  @override
  bool switchPage(bool isDownloadPage) {
    return (!isDownloadPage);
  }
}
