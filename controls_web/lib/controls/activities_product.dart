import 'activities.dart';
import 'package:flutter/material.dart';

class ActivityProductDetail extends StatefulWidget {
  final Widget image;
  final double height;
  final String title;
  final String subTitle;
  final Widget favorite;
  final Widget child;
  final double price;
  final Color color;
  final Color textColor;
  final List<Widget> actions;
  final double priceFrom;
  final double qtyFrom;
  final String id;
  final String unit;
  final double initialQty;

  final List<Widget> items;
  final Function(String, double) onBuyPressed;
  const ActivityProductDetail({
    Key key,
    this.actions,
    this.image,
    this.subTitle,
    this.title,
    this.favorite,
    this.child,
    this.price = 0,
    this.color,
    this.priceFrom = 0,
    this.qtyFrom = 0,
    this.items,
    this.initialQty = 1,
    @required this.onBuyPressed,
    @required this.id,
    this.unit,
    this.textColor,
    this.height,
  }) : super(key: key);

  @override
  _ActivityProductDetailState createState() => _ActivityProductDetailState();
}

class _ActivityProductDetailState extends State<ActivityProductDetail> {
  TextEditingController _qtde = TextEditingController();

  @override
  void initState() {
    _qtde.text = widget.initialQty.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    ThemeData theme = Theme.of(context);
    return Column(
      children: <Widget>[
        if (widget.image != null) widget.image,
        (widget.title != null)
            ? Text(widget.title ?? '',
                style: TextStyle(
                  fontSize: 20,
                  color: widget.textColor ?? Colors.white.withAlpha(250),
                ))
            : Container(),
        (widget.subTitle != null)
            ? Text(widget.subTitle,
                style: TextStyle(
                  fontSize: 16,
                  color: widget.textColor ?? Colors.white,
                ))
            : Container(),
        ActivityPanel(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (widget.favorite != null) buildFavorities(),
              if (widget.unit != null)
                ActivityButton(
                  title: widget.unit,
                ),
              ...(widget.actions ?? []),
              Expanded(child: Container(child: widget.child)),
              if (widget.priceFrom > 0)
                ActivityButton(
                  image: Text(
                      'de ${widget.priceFrom.toString().replaceAll('.', ',')}',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      )),
                  title: 'por',
                ),
              if ((widget.price ?? 0) > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ShowPriceWidget(
                    precovenda: widget.price,
                    //showDescript: false,
                  ),
                )
            ],
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          ActivityBuyButton(
            color: Colors.indigo,
            textColor: Colors.white,
            initialValue: 1,
            onQtdePressed: (qtde) {
              widget.onBuyPressed(widget.id, qtde);
            },
          )
        ]),
        SizedBox(
          height: 20,
        ),
        ...widget.items ?? []
      ],
    );
  }

  buildFavorities() => widget.favorite;
}

class ActivityBuyButton extends StatefulWidget {
  final Function(double) onQtdePressed;
  final double initialValue;
  final Color color;
  final Color textColor;
  final String label;
  const ActivityBuyButton({
    Key key,
    this.initialValue = 1,
    this.color,
    @required this.onQtdePressed,
    this.textColor,
    this.label,
  }) : super(key: key);

  @override
  _ActivityBuyButtonState createState() => _ActivityBuyButtonState();
}

class _ActivityBuyButtonState extends State<ActivityBuyButton> {
  final TextEditingController _qtde = TextEditingController();

  @override
  void initState() {
    xQtde = widget.initialValue ?? 1;
    _qtde.text = xQtde.toString();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color captionColor = widget.color ?? theme.primaryColor;
    return ActivityPanel(
        width: 240,
        height: 45,
        color: widget.color ?? theme.primaryColor,
        child: Row(
          children: <Widget>[
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 6,
                  top: 6,
                  bottom: 6,
                  right: 1,
                ),
                child: Container(
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        )),
                    child: Center(
                        child: Text('-',
                            style: TextStyle(
                                color: captionColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)))),
              ),
              onTap: () {
                somar(-1);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 0,
                right: 0,
                top: 6,
                bottom: 6,
              ),
              child: Container(
                color: Colors.white,
                width: 40,
                alignment: Alignment.center,
                child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: captionColor, fontWeight: FontWeight.bold),
                  controller: _qtde,
                ),
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 6, left: 1),
                child: Container(
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        )),
                    child: Center(
                        child: Text('+',
                            style: TextStyle(
                                color: captionColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)))),
              ),
              onTap: () {
                somar(1);
              },
            ),
            Expanded(
              child: MaterialButton(
                //visualDensity: VisualDensity.compact,
                child: Center(
                    child: Text(widget.label ?? 'comprar',
                        style: TextStyle(
                          color:
                              widget.textColor ?? theme.textTheme.caption.color,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ))),
                onPressed: () {
                  widget.onQtdePressed(somar(0));
                },
              ),
            )
          ],
        ));
  }

  double xQtde = 1;
  somar(double value) {
    var d = double.tryParse(_qtde.text.replaceAll(',', '.'));
    d += value;
    if (d < 0) d = 0;
    xQtde = d;
    _qtde.text = d.toStringAsFixed(0);
    setState(() {});
    return d;
  }
}

class ShowPriceWidget extends StatelessWidget {
  const ShowPriceWidget({
    Key key,
    this.simbol = 'R\$',
    this.fontSize = 18,
    @required this.precovenda,
    this.decimais = 2,
    //@required this.showDescript,
  }) : super(key: key);

  final double precovenda;
  //final bool showDescript;
  final String simbol;
  final double fontSize;
  final int decimais;

  @override
  Widget build(BuildContext context) {
    var minFontSize = (fontSize / 2);
    if (minFontSize < 10) minFontSize = 10;
    var partes = '${precovenda.toStringAsFixed(decimais)}'.split('.');
    if (partes.length <= 1) {
      partes.add('00');
      partes.add('00');
    }
    partes[1] = partes[1].padRight(2, '0');
    return Container(
      child: Wrap(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: fontSize - 16,
              ),
              Text(
                '$simbol',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 8,
              )
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              '${partes[0]}',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                //color: Colors.black54,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: 2),
            child: Text(
              ',${partes[1]}',
              style: TextStyle(fontSize: minFontSize),
            ),
          )
        ],
      ),
    );
  }
}
