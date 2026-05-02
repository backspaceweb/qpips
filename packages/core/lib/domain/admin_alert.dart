/// Admin-visible alert from the `admin_alerts` Supabase table.
///
/// Today the only writer is the hourly `check_capacity_alerts()` cron,
/// which inserts rows when slot utilization crosses 80% (warning) or
/// 95%/over-sold (critical). New alert kinds will land here as the
/// platform grows (failed renewals, expired API keys, etc.) without
/// changing the consumer side — the Plans tab banner just renders
/// whatever's un-dismissed.
class AdminAlert {
  final String id;
  final String kind;
  final AlertSeverity severity;
  final String message;
  final Map<String, dynamic>? payload;
  final DateTime createdAt;
  final DateTime? dismissedAt;
  final String? dismissedBy;

  const AdminAlert({
    required this.id,
    required this.kind,
    required this.severity,
    required this.message,
    required this.payload,
    required this.createdAt,
    required this.dismissedAt,
    required this.dismissedBy,
  });

  bool get isDismissed => dismissedAt != null;

  factory AdminAlert.fromJson(Map<String, dynamic> json) => AdminAlert(
        id: json['id'] as String,
        kind: json['kind'] as String,
        severity: AlertSeverity.fromString(json['severity'] as String),
        message: json['message'] as String,
        payload: json['payload'] as Map<String, dynamic>?,
        createdAt: DateTime.parse(json['created_at'] as String),
        dismissedAt: json['dismissed_at'] == null
            ? null
            : DateTime.parse(json['dismissed_at'] as String),
        dismissedBy: json['dismissed_by'] as String?,
      );
}

enum AlertSeverity {
  info('info'),
  warning('warning'),
  critical('critical');

  final String wireValue;
  const AlertSeverity(this.wireValue);

  static AlertSeverity fromString(String s) =>
      AlertSeverity.values.firstWhere(
        (v) => v.wireValue == s,
        orElse: () => AlertSeverity.info,
      );
}
