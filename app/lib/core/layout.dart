import 'package:material_ui/material_ui.dart';

enum WindowSize { compact, medium, expanded }

extension WindowSizeX on BuildContext {
  WindowSize get windowSize {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= 1200) return WindowSize.expanded;
    if (width >= 600) return WindowSize.medium;
    return WindowSize.compact;
  }

  bool get largeText => MediaQuery.textScalerOf(this).scale(16) > 16 * 1.3;
}

const chatColumnWidth = 760.0;
const sidePanelWidth = 400.0;

class ResponsiveWrap extends StatelessWidget {
  const ResponsiveWrap({
    super.key,
    required this.children,
    this.minItemWidth = 300,
    this.maxColumns = 3,
    this.spacing = 12,
  });

  final List<Widget> children;
  final double minItemWidth;
  final int maxColumns;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final columns = ((c.maxWidth + spacing) / (minItemWidth + spacing)).floor().clamp(
          1,
          maxColumns,
        );
        final itemWidth = (c.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [for (final child in children) SizedBox(width: itemWidth, child: child)],
        );
      },
    );
  }
}
