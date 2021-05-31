import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CoverArtArchiveResponse {
  List<Images> images = <Images>[];
  String release = "";

  CoverArtArchiveResponse({required this.images, required this.release});

  CoverArtArchiveResponse.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      images = List.empty(growable: true);
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    release = json['release'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['release'] = this.release;
    return data;
  }
}

class Images {
  String image = "";
  Thumbnails? thumbnails;

  Images(
      { required this.image,
        required this.thumbnails,
      });

  Images.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    thumbnails = json['thumbnails'] != null
        ? new Thumbnails.fromJson(json['thumbnails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    if (this.thumbnails != null) {
      data['thumbnails'] = this.thumbnails?.toJson();
    }
    return data;
  }
}

class Thumbnails {
  String large = "";
  String small = "";

  Thumbnails({required this.large, required this.small});

  Thumbnails.fromJson(Map<String, dynamic> json) {
    large = json['large'];
    small = json['small'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['large'] = this.large;
    data['small'] = this.small;
    return data;
  }
}