// lib/screens/ui_screen.dart (snippet)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/services/visual_style_service.dart';
import '/widgets/shared/visual_factory.dart';
import '/widgets/shared/nav_item.dart';

class UiScreen extends StatefulWidget {
  const UiScreen({super.key});
  @override
  State<UiScreen> createState() => _UiScreenState();
}

class _UiScreenState extends State<UiScreen> {
  int _selectedIndex = 0;

  final List<NavItem> _items = const [
    NavItem(icon: Icons.home, label: 'Home'),
    NavItem(icon: Icons.search, label: 'Search'),
    NavItem(icon: Icons.add_box, label: 'Create'),
    NavItem(icon: Icons.favorite, label: 'Faves'),
    NavItem(icon: Icons.settings, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final service = context.watch<VisualStyleService>();
final VisualFactory factory = service.factory;

final navRow = Row(
  children: List.generate(_items.length, (i) {
    final item = _items[i];
    final active = i == _selectedIndex;

    final icon = Icon(item.icon, color: factory.iconColor(active), size: 20);

    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        factory.buildIconContainer(
          context: context,
          child: icon,
          active: active,
        ),
        if (item.label != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              item.label!,
              style: TextStyle(color: factory.iconColor(active), fontSize: 10),
            ),
          ),
      ],
    );

    return factory.buildNavButton(
      context: context,
      child: child,
      active: active,
      onTap: () => setState(() => _selectedIndex = i),
    );
  }),
);
    return Scaffold(
      appBar: AppBar(title: const Text('UI Screen')),
      bottomNavigationBar: service.factory.buildNavBarShell(context: context, child: navRow),
      body: Center(child: Text('Page ${_selectedIndex + 1}')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // toggle style example: use a settings UI in production
          final next = service.current == VisualStyle.pixel ? VisualStyle.aesthetic : VisualStyle.pixel;
          context.read<VisualStyleService>().setStyle(next);
        },
        child: const Icon(Icons.swap_horiz),
      ),
    );
  }
}