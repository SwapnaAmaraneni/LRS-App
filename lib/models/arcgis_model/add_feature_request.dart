/* class AddFeatureRequest {
	Geometry? geometry;
	Attributes? attributes;

	AddFeatureRequest({this.geometry, this.attributes});

	AddFeatureRequest.fromJson(Map<String, dynamic> json) {
		geometry = json['geometry'] != null ? new Geometry.fromJson(json['geometry']) : null;
		attributes = json['attributes'] != null ? new Attributes.fromJson(json['attributes']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
		if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
		return data;
	}
}

class Geometry {
	List<List>? rings;
	SpatialReference? spatialReference;

	Geometry({this.rings, this.spatialReference});

	Geometry.fromJson(Map<String, dynamic> json) {
		if (json['rings'] != null) {
			rings = <List>[];
			json['rings'].forEach((v) { rings!.add(new List.fromJson(v)); });
		}
		spatialReference = json['spatialReference'] != null ? new SpatialReference.fromJson(json['spatialReference']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.rings != null) {
      data['rings'] = this.rings!.map((v) => v.toJson()).toList();
    }
		if (this.spatialReference != null) {
      data['spatialReference'] = this.spatialReference!.toJson();
    }
		return data;
	}
}

class Rings {


	Rings({});

	Rings.fromJson(Map<String, dynamic> json) {
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		return data;
	}
}

class SpatialReference {
	int? wkid;

	SpatialReference({this.wkid});

	SpatialReference.fromJson(Map<String, dynamic> json) {
		wkid = json['wkid'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['wkid'] = this.wkid;
		return data;
	}
}

class Attributes {
	String? appid;

	Attributes({this.appid});

	Attributes.fromJson(Map<String, dynamic> json) {
		appid = json['appid'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['appid'] = this.appid;
		return data;
	}
}
 */