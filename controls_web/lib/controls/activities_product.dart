import 'package:flutter/material.dart';
import 'activities.dart';

class ActivityDetail extends StatefulWidget {
  final Widget image;
  final String title;
  final String subtitle;
  final double favorite;
  final double preco;
  final Color color;
  final List<Widget> actions;
  final double precoDe;
  final double qtdeDe;
  final String id;
  final String unidade;
  final Function(String, double) onQtdePressed;
  const ActivityDetail({
    Key key,
    this.actions,
    this.image,
    this.subtitle,
    this.title,
    this.favorite,
    this.preco,
    this.color,
    this.precoDe = 0,
    this.qtdeDe = 0,
    @required this.onQtdePressed,
    @required this.id,
    this.unidade,
  }) : super(key: key);

  @override
  _ActivityDetailState createState() => _ActivityDetailState();
}

class _ActivityDetailState extends State<ActivityDetail> {
  TextEditingController _qtde = TextEditingController();

  @override
  void initState() {
    _qtde.text = '1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: <Widget>[
        ActivityImage(
          titleColor: widget.color ?? theme.primaryColor.withOpacity(0.7),
          height: 300,
          background: Stack(
            children: <Widget>[
              Center(child: widget.image),
              if (widget.favorite > 0)
                Positioned(
                    right: 1,
                    top: 30,
                    child: ActivityButton(
                      image: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.5),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )),
                      iconColor: Colors.red,
                      fontColor: Colors.black,
                      title: (widget.favorite ?? 0).toStringAsFixed(0),
                    ))
            ],
          ),
          //titleColor: Colors.amber.withOpacity(0.3),
          title: Text(widget.title ?? '',
              style: TextStyle(
                fontSize: 28,
                color: Colors.white.withAlpha(250),
              )),
          child: Text(widget.subtitle,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              )),
          childColor: theme.primaryColor.withOpacity(0.6),
        ),
        ActivityPanel(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (widget.unidade != null)
                ActivityButton(
                  //icon: Icons.filter_1,
                  title: widget.unidade,
                ),
              ...(widget.actions ?? []),
              Expanded(child: Container()),
              if (widget.precoDe > 0)
                ActivityButton(
                  image: Text(
                      'de ${widget.precoDe.toString().replaceAll('.', ',')}',
                      style: TextStyle(
                        fontSize: 14,
                      )),
                  /*textStyle: TextStyle(
                      fontSize: 18,
                      decorationStyle: TextDecorationStyle.double),*/
                  title: 'por',
                ),
              if (widget.preco > 0)
                ActivityButton(
                  image: Icon(Icons.attach_money),
                  title: widget.preco.toString().replaceAll('.', ','),
                )
            ],
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          ActivityBuyButton(
            qtde: _qtde,
            onQtdePressed: (qtde) {
              widget.onQtdePressed(widget.id, qtde);
            },
          )
        ]),
      ],
    );
  }
}

class ActivityBuyButton extends StatefulWidget {
  final Function(double) onQtdePressed;
  const ActivityBuyButton({
    Key key,
    @required TextEditingController qtde,
    @required this.onQtdePressed,
  })  : _qtde = qtde,
        super(key: key);

  final TextEditingController _qtde;

  @override
  _ActivityBuyButtonState createState() => _ActivityBuyButtonState();
}

class _ActivityBuyButtonState extends State<ActivityBuyButton> {
  @override
  Widget build(BuildContext context) {
    return ActivityPanel(
        width: 240,
        height: 45,
        color: Colors.amber,
        child: Row(
          children: <Widget>[
            InkWell(
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
                                fontSize: 18, fontWeight: FontWeight.bold)))),
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
                  controller: widget._qtde,
                ),
              ),
            ),
            InkWell(
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
                                fontSize: 18, fontWeight: FontWeight.bold)))),
              ),
              onTap: () {
                somar(1);
              },
            ),
            Expanded(
              child: InkWell(
                child: Align(
                    child: Text('comprar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ))),
                onTap: () {
                  widget.onQtdePressed(somar(0));
                },
              ),
            )
          ],
        ));
  }

  somar(double value) {
    setState(() {
      var d = double.tryParse(widget._qtde.text);
      d += value;
      if (d < 0) d = 0;
      widget._qtde.text = d.toStringAsFixed(0);
      return d;
    });
  }
}
