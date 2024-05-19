

class Photo {
    final int? id;
    final int? width;
    final int? height;
    final String? url;
    final String? photographer;
    final String? photographerUrl;
    final int? photographerId;
    final String? avgColor;
    final Src? src;
    final bool? liked;
    final String? alt;

    Photo({
        this.id,
        this.width,
        this.height,
        this.url,
        this.photographer,
        this.photographerUrl,
        this.photographerId,
        this.avgColor,
        this.src,
        this.liked,
        this.alt,
    });

    Photo copyWith({
        int? id,
        int? width,
        int? height,
        String? url,
        String? photographer,
        String? photographerUrl,
        int? photographerId,
        String? avgColor,
        Src? src,
        bool? liked,
        String? alt,
    }) => 
        Photo(
            id: id ?? this.id,
            width: width ?? this.width,
            height: height ?? this.height,
            url: url ?? this.url,
            photographer: photographer ?? this.photographer,
            photographerUrl: photographerUrl ?? this.photographerUrl,
            photographerId: photographerId ?? this.photographerId,
            avgColor: avgColor ?? this.avgColor,
            src: src ?? this.src,
            liked: liked ?? this.liked,
            alt: alt ?? this.alt,
        );

    factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        width: json["width"],
        height: json["height"],
        url: json["url"],
        photographer: json["photographer"],
        photographerUrl: json["photographer_url"],
        photographerId: json["photographer_id"],
        avgColor: json["avg_color"],
        src: json["src"] == null ? null : Src.fromJson(json["src"]),
        liked: json["liked"],
        alt: json["alt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "width": width,
        "height": height,
        "url": url,
        "photographer": photographer,
        "photographer_url": photographerUrl,
        "photographer_id": photographerId,
        "avg_color": avgColor,
        "src": src?.toJson(),
        "liked": liked,
        "alt": alt,
    };
}

class Src {
    final String? original;
    final String? large2X;
    final String? large;
    final String? medium;
    final String? small;
    final String? portrait;
    final String? landscape;
    final String? tiny;

    Src({
        this.original,
        this.large2X,
        this.large,
        this.medium,
        this.small,
        this.portrait,
        this.landscape,
        this.tiny,
    });

    Src copyWith({
        String? original,
        String? large2X,
        String? large,
        String? medium,
        String? small,
        String? portrait,
        String? landscape,
        String? tiny,
    }) => 
        Src(
            original: original ?? this.original,
            large2X: large2X ?? this.large2X,
            large: large ?? this.large,
            medium: medium ?? this.medium,
            small: small ?? this.small,
            portrait: portrait ?? this.portrait,
            landscape: landscape ?? this.landscape,
            tiny: tiny ?? this.tiny,
        );

    factory Src.fromJson(Map<String, dynamic> json) => Src(
        original: json["original"],
        large2X: json["large2x"],
        large: json["large"],
        medium: json["medium"],
        small: json["small"],
        portrait: json["portrait"],
        landscape: json["landscape"],
        tiny: json["tiny"],
    );

    Map<String, dynamic> toJson() => {
        "original": original,
        "large2x": large2X,
        "large": large,
        "medium": medium,
        "small": small,
        "portrait": portrait,
        "landscape": landscape,
        "tiny": tiny,
    };
}