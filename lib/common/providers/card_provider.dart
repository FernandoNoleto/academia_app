import 'package:flutter/material.dart';

class CardProvider extends StatefulWidget {
  final Widget title;
  final Widget subtitle;
  final VoidCallback? onTap;
  final Widget? logo;

  const CardProvider(
      {Key? key,
        required this.title,
        required this.subtitle,
        this.onTap,
        this.logo
      }) : super(key: key);

  @override
  _CardProviderState createState() => _CardProviderState();
}

class _CardProviderState extends State<CardProvider> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: widget.logo ?? const FlutterLogo(size: 72.0),
        title: widget.title,
        subtitle: widget.subtitle,
        onTap: widget.onTap,
      ),
    );
  }
}