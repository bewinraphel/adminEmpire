import 'dart:typed_data';

import 'package:equatable/equatable.dart';
class VariantImageData extends Equatable {
  final String? filePath;
  final Uint8List? bytes;
  final String? webUrl;
  
  const VariantImageData({
    this.filePath,
    this.bytes,
    this.webUrl,
  }) : assert(
         filePath != null || bytes != null || webUrl != null,
         'At least one image data source must be provided',
       );
  
  /// Create from file path (mobile)
  factory VariantImageData.fromPath(String path) {
    return VariantImageData(filePath: path);
  }
  
  /// Create from bytes (web)
  factory VariantImageData.fromBytes(Uint8List bytes) {
    return VariantImageData(bytes: bytes);
  }
  
  /// Create from URL (web/network)
  factory VariantImageData.fromUrl(String url) {
    return VariantImageData(webUrl: url);
  }
  
  bool get isWeb => bytes != null;
  bool get isFile => filePath != null;
  bool get isUrl => webUrl != null;
  
  @override
  List<Object?> get props => [filePath, bytes, webUrl];
}