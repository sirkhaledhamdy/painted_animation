import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: GlassOfLiquidDemo(),
    );
  }
}

class GlassOfLiquidDemo extends StatefulWidget {
  const GlassOfLiquidDemo({Key? key}) : super(key: key);

  @override
  State<GlassOfLiquidDemo> createState() => _GlassOfLiquidDemoState();
}

class _GlassOfLiquidDemoState extends State<GlassOfLiquidDemo> {
  double skew = .2;
  double fullInGlass = .5;
  double ratio = .7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Awesome Cup!',
        style: TextStyle(
          fontSize: 24,
        ),
        ),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 120,
              height: 180,
              child: CustomPaint(
                painter: GlassOfLiquid(
                  ratio: ratio,
                  skew: 0.01 + skew,
                  fullInGlass: fullInGlass,
                ),
              ),
            ),
          ),
          Slider(
              value: skew,
              activeColor: Colors.red,
              inactiveColor: Colors.grey.shade300,
              label: 'angle',
              divisions: 10,
              onChanged: (newValue) {
                setState(() {
                  skew = newValue;
                });
              }),
          Slider(
              value: fullInGlass,
              activeColor: Colors.red,
              inactiveColor: Colors.grey.shade300,
              label: 'Fill',
              divisions: 10,
              onChanged: (newValue) {
                setState(() {
                  fullInGlass = newValue;
                });
              }),
          Slider(
              value: ratio,
              activeColor: Colors.red,
              inactiveColor: Colors.grey.shade300,
              label: 'width',
              divisions: 10,
              onChanged: (newValue) {
                setState(() {
                  ratio = newValue;
                });
              }),
        ],
      ),
    );
  }
}

class GlassOfLiquid extends CustomPainter {
  final double skew;
  final double ratio;
  final double fullInGlass;
  GlassOfLiquid(
      {required this.skew, required this.ratio, required this.fullInGlass});

  @override
  void paint(Canvas canvas, Size size) {
    //glass
    Paint glass = Paint()
      ..color = Colors.white.withAlpha(150)
      ..style = PaintingStyle.fill;

    //Milk
    Paint milkTopPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Paint milkColor = Paint()
      ..color = Color.fromARGB(255, 235, 235, 235)
      ..style = PaintingStyle.fill;

    // outline glass
    Paint black = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    //top
    Rect top = Rect.fromLTRB(0, 0, size.width, size.width * skew);
    // bottom
    Rect bottom = Rect.fromCenter(
        center: Offset(
            size.width * .5, size.height - size.width * .5 * skew * ratio),
        width: size.width * ratio,
        height: size.width * skew * ratio);

    Rect? liquidTop = Rect.lerp(bottom, top, fullInGlass);

    //  Path
    Path cupPath = Path()
      ..moveTo(top.left, top.top + top.height * .5)
      ..arcTo(top, pi, pi, true)
      ..lineTo(bottom.right, bottom.top + bottom.height * .5)
      ..arcTo(bottom, 0, pi, true)
      ..lineTo(top.left, top.top + top.height * .5);

    Path liquidPath = Path()
      ..moveTo(liquidTop!.left, liquidTop.top + liquidTop.height * .5)
      ..arcTo(liquidTop, pi, pi, true)
      ..lineTo(bottom.right, bottom.top + bottom.height * .5)
      ..arcTo(bottom, 0, pi, true)
      ..lineTo(liquidTop.left, liquidTop.top + liquidTop.height * .5);

    //draw
    canvas.drawPath(cupPath, glass);
    canvas.drawPath(liquidPath, milkColor);
    canvas.drawOval(liquidTop, milkTopPaint);
    canvas.drawPath(cupPath, black);
    canvas.drawOval(top, black);
  }

  @override
  bool shouldRepaint(covariant GlassOfLiquid oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate.fullInGlass != fullInGlass ||
        oldDelegate.skew != skew ||
        oldDelegate.ratio != ratio;
  }
}
