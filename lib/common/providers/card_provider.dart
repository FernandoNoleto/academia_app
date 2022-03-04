import 'package:flutter/material.dart';

class CardProvider extends StatefulWidget {
  final Widget title;
  final Widget subtitle;
  final VoidCallback? onTap;
  final Widget? logo;
  final Color? tileColor;
  final Color? borderColor;
  final Widget? trailing;

  const CardProvider(
      {Key? key,
        required this.title,
        required this.subtitle,
        this.onTap,
        this.logo,
        this.tileColor,
        this.borderColor,
        this.trailing,
      }) : super(key: key);

  @override
  _CardProviderState createState() => _CardProviderState();
}

class _CardProviderState extends State<CardProvider> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: widget.borderColor ?? Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: widget.logo ?? const FlutterLogo(size: 32.0),
        tileColor: widget.tileColor,
        title: widget.title,
        subtitle: widget.subtitle,
        onTap: widget.onTap,
        trailing: widget.trailing,
      ),
    );
  }
}