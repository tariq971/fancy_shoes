import 'package:cloudinary_sdk/cloudinary_sdk.dart';

class MediaRepository {
  late Cloudinary cloudinary;

  MediaRepository() {
    cloudinary = Cloudinary.full(
      apiKey: '196837596344365',
      apiSecret: 'ZAmKdUVsm08oOF0x1YLmhfuVHbs',
      cloudName: 'dh1h9qucw',
    );
  }

  Future<CloudinaryResponse> uploadImage(String path) {
    return cloudinary.uploadResource(CloudinaryUploadResource(
      filePath: path,
      resourceType: CloudinaryResourceType.image,
    ));
  }
}

