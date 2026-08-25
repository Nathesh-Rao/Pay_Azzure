import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/db/offline_db_constants.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';

const String _tag = '[OFFLINE_CONFIG]';

const int kDefaultSyncInterval = 15;
const int kDefaultCachedBatchSize = 30;

class OfflineConfigService {
  OfflineConfigService._();
  static String _configUrl = OfflineDBConstants.OFFLINE_CONFIG_URL();

  static Future<void> fetchAndStore() async {
    try {
      final response = await http
          .get(Uri.parse(_configUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200 || response.body.isEmpty) {
        await LogService.writeLog(
            message:
                '$_tag Fetch failed — HTTP ${response.statusCode}. Using fallback: ${kDefaultSyncInterval}min.');
        _useFallback();
        return;
      }

      final Map<String, dynamic> json = jsonDecode(response.body);
      await LogService.writeLog(
          message:
              '$_tag Fetch success — HTTP ${response.statusCode}. ${json.toString()}');

      final int interval =
          (json[AppStorage.OFFLINE_SYNC_INTERVAL] as num?)?.toInt() ??
              kDefaultSyncInterval;
      final int batchSize =
          (json[AppStorage.CACHED_BATCH_SIZE] as num?)?.toInt() ??
              kDefaultCachedBatchSize;
      AppStorage().storeValue(AppStorage.OFFLINE_SYNC_INTERVAL, interval);
      AppStorage().storeValue(AppStorage.CACHED_BATCH_SIZE, batchSize);

      log('$_tag interval=${interval}min.', name: _tag);
      log('$_tag batchSize=${batchSize} nos.', name: _tag);
      return;
    } catch (e) {
      await LogService.writeLog(
          message:
              '$_tag Fetch error: $e. Using fallback: ${kDefaultSyncInterval}min.');
      _useFallback();
      return;
    }
  }

  static int getCachedInterval() {
    final dynamic stored =
        AppStorage().retrieveValue(AppStorage.OFFLINE_SYNC_INTERVAL);
    if (stored == null) return kDefaultSyncInterval;
    return int.tryParse(stored.toString()) ?? kDefaultSyncInterval;
  }

  static int getCachedBatchSize() {
    final dynamic stored =
        AppStorage().retrieveValue(AppStorage.CACHED_BATCH_SIZE);

    log(stored.toString(), name: "cached_batch_size");
    if (stored == null) return kDefaultCachedBatchSize;
    return int.tryParse(stored.toString()) ?? kDefaultCachedBatchSize;
  }

  static _useFallback() {
    final int cached = getCachedInterval();
    final int cachedBatchSize = getCachedBatchSize();
    AppStorage().storeValue(AppStorage.OFFLINE_SYNC_INTERVAL, cached);
    AppStorage().storeValue(AppStorage.CACHED_BATCH_SIZE, cachedBatchSize);
  }
}
