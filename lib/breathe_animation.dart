import 'package:flutter/material.dart';

///交错动画方式实现
class BreathAnimation extends StatefulWidget {
  const BreathAnimation({Key? key}) : super(key: key);

  @override
  State<BreathAnimation> createState() => _BreathAnimationState();
}

class _BreathAnimationState extends State<BreathAnimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AwaitFunction(),
      // body: InternalFunctionDemo(),
    );
  }
}

class AwaitFunction extends StatefulWidget {
  const AwaitFunction({Key? key}) : super(key: key);

  @override
  State<AwaitFunction> createState() => _AwaitFunctionState();
}

class _AwaitFunctionState extends State<AwaitFunction>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _alphaController;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(vsync: this);
    _alphaController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _breathController.dispose();
    _alphaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation1 =
        Tween<double>(begin: 0.0, end: 1.0).animate(_breathController);
    final Animation<double> alphaAnimation =
        Tween<double>(begin: 1.0, end: .5).animate(_alphaController);

    return Scaffold(
      body: FadeTransition(
        opacity: alphaAnimation,
        child: AnimatedBuilder(
          animation: _breathController,
          builder: (BuildContext context, Widget? child) {
            return Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  gradient: RadialGradient(colors: [
                    Colors.blue[600]!,
                    Colors.blue[100]!,
                  ], stops: [
                    animation1.value,
                    animation1.value + 0.1
                  ]),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await playAnimation();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> playAnimation() async {
    _breathController.duration = Duration(seconds: 4);
    _breathController.forward();
    await Future.delayed(Duration(seconds: 4));
    _alphaController.duration = Duration(seconds: 1);
    _alphaController.repeat(reverse: true);
    await Future.delayed(Duration(seconds: 7));
    _alphaController.reset();
    _breathController.duration = Duration(seconds: 8);
    _breathController.reverse();
    await Future.delayed(Duration(seconds: 8));
    await playAnimation();
  }
}

class InternalFunctionDemo extends StatefulWidget {
  const InternalFunctionDemo({Key? key}) : super(key: key);

  @override
  State<InternalFunctionDemo> createState() => _InternalFunctionDemoState();
}

class _InternalFunctionDemoState extends State<InternalFunctionDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 19));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation1 = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: const Interval(0.0, 4 / 19)))
        .animate(_controller);
    final Animation<double> animation2 = Tween<double>(begin: .5, end: 1)
        .chain(CurveTween(curve: const Interval(4 / 19, 11 / 19)))
        .animate(_controller);
    final Animation<double> animation3 = Tween<double>(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: const Interval(11 / 19, 1)))
        .animate(_controller);
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Center(
            child: Opacity(
              opacity: animation2.value,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  gradient: RadialGradient(
                      colors: [
                        Colors.blue[600]!,
                        Colors.blue[100]!,
                      ],
                      stops: _controller.value > 11 / 19
                          ? [animation3.value, animation3.value + 0.1]
                          : [animation1.value, animation1.value + 0.1]),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.repeat();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
