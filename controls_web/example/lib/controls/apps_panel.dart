import 'package:controls_web/controls/home_elements.dart';
import 'package:flutter/material.dart';


class AppsGrid extends StatelessWidget {
  final List<Widget> topBars;
  final List<Widget> body;
  final List<Widget> grid;
  const AppsGrid({Key key,this.topBars,this.body,this.grid }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int cols = MediaQuery.of(context).size.width ~/ 150;
    if (cols<2) cols = 2;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: <Widget>[
         SliverToBoxAdapter(child:Container(height:90, child:   
          SliverContents(  slivers: [ 
             for(var item in topBars??[])
              SliverToBoxAdapter(
                  child:Padding(padding:EdgeInsets.all(2), child: item) )
           ],
            scrollDirection: Axis.horizontal
          ))),  

     SliverList(
    delegate: SliverChildListDelegate(
      [
        for(var item in body??[])
          item
      ],
    ),
),

     SliverGrid.count(
              crossAxisCount: cols,
              children: grid??[],
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),      
        ],
      ),
    );
  }
}