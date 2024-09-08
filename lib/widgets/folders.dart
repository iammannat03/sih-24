import 'package:flutter/material.dart';
import 'package:spynetra_tmp/constants/constants.dart';

//this is the folder icon customisation..
class FolderIcon extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final double iconSize;

  const FolderIcon({
    super.key,
    required this.text,
    required this.onTap,
    required this.iconSize,
  });

  @override
  FolderIconState createState() => FolderIconState();
}

class FolderIconState extends State<FolderIcon> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder,
              size: widget.iconSize,
              color: _isHovering ? Pallete.hover : Pallete.folder,
            ),
            const SizedBox(height: 4.0),
            Text(
              widget.text,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
