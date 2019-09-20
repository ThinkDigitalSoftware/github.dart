import 'dart:typed_data';

import 'package:github/src/common/model/users.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'repos_releases.g.dart';

/// Model class for a release.
@JsonSerializable()
class Release {
  @JsonKey(ignore: true)
  Map json;

  /// Url to this Release
  @JsonKey(name: "html_url")
  String htmlUrl;

  /// Tarball of the Repository Tree at the commit of this release.
  @JsonKey(name: "tarball_url")
  String tarballUrl;

  /// ZIP of the Repository Tree at the commit of this release.
  @JsonKey(name: "zipball_url")
  String zipballUrl;

  /// The endpoint for uploading release assets.
  /// This key is a hypermedia resource. https://developer.github.com/v3/#hypermedia
  @JsonKey(name: "upload_url")
  String uploadUrl;

  /// Release ID
  int id;

  @JsonKey(name: "node_id")
  String nodeId;

  /// Release Tag Name
  @JsonKey(name: "tag_name")
  String tagName;

  /// Target Commit
  @JsonKey(name: "target_commitish")
  String targetCommitish;

  /// Release Name
  String name;

  /// Release Notes
  String body;

  /// Release Description
  String description;

  /// If the release is a draft.
  @JsonKey(name: "draft")
  bool isDraft;

  /// If the release is a pre-release.
  @JsonKey(name: "prerelease")
  bool isPrerelease;

  /// The time this release was created at.
  @JsonKey(name: "created_at")
  DateTime createdAt;

  /// The time this release was published at.
  @JsonKey(name: "published_at")
  DateTime publishedAt;

  /// The author of this release.
  @JsonKey(toJson: _authorToJson)
  User author;

  /// Release Assets
  @JsonKey(toJson: _assetsToJson)
  List<ReleaseAsset> assets;

  static Release fromJson(Map<String, dynamic> input) {
    if (input == null) return null;

    return _$ReleaseFromJson(input)..json = input;
  }

  static List<Map<String, dynamic>> _assetsToJson(List<ReleaseAsset> value) =>
      value.map((asset) => asset.toJson()).toList();

  static Map<String, dynamic> _authorToJson(User value) => value.toJson();

  Map<String, dynamic> toJson() {
    return _$ReleaseToJson(this);
  }

  String getUploadUrlFor(String name, [String label]) =>
      "${uploadUrl.substring(0, uploadUrl.indexOf('{'))}?name=$name${label != null ? ",$label" : ""}";

  bool get hasErrors =>
      json['errors'] != null && (json['errors'] as List).isNotEmpty;

  List get errors => json['errors'];
}

/// Model class for a release asset.
@JsonSerializable()
class ReleaseAsset {
  @JsonKey(ignore: true)
  Map json;

  /// Url to download the asset.
  @JsonKey(name: "browser_download_url")
  String browserDownloadUrl;

  /// Asset ID
  int id;

  /// Asset Name
  String name;

  /// Asset Label
  String label;

  /// Asset State
  String state;

  /// Asset Content Type
  @JsonKey(name: "content_type")
  String contentType;

  /// Size of Asset
  int size;

  /// Number of Downloads
  @JsonKey(name: "download_count")
  int downloadCount;

  /// Time the asset was created at
  @JsonKey(name: "created_at")
  DateTime createdAt;

  /// Time the asset was last updated
  @JsonKey(name: "updated_at")
  DateTime updatedAt;

  static ReleaseAsset fromJson(Map<String, dynamic> input) {
    if (input == null) return null;

    return _$ReleaseAssetFromJson(input)..json = input;
  }

  Map<String, dynamic> toJson() {
    return _$ReleaseAssetToJson(this);
  }
}

/// Model class for a new release to be created.
@JsonSerializable()
class CreateRelease {
  Map<String, dynamic> json;

  /// Tag Name to Base off of
  @JsonKey(name: 'tag_name')
  final String tagName;

  /// Commit to Target
  @JsonKey(name: 'target_commitish')
  String targetCommitish;

  /// Release Name
  String name;

  /// Release Body
  String body;

  /// If the release is a draft
  bool isDraft;

  /// If the release should actually be released.
  bool isPrerelease;

  CreateRelease(this.tagName);

  CreateRelease.from({
    @required this.tagName,
    @required this.name,
    @required this.targetCommitish,
    @required this.isDraft,
    @required this.isPrerelease,
    this.body,
  });

  static CreateRelease fromJson(Map<String, dynamic> input) {
    if (input == null) return null;

    return _$CreateReleaseFromJson(input)..json = input;
  }

  Map<String, dynamic> toJson() {
    return _$CreateReleaseToJson(this);
  }
}

class CreateReleaseAsset {
  /// The file name of the asset.
  String name;

  /// An alternate short description of the asset. Used in place of the filename.
  String label;

  /// The media type of the asset.
  ///
  /// For a list of media types,
  /// see [Media Types](https://www.iana.org/assignments/media-types/media-types.xhtml).
  /// For example: application/zip
  String contentType;

  /// The raw binary data for the asset being uploaded.
  ///
  /// GitHub expects the asset data in its raw binary form, rather than JSON.
  Uint8List assetData;

  CreateReleaseAsset({
    @required this.name,
    @required this.contentType,
    @required this.assetData,
    this.label,
  });
}
