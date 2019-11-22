import 'package:flutter/material.dart';

enum MainImagePosition { left, rigth, top, bottom }

class ShoppingPage extends StatelessWidget {
  final appBar;
  final List<Widget> topBars;
  final Widget body;
  final List<Widget> children;
  final List<Widget> grid;
  final List<Widget> bottomBars;
  final double topBarsHeight;
  final EdgeInsetsGeometry padding;
  const ShoppingPage(
      {Key key,
      this.appBar,
      this.topBars,
      this.padding,
      this.topBarsHeight = 90,
      this.body,
      this.children,
      this.grid,
      this.bottomBars})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int cols = MediaQuery.of(context).size.width ~/ 150;
    if (cols < 2) cols = 2;
    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: CustomScrollView(
        slivers: <Widget>[
          if (appBar != null) appBar,
          if (topBars != null)
            SliverToBoxAdapter(
                child: Container(
                    height: topBarsHeight,
                    child: CustomScrollView(slivers: [
                      for (var item in topBars ?? [])
                        SliverToBoxAdapter(child: item)
                    ], scrollDirection: Axis.horizontal))),
          if (body != null) SliverToBoxAdapter(child: body),
          SliverList(
            delegate: SliverChildListDelegate(
              [for (var item in children ?? []) item],
            ),
          ),
          SliverGrid.count(
            crossAxisCount: cols,
            children: grid ?? [],
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [for (var item in bottomBars ?? []) item],
            ),
          ),
        ],
      ),
    );
  }
}

class ShoppingCategory extends StatelessWidget {
  final String title;
  final String id;
  final Color color;
  final Function(String) onPressed;
  const ShoppingCategory(
      {Key key, this.id, this.color, this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          padding: EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: color),
          alignment: Alignment.center,
          constraints: BoxConstraints(minWidth: 80, minHeight: 20),
          child: Text(title),
        ),
        onTap: () {
          onPressed(id);
        });
  }
}

class ShoppingView extends StatelessWidget {
  final List<Widget> children;
  final Color color;
  const ShoppingView({Key key, this.color, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: color,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            if (children != null)
              for (var item in children)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 1, right: 1, top: 5, bottom: 5),
                  child: item,
                )
          ],
        ));
  }
}

class ShoppingTile extends StatelessWidget {
  final String id;
  final MainImagePosition position;
  final Widget image;
  final String title;
  final String subTitle;
  final String price;
  final double rank;
  final double stars;
  final Function(String) onPressed;
  final double width;
  final double elevation;
  final Color color;
  const ShoppingTile({
    Key key,
    this.position = MainImagePosition.left,
    this.width,
    this.elevation = 1,
    this.color,
    this.title,
    this.subTitle,
    this.price,
    this.onPressed,
    this.id,
    this.rank,
    this.stars = 0,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _stars = (stars > 0)
        ? Icon(
            Icons.stars,
            size: 14,
          )
        : Container();
    var size = MediaQuery.of(context).size;
    var _width = width ?? size.width;
    var csize = _width * 2 / 3;
    return Card(
      elevation: elevation,
      child: InkWell(
          child: Container(
            color: color,
            width: width,
            padding: EdgeInsets.all(5),
            child: (position == MainImagePosition.left ||
                    position == MainImagePosition.rigth)
                ? Row(
                    children: <Widget>[
                      if (position == MainImagePosition.left)
                        Container(
                          child: image ?? Container(),
                        ),
                      if (position == MainImagePosition.left)
                        SizedBox(
                          width: 10,
                        ),
                      Expanded(
                          child: _ShoppingDiscriptions(
                              csize: csize,
                              title: title,
                              subTitle: subTitle,
                              rank: rank,
                              stars: _stars,
                              price: price,
                              onPressed: onPressed,
                              id: id)),
                      if (position == MainImagePosition.rigth)
                        SizedBox(
                          width: 10,
                        ),
                      if (position == MainImagePosition.rigth)
                        Container(
                          child: image ?? Container(),
                        ),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      if (position == MainImagePosition.top)
                        Container(
                          child: image ?? Container(),
                        ),
                      if (position == MainImagePosition.top)
                        SizedBox(
                          height: 10,
                        ),
                      _ShoppingDiscriptions(
                          csize: size.width,
                          title: title,
                          subTitle: subTitle,
                          rank: rank,
                          stars: _stars,
                          price: price,
                          onPressed: onPressed,
                          id: id),
                      if (position == MainImagePosition.bottom)
                        SizedBox(
                          height: 10,
                        ),
                      if (position == MainImagePosition.bottom)
                        Container(
                          child: image ?? Container(),
                        ),
                    ],
                  ),
          ),
          onTap: () {
            onPressed(id);
          }),
    );
  }
}

class _ShoppingDiscriptions extends StatelessWidget {
  const _ShoppingDiscriptions({
    Key key,
    @required this.csize,
    @required this.title,
    @required this.subTitle,
    @required this.rank,
    @required StatelessWidget stars,
    @required this.price,
    @required this.onPressed,
    @required this.id,
  })  : _stars = stars,
        super(key: key);

  final double csize;
  final String title;
  final String subTitle;
  final double rank;
  final StatelessWidget _stars;
  final String price;
  final Function(String) onPressed;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      children: <Widget>[
        Container(
          width: csize - 20,
          child: Text(
            title ?? '',
            maxLines: 2,
            softWrap: true,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: csize - 20,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            if (subTitle != null)
              Text(
                subTitle,
                maxLines: 2,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
              ),
            if (rank != null)
              Row(children: [
                Text(
                  '$rank',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
                ),
                _stars
              ]),
          ]),
        ),
        Container(
          width: csize - 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(price ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
              if (onPressed != null)
                InkWell(
                    child: Container(
                      child: Icon(Icons.plus_one, size: 22),
                    ),
                    onTap: () {
                      onPressed(id);
                    })
            ],
          ),
        )
      ],
    );
  }
}
