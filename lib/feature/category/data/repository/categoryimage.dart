import 'package:empire/feature/category/data/datasource/categoryimage.dart';

import '../../domain/repositories/categoryimage_repository.dart';

class CategoryImageImpl implements Categoryimage {
  final CategoryImageSources imageSource;
  CategoryImageImpl(this.imageSource);
  @override
  Future<dynamic> categoryImageFromGallery() {
    return imageSource.pickFromGallery();
  }

  @override
  Future<dynamic> categoryPickImageFromCameraUsecase() {
    return imageSource.pickFromCamera();
  }
}
