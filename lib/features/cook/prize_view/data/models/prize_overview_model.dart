import '../../domain/entities/prize_overview.dart';
import 'prize_position_model.dart';

class PrizeOverviewModel extends PrizeOverview {
  const PrizeOverviewModel({
    super.message,
    super.myPosition,
    super.prizes = const [],
  });

  factory PrizeOverviewModel.fromJson(Map<String, dynamic> json) {
    return PrizeOverviewModel(
      message: json['message'],
      myPosition: json['myPosition'] != null
          ? PrizePositionModel.fromJson(json['myPosition'])
          : null,
      prizes: json['prises'] != null
          ? (json['prises'] as List)
                .map((x) => PrizePositionModel.fromJson(x))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'myPosition': myPosition != null
          ? PrizePositionModel.fromEntity(myPosition!).toJson()
          : null,
      'prises': prizes
          .map((x) => PrizePositionModel.fromEntity(x).toJson())
          .toList(),
    };
  }
}
