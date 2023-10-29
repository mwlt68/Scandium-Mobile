import 'package:easy_localization/easy_localization.dart';
import 'package:scandium/product/constants/application_constants.dart';

extension StringLocalization on String {
  String get lcl => this.tr();
}

extension StringListLocalization on List<String> {
  String getApiMessages() {
    return map((key) {
      var localizedKey = ApplicationConstants.instance.localizationApiKey + key;
      var result = localizedKey.tr();
      return result;
    }).join('\n');
  }
}
