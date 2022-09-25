// @dart=2.12
// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';

class ActivityProductDetail extends StatefulWidget {
  final Widget? image;
  final double? height;
  final String? title;
  final int? maxLines;
  final String? subTitle;
  final Widget? favorite;
  final Widget? child;
  final double? price;
  final Color? color;
  final Color? textColor;
  final List<Widget>? actions;
  final double? priceFrom;
  final double? qtyFrom;
  final String? id;
  final String? unit;
  final String? buyLabel;
  final String? buySubLabel;
  final bool? showBuyButton;
  final Widget? imageBottom, imageTop;
  final TextStyle? style;

  final double? initialQty;
  final double descmaximo;

  final List<Widget>? items;
  final Function(String codigo, double preco, double percDesconto,
      double valorDesconto, double liquido)? onBuyPressed;
  final Function(String codigo, double preco, double percDesconto,
      double valorDesconto, double liquido)? onBuy;
  final List<Widget>? children;
  const ActivityProductDetail({
    Key? key,
    this.actions,
    this.image,
    this.subTitle,
    this.buyLabel,
    this.buySubLabel,
    this.maxLines = 2,
    this.title,
    this.favorite,
    this.imageBottom,
    this.imageTop,
    this.showBuyButton = true,
    this.style,
    this.child,
    this.price = 0,
    this.descmaximo = 0,
    this.color,
    this.priceFrom = 0,
    this.qtyFrom = 0,
    this.items,
    this.initialQty = 1,
    this.children,
    required this.onBuyPressed,
    this.onBuy,
    required this.id,
    this.unit,
    this.textColor,
    this.height,
  }) : super(key: key);

  @override
  State<ActivityProductDetail> createState() => _ActivityProductDetailState();
}

class _ActivityProductDetailState extends State<ActivityProductDetail> {
  TextEditingController _qtde = TextEditingController();
  late double percDesconto;
  late double desconto;
  late double liquido;

  @override
  void initState() {
    percDesconto = 0;
    desconto = 0;
    liquido = widget.price!;
    _qtde.text = widget.initialQty.toString();
    super.initState();
  }

  get preco => widget.price!;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Form(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.imageTop != null) widget.imageTop!,
        if (widget.image != null) widget.image!,
        if (widget.imageBottom != null) widget.imageBottom!,
        (widget.title != null)
            ? Text(widget.title ?? '',
                maxLines: widget.maxLines,
                overflow: TextOverflow.ellipsis,
                style: widget.style ??
                    TextStyle(
                      fontSize: 20,
                      color: widget.textColor ?? Colors.white.withAlpha(250),
                    ))
            : Container(),
        (widget.subTitle != null)
            ? Text(widget.subTitle!,
                style: TextStyle(
                  fontSize: 16,
                  color: widget.textColor ?? Colors.white,
                ))
            : Container(),
        ActivityPanel(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.favorite != null) buildFavorities(),
              if (widget.unit != null)
                ActivityButton(
                  title: widget.unit,
                ),
              ...(widget.actions ?? []),
              Expanded(child: Container(child: widget.child)),
              FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(children: [
                    if (widget.priceFrom! > 0)
                      ActivityButton(
                        image: Text(
                            'de ${widget.priceFrom.toString().replaceAll('.', ',')}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            )),
                        title: 'por',
                      ),
                    if ((widget.price ?? 0) > 0) const Text('Preço unit:  '),
                    if ((widget.price ?? 0) > 0)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ShowPriceWidget(
                          precovenda: widget.price!,
                          //showDescript: false,
                        ),
                      ),
                  ])),
            ],
          ),
        ),
        if (widget.descmaximo > 0)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ShowDescontoMaximo(
                preco: widget.price!,
                descmaximo: widget.descmaximo,
                onChanged: (percentual, desconto) {
                  percDesconto = percentual;
                  this.desconto = desconto;
                  liquido = preco - desconto;
                }),
          ),
        if (widget.children != null) ...widget.children!,
        if (widget.showBuyButton!)
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            ActivityBuyButton(
              label: widget.buyLabel,
              subLabel: widget.buySubLabel,
              color: widget.color ?? theme.primaryColor,
              textColor: Colors.white,
              initialValue: widget.initialQty!,
              onComprar: (qtde) {
                widget.onBuy!(widget.id!, qtde, percDesconto, desconto,
                    liquido); //toDouble(_percDescController.text));
              },
              onQtdePressed: (qtde) {
                widget.onBuyPressed!(widget.id!, qtde, percDesconto, desconto,
                    liquido); //toDouble(_percDescController.text));
              },
            )
          ]),
        ...widget.items ?? []
      ],
    ));
  }

  buildFavorities() => widget.favorite;
}

class ActivityBuyButton extends StatefulWidget {
  final Function(double) onQtdePressed;
  final Function(double) onComprar;
  final double? initialValue;
  final Color? color;
  final Color? textColor;
  final String? label;
  final String? subLabel;
  const ActivityBuyButton({
    Key? key,
    this.initialValue = 1,
    this.color,
    required this.onQtdePressed,
    this.textColor,
    this.subLabel,
    this.label,
    required this.onComprar,
  }) : super(key: key);

  @override
  State<ActivityBuyButton> createState() => _ActivityBuyButtonState();
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
    const w = 300.0;
    return Column(
      children: [
        ActivityPanel(
          width: w,
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
                      decoration: const BoxDecoration(
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
                  width: 70,
                  //padding: EdgeInsets.only(bottom: 0),
                  alignment: Alignment.center,
                  child: TextField(
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                        color: captionColor, fontWeight: FontWeight.bold),
                    controller: _qtde,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Qtde',
                      hintStyle: TextStyle(
                          color: captionColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 6, left: 1),
                  child: Container(
                      width: 40,
                      decoration: const BoxDecoration(
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
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.label ?? 'comprar',
                          style: TextStyle(
                            color: widget.textColor ??
                                theme.textTheme.caption!.color,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          )),
                      if (widget.subLabel != null)
                        Text(widget.subLabel!,
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.textColor ??
                                  theme.textTheme.caption!.color,
                            ))
                    ],
                  )),
                  onPressed: () {
                    widget.onComprar(somar(0));
                  },
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 1,
        ),
        StrapButton(
            width: w,
            radius: 12,
            text: 'Adicionar ao Carrinho',
            onPressed: () {
              widget.onQtdePressed(somar(0));
            })
      ],
    );
  }

  double xQtde = 1;
  somar(double value) {
    double d = double.tryParse(_qtde.text.replaceAll(',', '.')) ?? 0;
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
    Key? key,
    this.simbol = 'R\$',
    this.fontSize = 18,
    @required this.precovenda,
    this.color,
    this.decimais = 2,
    //@required this.showDescript,
  }) : super(key: key);

  final double? precovenda;
  //final bool showDescript;
  final String? simbol;
  final double? fontSize;
  final int? decimais;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var minFontSize = (fontSize! / 2);
    if (minFontSize < 10) minFontSize = 10;
    var partes = precovenda!.toStringAsFixed(decimais!).split('.');
    if (partes.length <= 1) {
      partes.add('00');
      partes.add('00');
    }
    partes[1] = partes[1].padRight(2, '0');
    return Wrap(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: fontSize! - 16,
            ),
            Text(
              '$simbol',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(
              width: 8,
            )
          ],
        ),
        const SizedBox(width: 6),
        Container(
          alignment: Alignment.bottomCenter,
          child: Text(
            partes[0],
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,

              //color: Colors.black54,
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            ',${partes[1]}',
            style: TextStyle(
              fontSize: minFontSize,
              color: color,
            ),
          ),
        )
      ],
    );
  }
}

class ShowDescontoMaximo extends StatefulWidget {
  final double descmaximo;
  final double preco;
  final Function(double value, double desconto) onChanged;
  final Function(double value)? validate;
  const ShowDescontoMaximo(
      {Key? key,
      required this.preco,
      required this.descmaximo,
      required this.onChanged,
      this.validate})
      : super(key: key);

  @override
  State<ShowDescontoMaximo> createState() => _ShowDescontoMaximoState();
}

class _ShowDescontoMaximoState extends State<ShowDescontoMaximo> {
  final MoneyMaskedTextController _percDescController =
      MoneyMaskedTextController(rightSymbol: '%');

  late ValueNotifier<double> liquido;
  late double desconto;
  @override
  void initState() {
    super.initState();
    desconto = 0;
    liquido = ValueNotifier<double>(widget.preco);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: liquido,
        builder: (a, b, c) => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      //10padding: EdgeInsets.only(top: 40),
                      height: kToolbarHeight + 3,
                      width: 90,
                      child: MaskedMoneyFormField(
                        controller: _percDescController,
                        label: '% desconto',
                        onChanged: (x) {
                          if (x > widget.descmaximo)
                            _percDescController.numberValue = widget.descmaximo;
                          desconto = _percDescController.numberValue /
                              100 *
                              widget.preco;
                          widget.onChanged(
                              _percDescController.numberValue, desconto);
                          liquido.value = widget.preco - desconto;
                        },
                        validator: (x) {
                          if (widget.validate != null) widget.validate!(x);
                        },
                        //onChanged: (x){

                        //},
                      ),
                    ),
                    const SizedBox(width: 20),
                    ShowPriceWidget(
                        simbol: '', precovenda: desconto, color: Colors.red),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Líquido:  '),
                    ShowPriceWidget(precovenda: liquido.value),
                  ],
                ),
              ],
            ));
  }
}
