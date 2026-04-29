import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../repositories/trading_repository.dart';

class PriceTicker extends StatefulWidget {
  const PriceTicker({super.key});

  @override
  State<PriceTicker> createState() => _PriceTickerState();
}

class _PriceTickerState extends State<PriceTicker> {
  Map<String, double> _prices = {};
  Map<String, double> _previousPrices = {};
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchPrices();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchPrices());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchPrices() async {
    final repo = context.read<TradingRepository>();
    final newPrices = await repo.getLivePrices();
    if (mounted) {
      setState(() {
        _previousPrices = Map.from(_prices);
        _prices = newPrices;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: _prices.entries.map((e) => _buildPriceItem(e.key, e.value)).toList(),
      ),
    );
  }

  Widget _buildPriceItem(String symbol, double price) {
    final prevPrice = _previousPrices[symbol] ?? price;
    final isUp = price >= prevPrice;
    final color = isUp ? Colors.greenAccent : Colors.redAccent;

    return Padding(
      padding: const EdgeInsets.only(right: 32.0),
      child: Row(
        children: [
          Text(
            symbol,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(width: 8),
          Text(
            price.toStringAsFixed(symbol.contains('JPY') ? 3 : 5),
            style: TextStyle(
              color: color,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(color: color.withValues(alpha: 0.5), blurRadius: 8),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: color,
            size: 20,
          ),
        ],
      ),
    );
  }
}
