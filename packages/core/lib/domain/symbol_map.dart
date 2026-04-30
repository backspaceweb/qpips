/// Symbol mapping types accepted by the trading server's `symbol_map_*`
/// endpoints. The server's OpenAPI docstring states:
///   "type — The mapping type ('Suffix' or 'Special')."
///
/// - `suffix`  → for cross-broker symbol differences (e.g. master broker
///                uses `EURUSD`, slave broker uses `EURUSD.x`)
/// - `special` → for distinct symbol pairs that don't follow a suffix
///                pattern (manual override per symbol)
enum SymbolMapType {
  suffix,
  special;

  String get wireValue => this == SymbolMapType.suffix ? 'Suffix' : 'Special';

  String get label => this == SymbolMapType.suffix ? 'Suffix' : 'Special';
}
