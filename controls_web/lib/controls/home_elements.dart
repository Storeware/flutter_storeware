import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class ColumnScroll extends StatefulWidget {
  final List<Widget> children;
  final double spacing;
  ColumnScroll({Key key, this.spacing = 1, this.children}) : super(key: key);

  @override
  _ColumnScrollState createState() => _ColumnScrollState();
}

class _ColumnScrollState extends State<ColumnScroll> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (var item in widget.children)
        SingleChildScrollView(
          padding: EdgeInsets.only(bottom: widget.spacing),
          scrollDirection: Axis.horizontal,
          child: Container(child: item),
        ),
    ]);
  }
}

class RowScroll extends StatefulWidget {
  final List<Widget> children;
  final double spacing;
  RowScroll({this.children, this.spacing = 1});

  @override
  _RowScrollState createState() => _RowScrollState();
}

class _RowScrollState extends State<RowScroll> {
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (var item in widget.children)
        SingleChildScrollView(
          padding: EdgeInsets.only(right: widget.spacing),
          scrollDirection: Axis.vertical,
          child: Container(child: item),
        ),
    ]);
  }
}

class SliverContents extends StatefulWidget {
  final Widget appBar;
  final Widget sliverAppBar;
  final List<Widget> children;
  final List<Widget> grid;
  final List<Widget> slivers;
  final Widget body;
  final Widget bottonBar;
  final int crossAxisCount;
  final Axis scrollDirection;
  final int itemCount;
  final Function builder;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final List<Widget> topBars;
  final Widget toolBar;
  final double topBarsHeight;
  SliverContents(
      {Key key,
      this.children,
      this.appBar,
      this.toolBar,
      this.sliverAppBar,
      this.body,
      this.bottonBar,
      this.grid,
      this.itemCount = 0,
      this.topBars,
      this.topBarsHeight = 90,
      this.builder,
      this.crossAxisCount = 2,
      this.crossAxisSpacing = 2.0,
      this.mainAxisSpacing = 2.0,
      this.slivers,
      this.scrollDirection = Axis.vertical})
      : super(key: key);

  _SliverContentsState createState() => _SliverContentsState();
}

class _SliverContentsState extends State<SliverContents> {
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    if (widget.builder != null)
      for (var i = 0; i < widget.itemCount; i++) {
        items.add(widget.builder(i));
      }
    return CustomScrollView(scrollDirection: widget.scrollDirection, slivers: [
      if (widget.sliverAppBar != null) widget.sliverAppBar,
      SliverToBoxAdapter(
          child: Column(children: [
        if (widget.appBar != null) widget.appBar,
        if (widget.toolBar != null) widget.toolBar,
        if (widget.topBars != null)
          Container(
              height: widget.topBarsHeight,
              child: CustomScrollView(slivers: [
                for (var item in widget.topBars ?? [])
                  SliverToBoxAdapter(child: item)
              ], scrollDirection: Axis.horizontal)),
        widget.body ?? Container(),
        ...items ?? [],
        ...widget.children ?? []
      ])),
      ...(widget.slivers ?? []),
      widget.grid != null
          ? SliverGrid.count(
              crossAxisCount: widget.crossAxisCount,
              children: widget.grid,
              crossAxisSpacing: widget.crossAxisSpacing,
              mainAxisSpacing: widget.mainAxisSpacing,
            )
          : SliverToBoxAdapter(child: Container()),
      SliverToBoxAdapter(
        child: widget.bottonBar,
      ),
    ]);
  }
}

createBoxDecoration(
        {radius = 10.0,
        color = Colors.white,
        borderColor: Colors.grey,
        borderWidth = 0}) =>
    BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF656565).withOpacity(0.15),
            blurRadius: 4.0,
            spreadRadius: 1.0,
          )
        ]);

class ApplienceTile extends StatelessWidget {
  final Widget image;
  final String title;
  final TextStyle titleStyle;
  final Widget body;
  final double elevation;
  final String value;
  final TextStyle valueStyle;
  final Color color;
  final double titleFontSize;
  final double valueFontSize;
  final double height;
  final double width;
  final double top;
  final double left;
  final Widget appBar;
  final Widget bottomBar;
  final Widget topBar;
  final double dividerHeight;
  final Function onPressed;
  final padding;
  final borderWidth;
  final Widget chart;
  final textAlign;
  const ApplienceTile(
      {Key key,
      this.padding,
      this.color,
      this.top = 10,
      this.left = 10,
      this.title,
      this.textAlign = TextAlign.center,
      this.onPressed,
      this.titleStyle,
      this.titleFontSize = 16,
      this.value,
      this.valueStyle,
      this.valueFontSize = 48,
      this.image,
      this.borderWidth = 0,
      this.body,
      this.chart,
      this.appBar,
      this.topBar,
      this.bottomBar,
      this.elevation = 0.0,
      this.height,
      this.dividerHeight = 0,
      this.width})
      : super(key: key);

  static status(
      {padding,
      Widget image,
      String value,
      String title,
      Color color,
      double width}) {
    return ApplienceTile(
      padding: padding ?? EdgeInsets.only(right: 5),
      value: value,
      title: title,
      color: color,
      image: image,
      valueStyle: TextStyle(
          color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
      titleStyle: TextStyle(color: Colors.white, fontSize: 18),
      width: width,
    );
  }

  static panel(
      {padding,
      Widget image,
      String value,
      String title,
      Color color,
      double width,
      Function onPressed}) {
    return ApplienceTile(
      value: value,
      title: title,
      color: color,
      image: image,
      onPressed: onPressed,
      textAlign: TextAlign.end,
      padding: padding ?? EdgeInsets.only(right: 5),
      valueStyle: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.bold),
      titleStyle: TextStyle(color: Colors.white, fontSize: 14),
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<Widget> items = [];
    if (value != null)
      items.add(Text(value,
          textAlign: textAlign,
          style: valueStyle ??
              TextStyle(
                  color: theme.primaryColor,
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w200)));
    if (body != null) items.add(body);

    if (title != null)
      items.add(Text(title,
          textAlign: textAlign,
          style: titleStyle ??
              TextStyle(
                  fontFamily: 'Sans',
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w500)));

    return Container(
      padding: padding,
      decoration: createBoxDecoration(color: color, borderWidth: borderWidth),
      height: height,
      width: width,
      child: InkWell(
          onTap: onPressed,
          splashColor: Theme.of(context).primaryColor,
          child: Container(
              child: Stack(children: [
            Positioned(
              left: left,
              top: top,
              child: image ?? Container(),
            ),
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    appBar ?? Container(),
                    if (topBar != null) topBar,
                    if (dividerHeight > 0)
                      Container(
                        height: dividerHeight,
                        color: Colors.black54,
                        width: double.infinity,
                      ),
                    ...items,
                    bottomBar ?? Container()
                  ]),
            )
          ]))),
    );
  }
}

class ApplienceTicket extends StatelessWidget {
  final String title;
  final Color color;
  final Color fontColor;
  final IconData icon;
  final Widget image;
  final String value;
  final String subTitle;
  final double width;
  final double height;
  final double elevation;
  final Function onPressed;
  final double valueFontSize;
  const ApplienceTicket(
      {Key key,
      this.title = '',
      this.color,
      this.fontColor = Colors.white,
      this.onPressed,
      this.image,
      this.icon,
      this.value,
      this.valueFontSize = 28,
      this.width,
      this.height,
      this.elevation = 1,
      this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _tickets();
  }

  Widget _tickets() {
    return Card(
      elevation: elevation,
      child: Container(
        padding: EdgeInsets.all(22),
        color: color,
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (image != null) image,
                if (icon != null)
                  Icon(
                    icon,
                    size: 36,
                    color: fontColor,
                  ),
                if (title != null)
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      color: fontColor,
                      fontFamily: 'HelveticaNeue',
                    ),
                  )
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.end,
              //crossAxisAlignment: CrossAxisAlignment.end,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (value != null)
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: valueFontSize,
                      color: fontColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway',
                    ),
                  ),
                if (value != null)
                  SizedBox(
                    height: 8,
                  ),
                if (subTitle != null)
                  InkWell(
                      onTap: onPressed,
                      child: Text(
                        subTitle ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: fontColor,
                          // fontWeight: FontWeight.bold,
                          fontFamily: 'HelveticaNeue',
                        ),
                      ))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ApplienceStatus extends StatelessWidget {
  final EdgeInsets padding;
  final String value;
  final Color color;
  final String title;
  final double valueFontSize;
  final Color fontColor;
  final Function onPressed;
  final Widget image;
  final IconData icon;
  final double elevation;
  final Widget bottom;
  final double width;
  final double height;
  const ApplienceStatus(
      {Key key,
      this.padding,
      this.image,
      this.title,
      this.color = Colors.lightBlue,
      this.value,
      this.valueFontSize = 28,
      this.elevation = 1,
      this.fontColor = Colors.white,
      this.onPressed,
      this.icon,
      this.height,
      this.width,
      this.bottom})
      : super(key: key);

  static transparent(
      {String title,
      String value,
      double valueFontSize = 16,
      Color fontColor = Colors.white}) {
    return ApplienceStatus(
        elevation: 0,
        color: Colors.transparent,
        title: title,
        value: value,
        fontColor: fontColor,
        valueFontSize: valueFontSize);
  }

  @override
  Widget build(BuildContext context) {
    var pad = padding ?? const EdgeInsets.all(2);
    return Card(
      elevation: elevation,
      color: color,
      child: Container(
          width: width,
          height: height,
          padding: pad,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (image != null) image,
              if (icon != null)
                Icon(
                  icon,
                  size: 36,
                  color: fontColor,
                ),
              if (value != null)
                Text(
                  value,
                  style: TextStyle(
                    fontSize: valueFontSize,
                    color: fontColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway',
                  ),
                ),
              if (value != null)
                SizedBox(
                  height: 2,
                ),
              if (title != null)
                InkWell(
                    onTap: onPressed,
                    child: Text(
                      title ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: fontColor,
                        // fontWeight: FontWeight.bold,
                        fontFamily: 'HelveticaNeue',
                      ),
                    )),
              if (bottom != null) Expanded(child: Container()),
              if (bottom != null) bottom,
            ],
          )),
    );
  }
}

class ApplienceCards extends StatelessWidget {
  final List<Widget> children;
  final double elevation;
  final Color color;
  final Axis direction;
  final WrapAlignment alignment;
  final WrapCrossAlignment crossAxisAlignment;
  final double spacing;
  final double runSpacing;
  final WrapAlignment runAlignment;
  const ApplienceCards(
      {Key key,
      this.children,
      this.color = Colors.transparent,
      this.direction = Axis.horizontal,
      this.alignment = WrapAlignment.spaceAround,
      this.crossAxisAlignment = WrapCrossAlignment.start,
      this.runAlignment = WrapAlignment.spaceAround,
      this.spacing = 2,
      this.runSpacing = 2,
      this.elevation = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: direction,
      alignment: alignment,
      crossAxisAlignment: crossAxisAlignment,
      spacing: spacing,
      runAlignment: runAlignment,
      runSpacing: runSpacing,
      children: <Widget>[
        for (var item in children)
          Card(color: color, elevation: elevation, child: item)
      ],
    );
  }
}

class CarouselSlider extends StatefulWidget {
  CarouselSlider(
      {@required this.items,
      this.height,
      this.aspectRatio: 16 / 9,
      this.viewportFraction: 0.8,
      this.initialPage: 0,
      int realPage: 10000,
      this.enableInfiniteScroll: true,
      this.reverse: false,
      this.autoPlay: false,
      this.autoPlayInterval: const Duration(seconds: 4),
      this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
      this.autoPlayCurve: Curves.fastOutSlowIn,
      this.pauseAutoPlayOnTouch,
      this.enlargeCenterPage = false,
      this.onPageChanged,
      this.scrollPhysics,
      this.scrollDirection: Axis.horizontal})
      : this.realPage =
            enableInfiniteScroll ? realPage + initialPage : initialPage,
        this.pageController = PageController(
          viewportFraction: viewportFraction,
          initialPage:
              enableInfiniteScroll ? realPage + initialPage : initialPage,
        );

  /// The widgets to be shown in the carousel.
  final List<Widget> items;

  /// Set carousel height and overrides any existing [aspectRatio].
  final double height;

  /// Aspect ratio is used if no height have been declared.
  ///
  /// Defaults to 16:9 aspect ratio.
  final double aspectRatio;

  /// The fraction of the viewport that each page should occupy.
  ///
  /// Defaults to 0.8, which means each page fills 80% of the carousel.
  final num viewportFraction;

  /// The initial page to show when first creating the [CarouselSlider].
  ///
  /// Defaults to 0.
  final num initialPage;

  /// The actual index of the [PageView].
  ///
  /// This value can be ignored unless you know the carousel will be scrolled
  /// backwards more then 10000 pages.
  /// Defaults to 10000 to simulate infinite backwards scrolling.
  final num realPage;

  ///Determines if carousel should loop infinitely or be limited to item length.
  ///
  ///Defaults to true, i.e. infinite loop.
  final bool enableInfiniteScroll;

  /// Reverse the order of items if set to true.
  ///
  /// Defaults to false.
  final bool reverse;

  /// Enables auto play, sliding one page at a time.
  ///
  /// Use [autoPlayInterval] to determent the frequency of slides.
  /// Defaults to false.
  final bool autoPlay;

  /// Sets Duration to determent the frequency of slides when
  ///
  /// [autoPlay] is set to true.
  /// Defaults to 4 seconds.
  final Duration autoPlayInterval;

  /// The animation duration between two transitioning pages while in auto playback.
  ///
  /// Defaults to 800 ms.
  final Duration autoPlayAnimationDuration;

  /// Determines the animation curve physics.
  ///
  /// Defaults to [Curves.fastOutSlowIn].
  final Curve autoPlayCurve;

  /// Sets a timer on touch detected that pause the auto play with
  /// the given [Duration].
  ///
  /// Touch Detection is only active if [autoPlay] is true.
  final Duration pauseAutoPlayOnTouch;

  /// Determines if current page should be larger then the side images,
  /// creating a feeling of depth in the carousel.
  ///
  /// Defaults to false.
  final bool enlargeCenterPage;

  /// The axis along which the page view scrolls.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  /// Called whenever the page in the center of the viewport changes.
  final Function(int index) onPageChanged;

  /// How the carousel should respond to user input.
  ///
  /// For example, determines how the items continues to animate after the
  /// user stops dragging the page view.
  ///
  /// The physics are modified to snap to page boundaries using
  /// [PageScrollPhysics] prior to being used.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics scrollPhysics;

  /// [pageController] is created using the properties passed to the constructor
  /// and can be used to control the [PageView] it is passed to.
  final PageController pageController;

  /// Animates the controlled [CarouselSlider] to the next page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  Future<void> nextPage({Duration duration, Curve curve}) {
    return pageController.nextPage(duration: duration, curve: curve);
  }

  /// Animates the controlled [CarouselSlider] to the previous page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  Future<void> previousPage({Duration duration, Curve curve}) {
    return pageController.previousPage(duration: duration, curve: curve);
  }

  /// Changes which page is displayed in the controlled [CarouselSlider].
  ///
  /// Jumps the page position from its current value to the given value,
  /// without animation, and without checking if the new value is in range.
  void jumpToPage(int page) {
    final index =
        _getRealIndex(pageController.page.toInt(), realPage, items.length);
    return pageController
        .jumpToPage(pageController.page.toInt() + page - index);
  }

  /// Animates the controlled [CarouselSlider] from the current page to the given page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  Future<void> animateToPage(int page, {Duration duration, Curve curve}) {
    final index =
        _getRealIndex(pageController.page.toInt(), realPage, items.length);
    return pageController.animateToPage(
        pageController.page.toInt() + page - index,
        duration: duration,
        curve: curve);
  }

  @override
  _CarouselSliderState createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider>
    with TickerProviderStateMixin {
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = getTimer();
  }

  Timer getTimer() {
    return Timer.periodic(widget.autoPlayInterval, (_) {
      if (widget.autoPlay) {
        widget.pageController.nextPage(
            duration: widget.autoPlayAnimationDuration,
            curve: widget.autoPlayCurve);
      }
    });
  }

  void pauseOnTouch() {
    timer.cancel();
    timer = Timer(widget.pauseAutoPlayOnTouch, () {
      timer = getTimer();
    });
  }

  Widget getWrapper(Widget child) {
    if (widget.height != null) {
      final Widget wrapper = Container(height: widget.height, child: child);
      return widget.autoPlay && widget.pauseAutoPlayOnTouch != null
          ? addGestureDetection(wrapper)
          : wrapper;
    } else {
      final Widget wrapper =
          AspectRatio(aspectRatio: widget.aspectRatio, child: child);
      return widget.autoPlay && widget.pauseAutoPlayOnTouch != null
          ? addGestureDetection(wrapper)
          : wrapper;
    }
  }

  Widget addGestureDetection(Widget child) =>
      GestureDetector(onPanDown: (_) => pauseOnTouch(), child: child);

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return getWrapper(PageView.builder(
      physics: widget.scrollPhysics,
      scrollDirection: widget.scrollDirection,
      controller: widget.pageController,
      reverse: widget.reverse,
      itemCount: widget.enableInfiniteScroll ? null : widget.items.length,
      onPageChanged: (int index) {
        int currentPage = _getRealIndex(
            index + widget.initialPage, widget.realPage, widget.items.length);
        if (widget.onPageChanged != null) {
          widget.onPageChanged(currentPage);
        }
      },
      itemBuilder: (BuildContext context, int i) {
        final int index = _getRealIndex(
            i + widget.initialPage, widget.realPage, widget.items.length);

        return AnimatedBuilder(
          animation: widget.pageController,
          child: widget.items[index],
          builder: (BuildContext context, child) {
            // on the first render, the pageController.page is null,
            // this is a dirty hack
            if (widget.pageController.position.minScrollExtent == null ||
                widget.pageController.position.maxScrollExtent == null) {
              Future.delayed(Duration(microseconds: 1), () {
                setState(() {});
              });
              return Container();
            }
            double value = widget.pageController.page - i;
            value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);

            final double height = widget.height ??
                MediaQuery.of(context).size.width * (1 / widget.aspectRatio);
            final double distortionValue = widget.enlargeCenterPage
                ? Curves.easeOut.transform(value)
                : 1.0;

            if (widget.scrollDirection == Axis.horizontal) {
              return Center(
                  child:
                      SizedBox(height: distortionValue * height, child: child));
            } else {
              return Center(
                  child: SizedBox(
                      width:
                          distortionValue * MediaQuery.of(context).size.width,
                      child: child));
            }
          },
        );
      },
    ));
  }
}

/// Converts an index of a set size to the corresponding index of a collection of another size
/// as if they were circular.
///
/// Takes a [position] from collection Foo, a [base] from where Foo's index originated
/// and the [length] of a second collection Baa, for which the correlating index is sought.
///
/// For example; We have a Carousel of 10000(simulating infinity) but only 6 images.
/// We need to repeat the images to give the illusion of a never ending stream.
/// By calling _getRealIndex with position and base we get an offset.
/// This offset modulo our length, 6, will return a number between 0 and 5, which represent the image
/// to be placed in the given position.
int _getRealIndex(int position, int base, int length) {
  final int offset = position - base;
  return _remainder(offset, length);
}

/// Returns the remainder of the modulo operation [input] % [source], and adjust it for
/// negative values.
int _remainder(int input, int source) {
  final int result = input % source;
  return result < 0 ? source + result : result;
}

class ApplienceCarrousel extends StatefulWidget {
  final List<Widget> children;
  final bool enabled;
  final Color navColor;
  final bool autoPlay;
  final Function(int) onPageChanged;
  final double height;
  final double aspectRatio;
  final double viewportFraction;
  final int initialPage;
  final bool enableInfiniteScroll;
  final bool reverse;
  final Duration autoPlayInterval;
  final Duration autoPlayAnimationDuration;
  final Axis scrollDirection;
  /*
  final autoPlayCurve;
  final Duration pauseAutoPlayOnTouch;
  final bool enlargeCenterPage;
  */
  ApplienceCarrousel(
      {Key key,
      this.children,
      this.enabled = true,
      this.navColor,
      this.onPageChanged,
      this.autoPlay = true,
      this.height,
      this.aspectRatio: 16 / 9,
      this.viewportFraction: 0.8,
      this.initialPage: 0,
      this.enableInfiniteScroll: true,
      this.reverse: false,
      this.autoPlayInterval: const Duration(seconds: 4),
      this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
      this.scrollDirection: Axis.horizontal
      /*
      this.autoPlayCurve = Curves.fastOutSlowIn,
      this.pauseAutoPlayOnTouch,
      this.enlargeCenterPage = false,
      this.scrollPhysics,
      */
      })
      : super(key: key);

  @override
  _ApplienceCarrouselState createState() => _ApplienceCarrouselState();
}

class _ApplienceCarrouselState extends State<ApplienceCarrousel> {
  @override
  Widget build(BuildContext context) {
    CarouselSlider carrousel = CarouselSlider(
      autoPlay: widget.autoPlay,
      items: widget.children,
      onPageChanged: widget.onPageChanged,
      aspectRatio: widget.aspectRatio,
      autoPlayAnimationDuration: widget.autoPlayAnimationDuration,
      autoPlayInterval: widget.autoPlayInterval,
      height: widget.height,
      initialPage: widget.initialPage,
      reverse: widget.reverse,
      scrollDirection: widget.scrollDirection,
    );
    var size = MediaQuery.of(context).size;
    return Row(
      children: [
        if (widget.enabled)
          InkWell(
            child: Container(
                color: widget.navColor,
                height: size.height,
                width: 18,
                child: Icon(
                  Icons.keyboard_arrow_left,
                  size: 18,
                )),
            onTap: () => carrousel.previousPage(
                duration: Duration(milliseconds: 300), curve: Curves.linear),
          ),
        Expanded(child: carrousel),
        if (widget.enabled)
          InkWell(
            child: Container(
                color: widget.navColor,
                height: size.height,
                width: 18,
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 18,
                )),
            onTap: () => carrousel.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.linear),
          ),
      ],
    );
  }
}

class ApplienceTimeline extends StatelessWidget {
  final Widget leadding;
  final Widget body;
  final Widget actions;
  final Color color;
  final double height;
  final double width;
  final Color tagColor;
  const ApplienceTimeline({
    Key key,
    this.height = 90,
    this.width,
    this.color,
    this.leadding,
    this.body,
    this.actions,
    this.tagColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        color: color,
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: leadding ??
                  Container(width: 5, color: tagColor ?? Colors.red),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: body,
            )),
            if (actions != null) actions,
          ],
        ));
  }
}

class ApplienceTag extends StatelessWidget {
  final double height;
  final String title;
  final String value;
  final List<Widget> children;
  final Color tagColor;
  final double tagWidth;
  final double tagHeight;
  final List<Widget> tagChildren;
  final double width;
  final Icon icon;
  final Widget actions;
  const ApplienceTag({
    Key key,
    this.title,
    this.value,
    this.children,
    this.tagColor = Colors.blue,
    this.tagWidth = 5,
    this.tagHeight,
    this.height: 90,
    this.width,
    this.icon,
    this.actions,
    this.tagChildren,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ApplienceTimeline(
      height: height,
      width: width,
      leadding: Stack(
        children: <Widget>[
          if (tagWidth > 0)
            Container(
              width: tagWidth,
              height: tagHeight,
              color: tagColor,
            ),
          if (icon != null) Center(child: icon),
          ...tagChildren ?? [],
        ],
      ),
      body: Column(
        children: <Widget>[
          if (title != null)
            Text(title ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                )),
          if (value != null)
            SizedBox(
              height: 10,
            ),
          if (value != null)
            Text(value ?? '',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                )),
          ...children ?? [],
        ],
      ),
      actions: actions,
    );
  }
}

class ApplienceReport extends StatelessWidget {
  final Widget title;
  final Widget footer;
  final Color color;
  final double width;
  final double height;
  final Widget body;
  final double divider;
  final double elevation;
  final Alignment alignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  const ApplienceReport(
      {Key key,
      this.title,
      this.body,
      this.footer,
      this.divider = 1,
      this.elevation = 1,
      this.width = 180,
      this.alignment = Alignment.centerLeft,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.height,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      child: Container(
        width: width,
        height: height,
        color: color,
        alignment: alignment,
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          children: <Widget>[
            if (title != null) ...[
              title,
              if (divider > 0)
                Divider(
                  height: divider,
                )
            ],
            if (body != null) body,
            if (footer != null) ...[
              if (divider > 0)
                Divider(
                  height: divider,
                ),
              footer
            ],
          ],
        ),
      ),
    );
  }
}
