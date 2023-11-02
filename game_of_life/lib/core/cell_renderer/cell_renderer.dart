import 'package:flutter/material.dart';

import '../../domain_layer/entries/cell.dart';
import '../constants/colors.dart';

abstract class CellRenderer {
  Widget render(Cell cell);
}

class NormalBorderCellRenderer implements CellRenderer {
  @override
  Widget render(Cell cell) {
    return Container(
      decoration: BoxDecoration(
        color: cell.isAlive == true ? kPrimaryColor : kBackgroundColor,
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 0.5,
        ),
      ),
    );
  }
}

class PrimaryColorCellRenderer implements CellRenderer {
  @override
  Widget render(Cell cell) {
    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: cell.isAlive == true ? kPrimaryColor : kBackgroundColor,
        border: Border.all(
          color: kPrimaryColor.withOpacity(0.5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}

class NoBorderCellRenderer implements CellRenderer {
  @override
  Widget render(Cell cell) {
    return Container(
      decoration: BoxDecoration(
        color: cell.isAlive == true ? kPrimaryColor : kBackgroundColor,
      ),
    );
  }
}
