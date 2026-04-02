import 'package:flutter/material.dart';

class SettingsExpansionTile extends StatefulWidget {
  const SettingsExpansionTile({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.children,
    this.initiallyExpanded = false,
    this.isSubItem = false,
  });

  final String title;
  final IconData leadingIcon;
  final List<Widget> children;
  final bool initiallyExpanded;
  final bool isSubItem;

  @override
  State<SettingsExpansionTile> createState() => _SettingsExpansionTileState();
}

class _SettingsExpansionTileState extends State<SettingsExpansionTile> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isSubItem
        ? const Color(0xFFDCE8DE)
        : const Color(0xFF1B5E20);

    return Container(
      margin: EdgeInsets.only(bottom: widget.isSubItem ? 10 : 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget.isSubItem ? 14 : 18),
        border: Border.all(color: borderColor, width: widget.isSubItem ? 1 : 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          initiallyExpanded: widget.initiallyExpanded,
          onExpansionChanged: (value) => setState(() => _isExpanded = value),
          leading: Icon(
            widget.leadingIcon,
            size: 20,
            color: widget.isSubItem ? const Color(0xFF1F1F1F) : const Color(0xFF1B5E20),
          ),
          title: Text(
            widget.title,
            style: TextStyle(
              color: const Color(0xFF1B1B1B),
              fontWeight: widget.isSubItem ? FontWeight.w600 : FontWeight.w700,
              fontSize: widget.isSubItem ? 14 : 16,
            ),
          ),
          trailing: Icon(
            _isExpanded ? Icons.expand_more : Icons.chevron_right,
            color: const Color(0xFF1B1B1B),
          ),
          children: widget.children,
        ),
      ),
    );
  }
}
