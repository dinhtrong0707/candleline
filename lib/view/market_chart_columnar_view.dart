import 'package:flutter/material.dart';
import 'package:candleline/bloc/market_chart_bloc.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:candleline/model/market_chart_model.dart';
import 'package:flutter/foundation.dart';

class MarketChartColumnarView extends StatelessWidget {
  MarketChartColumnarView({Key key, @required this.type});
  final int type; //0 default,1 realtime
  @override
  Widget build(BuildContext context) {
    MarketChartBloc mkBloc = BlocProvider.of<MarketChartBloc>(context);
    return StreamBuilder(
        stream: mkBloc.outCurrentMarketChartList,
        builder:
            (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
          List<Market> tmpList = snapshot.data ?? [Market(0, 0, 0, 0, 0, '')];
          Color increaseColor;
          Color decreaseColor;
          if (type == 0) {
            increaseColor = Colors.red;
            decreaseColor = Colors.green;
          } else {
            increaseColor = Colors.blue;
            decreaseColor = Colors.blue;
          }
          return CustomPaint(
              size: Size.infinite,
              painter: _ColumnarViewPainter(
                  data:tmpList,
                  lineWidth: 1,
                  max: mkBloc.volumeMax,
                  rectWidth: mkBloc.rectWidth,
                  increaseColor: increaseColor,
                  decreaseColor: decreaseColor
              )
          );
        });
  }
}

class _ColumnarViewPainter extends CustomPainter {
  _ColumnarViewPainter({
    Key key,
    @required this.data,
    @required this.max,
    this.lineWidth = 1.0,
    this.rectWidth = 7.0,
    this.increaseColor = Colors.red,
    this.decreaseColor = Colors.green
  });

  final List<Market> data;
  final double lineWidth;
  final double rectWidth;
  final Color increaseColor;
  final Color decreaseColor;
  final double max;

  @override
  void paint(Canvas canvas, Size size) {
    if (max == null ) {
      return;
    }
    double height = size.height - 20;

    final double heightNormalizer = height / (max);

    double rectLeft;
    double rectTop;
    double rectRight;
    double rectBottom;

    Paint rectPaint;

    for (int i = 0; i < data.length; i++) {
      rectLeft = (i * rectWidth) + lineWidth / 2;
      rectRight = ((i + 1) * rectWidth) - lineWidth / 2;

      if (data[i].open > data[i].close) {
        rectPaint = new Paint()
          ..color = decreaseColor
          ..strokeWidth = lineWidth;
      } else {
        rectPaint = new Paint()
          ..color = increaseColor
          ..strokeWidth = lineWidth;
      }

      // Draw candlestick if decrease
      rectTop = height - (data[i].volumeto) * heightNormalizer + 20;
      rectBottom = height + 20;
      Rect ocRect =
      new Rect.fromLTRB(rectLeft, rectTop, rectRight, rectBottom);
      canvas.drawRect(ocRect, rectPaint);

    }
  }

  @override
  bool shouldRepaint(_ColumnarViewPainter old) {
    return data != null;
  }

}