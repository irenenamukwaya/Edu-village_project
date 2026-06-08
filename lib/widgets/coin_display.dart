import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eduvillage/providers/coin_provider.dart';
import 'package:eduvillage/utils/helpers.dart';

/// Widget to display coin balance
// Shows the current coin total.
class CoinDisplay extends StatelessWidget {
  final double fontSize;
  final bool showLabel;

  const CoinDisplay({Key? key, this.fontSize = 18, this.showLabel = true})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CoinProvider>(
      builder: (context, coinProvider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.amber[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber[700]!, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.monetization_on, color: Colors.amber, size: 24),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showLabel)
                    Text(
                      'Coins',
                      style: TextStyle(
                        fontSize: fontSize * 0.7,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber[900],
                      ),
                    ),
                  Text(
                    AppHelpers.formatCoins(coinProvider.coins),
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[900],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
