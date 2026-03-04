import 'package:flutter/material.dart';

class AppSectionCard extends StatelessWidget {
    final List<Widget> children;

    const AppSectionCard({
        super.key,
        required this.children,
    });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);

        return Container(
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: theme.dividerColor.withOpacity(0.4),
                ),
            ),
            child: Column(
                children: List.generate(children.length, (index) {
                    return Column(
                        children: [
                            children[index],
                            if (index != children.length - 1)
                                Divider(
                                    height: 1,
                                    color: theme.dividerColor.withOpacity(0.4),
                                ),
                        ],
                    );
                }),
            ),
        );
    }
}