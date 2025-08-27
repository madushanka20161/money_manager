class AdsDTO {
  final int remaingCount;
  final bool isAdsEnable;
  final bool isAdsReqEnable;

  AdsDTO({
    required this.remaingCount,
    required this.isAdsEnable,
    required this.isAdsReqEnable,
  });

  factory AdsDTO.fromJson(Map<String, dynamic> json) {
    return AdsDTO(
      remaingCount: json['remaingCount'],
      isAdsEnable: json['isAdsEnable'],
      isAdsReqEnable: json['isAdsReqEnable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'remaingCount': remaingCount,
      'isAdsEnable': isAdsEnable,
      'isAdsReqEnable': isAdsReqEnable,
    };
  }
}