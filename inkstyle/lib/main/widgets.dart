import 'package:flutter/material.dart';


class DecisionIndicator extends StatelessWidget {
    final bool liked;
    final double width;
    final double borderRadius;

    const DecisionIndicator({super.key, required this.liked, required this.width, required this.borderRadius});

    @override
    Widget build(BuildContext context) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
                width: width,
                height: width,
                color: liked ? Colors.green[200] : Colors.red[200],
            )
        );
    }
}


class NullDecisionIndicator extends StatelessWidget {
    final double width;
    final double borderRadius;

    const NullDecisionIndicator({super.key, required this.width, required this.borderRadius});

    @override
    Widget build(BuildContext context) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
                width: width,
                height: width,
                color: Colors.grey,
            )
        );
    }
}

class Decisions extends StatelessWidget {
    final List<dynamic> decisions;
    final int batchSize;
    final double decisionIndicatorWidth;
    final double decisionIndicatorBorderRadius;
    final double spacerWidth;

    const Decisions(
        {
            super.key,
            required this.decisions,
            required this.batchSize,
            required this.decisionIndicatorWidth,
            required this.decisionIndicatorBorderRadius,
            required this.spacerWidth
        }
    );

    @override
      Widget build(BuildContext context) {
        return Row(
            mainAxisSize: MainAxisSize.min,
          children: List.generate(
            decisions.length,
            (index) {
              final isLast = (index == decisions.length - 1);
              return Row(
                children: [
                    decisions[index] == null
                    ? NullDecisionIndicator(
                    width: decisionIndicatorWidth,
                    borderRadius: decisionIndicatorBorderRadius,
                    )
                  : DecisionIndicator(
                    liked: decisions[index].liked,
                    width: decisionIndicatorWidth,
                    borderRadius: decisionIndicatorBorderRadius,
                    ),
                  if (!isLast) SizedBox(width: spacerWidth),
                ],
              );
            },
          ),
        );
      }
}
