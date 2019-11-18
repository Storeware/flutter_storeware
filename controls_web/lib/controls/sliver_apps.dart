import 'home_elements.dart';
import 'package:flutter/material.dart';


class SliverApps extends StatelessWidget {
  final appBar;  
  final List<Widget> topBars;
  final List<Widget> body;
  final List<Widget> grid;
  final List<Widget> bottomBars;
  final double topBarsHeight;
  const SliverApps({Key key,this.appBar,this.topBars,this.topBarsHeight=90,this.body,this.grid, this.bottomBars }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int cols = MediaQuery.of(context).size.width ~/ 150;
    if (cols<2) cols = 2;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: <Widget>[
         if (appBar!=null) appBar,   
         SliverToBoxAdapter(child:Container(height:topBarsHeight, child:   
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

    SliverList(
       delegate: SliverChildListDelegate(
         [
           for(var item in bottomBars??[])
              item
         ],
        ),
    ),

        ],
      ),
    );
  }
}