/// Hardcoded broker list for the Add Account form's broker typeahead.
///
/// Server names are NOT carried here — the trader types them in
/// manually for any broker. Server-name patterns drift too fast across
/// brokers (Exness alone has dozens of regional MT5 servers that change
/// with KYC region) for a hardcoded list to stay reliable.
///
/// "Other" / manual broker name entry is also supported — see
/// `AddAccountDialog._BrokerTypeahead`.
class BrokerConfig {
  final String id;
  final String displayName;

  const BrokerConfig({required this.id, required this.displayName});
}

const List<BrokerConfig> supportedBrokers = [
  BrokerConfig(id: 'exness', displayName: 'Exness'),
  BrokerConfig(id: 'ic_markets', displayName: 'IC Markets'),
  BrokerConfig(id: 'pepperstone', displayName: 'Pepperstone'),
  BrokerConfig(id: 'fp_markets', displayName: 'FP Markets'),
  BrokerConfig(id: 'tickmill', displayName: 'Tickmill'),
  BrokerConfig(id: 'vantage', displayName: 'Vantage'),
];

/// Filter by case-insensitive substring match on display name. Used by
/// the Add Account form's broker typeahead. Returns alphabetical results
/// regardless of input order.
List<BrokerConfig> filterBrokers(String query) {
  final q = query.trim().toLowerCase();
  final filtered = q.isEmpty
      ? List<BrokerConfig>.from(supportedBrokers)
      : supportedBrokers
          .where((b) => b.displayName.toLowerCase().contains(q))
          .toList();
  filtered.sort(
    (a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()),
  );
  return filtered;
}
