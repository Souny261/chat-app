class MessageModel {
  List<Messages>? messages;
  int? count;
  int? offset;
  int? total;
  bool? success;
  String? status;
  String? message;

  MessageModel(
      {this.messages,
      this.count,
      this.offset,
      this.total,
      this.success,
      this.status,
      this.message});

  MessageModel.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
    count = json['count'];
    offset = json['offset'];
    total = json['total'];
    success = json['success'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    data['offset'] = offset;
    data['total'] = total;
    data['success'] = success;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class Messages {
  String? sId;
  String? rid;
  String? msg;
  DateTime? ts;
  U? u;
  DateTime? sUpdatedAt;
  dynamic md;
  List<Attachments>? attachments;

  Messages({
    this.sId,
    this.rid,
    this.msg,
    this.ts,
    this.u,
    this.sUpdatedAt,
    this.md,
    this.attachments,
  });

  Messages.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    rid = json['rid'];
    msg = json['msg'];
    ts = json['ts'] is String
        ? DateTime.parse(json['ts'])
        : DateTime.fromMillisecondsSinceEpoch(json['ts']['\$date']);
    u = json['u'] != null ? U.fromJson(json['u']) : null;
    sUpdatedAt = json['_updatedAt'] is String
        ? DateTime.parse(json['_updatedAt'])
        : DateTime.fromMillisecondsSinceEpoch(json['_updatedAt']['\$date']);
    if (json['md'] != null) {
      md = <Md>[];
      json['md'].forEach((v) {
        md!.add(Md.fromJson(v));
      });
    } else {
      md = "";
    }
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['rid'] = rid;
    data['msg'] = msg;
    data['ts'] = ts;
    if (u != null) {
      data['u'] = u!.toJson();
    }
    data['_updatedAt'] = sUpdatedAt;
    if (md != null) {
      data['md'] = md!.map((v) => v.toJson()).toList();
    }
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class U {
  String? sId;
  String? username;
  String? name;

  U({this.sId, this.username, this.name});

  U.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['username'] = username;
    data['name'] = name;
    return data;
  }
}

class Md {
  String? type;
  List<Value>? value;

  Md({this.type, this.value});

  Md.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['value'] != null) {
      value = <Value>[];
      json['value'].forEach((v) {
        value!.add(Value.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (value != null) {
      data['value'] = value!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Value {
  String? type;
  String? value;
  String? shortCode;
  String? unicode;

  Value({this.type, this.value, this.shortCode});

  Value.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    unicode = json['unicode'];
    if (unicode == null) {
      if (type == 'EMOJI') {
        value = json['value']['value'];
      } else {
        value = json['value'];
      }
    }
    shortCode = json['shortCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['value'] = value;
    data['shortCode'] = shortCode;
    data['unicode'] = unicode;
    return data;
  }
}

class Attachments {
  String? ts;
  String? title;
  String? titleLink;
  bool? titleLinkDownload;
  ImageDimensions? imageDimensions;
  String? imagePreview;
  String? imageUrl;
  String? imageType;
  int? imageSize;
  String? type;
  String? description;
  List<DescriptionMd>? descriptionMd;

  Attachments(
      {this.ts,
      this.title,
      this.titleLink,
      this.titleLinkDownload,
      this.imageDimensions,
      this.imagePreview,
      this.imageUrl,
      this.imageType,
      this.imageSize,
      this.type,
      this.description,
      this.descriptionMd});

  Attachments.fromJson(Map<String, dynamic> json) {
    ts = json['ts'];
    title = json['title'];
    titleLink = json['title_link'];
    titleLinkDownload = json['title_link_download'];
    imageDimensions = json['image_dimensions'] != null
        ? ImageDimensions.fromJson(json['image_dimensions'])
        : null;
    imagePreview = json['image_preview'];
    imageUrl = json['image_url'];
    imageType = json['image_type'];
    imageSize = json['image_size'];
    type = json['type'];
    description = json['description'];
    if (json['descriptionMd'] != null) {
      descriptionMd = <DescriptionMd>[];
      json['descriptionMd'].forEach((v) {
        descriptionMd!.add(DescriptionMd.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ts'] = ts;
    data['title'] = title;
    data['title_link'] = titleLink;
    data['title_link_download'] = titleLinkDownload;
    if (imageDimensions != null) {
      data['image_dimensions'] = imageDimensions!.toJson();
    }
    data['image_preview'] = imagePreview;
    data['image_url'] = imageUrl;
    data['image_type'] = imageType;
    data['image_size'] = imageSize;
    data['type'] = type;
    data['description'] = description;
    if (descriptionMd != null) {
      data['descriptionMd'] = descriptionMd!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageDimensions {
  int? width;
  int? height;

  ImageDimensions({this.width, this.height});

  ImageDimensions.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}

class DescriptionMd {
  String? type;
  List<Value>? value;

  DescriptionMd({this.type, this.value});

  DescriptionMd.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['value'] != null) {
      value = <Value>[];
      json['value'].forEach((v) {
        value!.add(Value.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (value != null) {
      data['value'] = value!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
