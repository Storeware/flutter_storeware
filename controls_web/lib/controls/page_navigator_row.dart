import 'package:flutter/material.dart';

class PageNavigatorRow extends StatelessWidget {
  final Function(int)? onPageSelected;
  final int? currentPage;
  final double? height;
  final double? width;
  final int? count;

  const PageNavigatorRow(
      {Key? key,
      this.height = kBottomNavigationBarHeight,
      this.count = 4,
      this.width,
      this.onPageSelected,
      this.currentPage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return createPageNavigator();
  }

  createPageNavigator() {
    if (onPageSelected == null) return null;
    int n = 0;
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Container(
        height: height,
        width: width ?? double.maxFinite,
        child: Align(
          alignment: Alignment.centerLeft,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            createNavButton(1),
            for (var i = currentPage! - 1; i < currentPage! + count!; i++)
              if (i > 1)
                if ((n++) < count!) createNavButton(i)
          ]),
        ),
      ),
    );
  }

  Widget createNavButton(int i) {
    return (currentPage == i)
        ? CircleAvatar(
            radius: 15,
            backgroundColor: Colors.grey.withOpacity(0.3),
            child: Text('$i'),
          )
        : IconButton(
            icon: Text('$i'),
            onPressed: () {
              onPageSelected!(i);
            },
          );
  }
}
