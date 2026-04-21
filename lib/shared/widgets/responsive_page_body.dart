import 'package:flutter/material.dart';

class ResponsivePageBody extends StatelessWidget {
  const ResponsivePageBody({
    super.key,
    required this.child,
    this.maxWidth = 1120,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

class ResponsiveSplitColumns extends StatelessWidget {
  const ResponsiveSplitColumns({
    super.key,
    required this.leadingChildren,
    required this.trailingChildren,
    this.breakpoint = 1100,
    this.spacing = 20,
    this.leadingFlex = 6,
    this.trailingFlex = 5,
  });

  final List<Widget> leadingChildren;
  final List<Widget> trailingChildren;
  final double breakpoint;
  final double spacing;
  final int leadingFlex;
  final int trailingFlex;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= breakpoint;

    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _mergeForColumn(
          leadingChildren,
          trailingChildren,
          spacing,
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: leadingFlex,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _withSpacing(leadingChildren, spacing),
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          flex: trailingFlex,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _withSpacing(trailingChildren, spacing),
          ),
        ),
      ],
    );
  }

  List<Widget> _mergeForColumn(
    List<Widget> leading,
    List<Widget> trailing,
    double spacing,
  ) {
    final merged = <Widget>[...leading, ...trailing];
    return _withSpacing(merged, spacing);
  }

  List<Widget> _withSpacing(List<Widget> children, double spacing) {
    final spaced = <Widget>[];
    for (var index = 0; index < children.length; index++) {
      if (index > 0) {
        spaced.add(SizedBox(height: spacing));
      }
      spaced.add(children[index]);
    }
    return spaced;
  }
}

class ResponsiveWrapGrid extends StatelessWidget {
  const ResponsiveWrapGrid({
    super.key,
    required this.children,
    this.minItemWidth = 320,
    this.spacing = 12,
    this.runSpacing = 12,
  });

  final List<Widget> children;
  final double minItemWidth;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (children.isEmpty) {
          return const SizedBox.shrink();
        }

        final columnCount =
            ((constraints.maxWidth + spacing) / (minItemWidth + spacing))
                .floor()
                .clamp(1, children.length);
        final itemWidth = columnCount == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - (spacing * (columnCount - 1))) /
                columnCount;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children
              .map((child) => SizedBox(width: itemWidth, child: child))
              .toList(),
        );
      },
    );
  }
}
