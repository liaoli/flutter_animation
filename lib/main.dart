import 'package:flutter/material.dart';

import 'breathe_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<String> list = ['显式动画', '隐式动画', '呼吸动画internal', '呼吸动画await'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // body: AnimationDemo(),
      body: ListView.separated(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          String s = list[index];

          return GestureDetector(
            onTap: () {
              switch (index) {
                case 0:
                  newPage(AnimationDemo());
                  break;
                case 1:
                  newPage(AnimationDemo());
                  break;
                case 2:
                  newPage(InternalFunctionDemo());
                  break;
                case 3:
                  newPage(AwaitFunction());
                  break;
              }
            },
            child: Container(
              color: Colors.cyanAccent,
              child: Center(child: Text(s)),
              height: 80,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            height: 0.5,
            color: Colors.black26,
            width: double.infinity,
          );
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void newPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

class AnimationDemo extends StatefulWidget {
  const AnimationDemo({Key? key}) : super(key: key);

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    super.initState();
  }

  void _incrementCounter() {
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RotationTransition(
            // turns: _controller,
            // turns: _controller.drive(Tween(begin: 5.0, end: 7.0)),
            turns: Tween(begin: 5.0, end: 7.0)
                .chain(CurveTween(curve: const Interval(0.5, 1.0)))
                .animate(_controller),
            child: Container(
              width: 200,
              height: 200,
              color: Colors.amber,
            ),
          ),
          foo(
            controller: _controller,
            interval: Interval(0.0, 0.2),
            color: Colors.green[200],
          ),
          foo(
            controller: _controller,
            interval: Interval(0.2, 0.4),
            color: Colors.green[400],
          ),
          foo(
            controller: _controller,
            interval: Interval(0.4, 0.6),
            color: Colors.green[600],
          ),
          foo(
            controller: _controller,
            interval: Interval(0.6, 0.8),
            color: Colors.green[800],
          ),
          foo(
            controller: _controller,
            interval: Interval(0.8, 1.0),
            color: Colors.green[900],
          ),
          AnimateBuilderDemo(
            controller: _controller,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class foo extends StatefulWidget {
  final AnimationController controller;
  final Interval interval;
  final Color? color;

  const foo(
      {Key? key, required this.controller, required this.interval, this.color})
      : super(key: key);

  @override
  State<foo> createState() => _fooState();
}

class _fooState extends State<foo> with SingleTickerProviderStateMixin {
  // late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // _controller =
    //     AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween(begin: Offset.zero, end: const Offset(0.1, 0))
          .chain(CurveTween(curve: Curves.bounceOut))
          .chain(CurveTween(curve: widget.interval))
          .animate(
            widget.controller,
          ),
      child: GestureDetector(
        onTap: () {
          widget.controller.forward();
        },
        child: Container(
          color: widget.color,
          width: 400,
          height: 60,
        ),
      ),
    );
  }
}

class AnimateBuilderDemo extends StatelessWidget {
  final AnimationController controller;

  const AnimateBuilderDemo({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Animation<double> opacityAnim =
        Tween(begin: .5, end: .8).animate(controller);
    final Animation<double> heightAnim =
        Tween(begin: 100.0, end: 200.0).animate(controller);
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          // opacity: controller.value,
          // opacity: Tween<double>(begin: .0, end: 1).evaluate(controller),
          opacity: opacityAnim.value,
          child: Container(
            color: Colors.cyanAccent,
            width: 300,
            // height: Tween<double>(begin: 200.0, end: 300).evaluate(controller),
            height: heightAnim.value,
            child: child,
          ),
        );
      },
      child: Center(
        child: Text(
          'hello',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
