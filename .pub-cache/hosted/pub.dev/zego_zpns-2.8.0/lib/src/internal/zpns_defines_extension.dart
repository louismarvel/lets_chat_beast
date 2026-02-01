import '../zpns_defines.dart';

extension ZPNsPushSourceTypeExtension on ZPNsPushSourceType {
  static const valueMap = {
    ZPNsPushSourceType.ZEGO:0,
    ZPNsPushSourceType.Vivo: 1,
    ZPNsPushSourceType.XiaoMi: 2,
    ZPNsPushSourceType.HuaWei: 3,
    ZPNsPushSourceType.Oppo: 4,
    ZPNsPushSourceType.FCM: 5,
    ZPNsPushSourceType.APNs: 10,
  };

  static const mapValue = {
    0: ZPNsPushSourceType.ZEGO,
    1: ZPNsPushSourceType.Vivo,
    2: ZPNsPushSourceType.XiaoMi,
    3: ZPNsPushSourceType.HuaWei,
    4: ZPNsPushSourceType.Oppo,
    5: ZPNsPushSourceType.FCM,
    10: ZPNsPushSourceType.APNs,
  };

  int get value => valueMap[this] ?? - 1;
}

extension ZPNsIOSBackgroundFetchResultExtension on ZPNsIOSBackgroundFetchResult {
  static const valueMap = {
    ZPNsIOSBackgroundFetchResult.NewData:0,
    ZPNsIOSBackgroundFetchResult.NoData:1,
    ZPNsIOSBackgroundFetchResult.Failed:2
  };

  static const mapValue = {
    0: ZPNsIOSBackgroundFetchResult.NewData,
    1: ZPNsIOSBackgroundFetchResult.NoData,
    2: ZPNsIOSBackgroundFetchResult.Failed
  };

  int get value => valueMap[this] ?? - 1;
}
