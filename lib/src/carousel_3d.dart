import 'dart:async';

import 'package:flutter/material.dart';
import 'package:transformer_page_view/index_controller.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

import 'transformer_3d.dart';


class Carousel3DWidget extends StatefulWidget {
  bool loop;
  int duration;
  ValueChanged<int> onChanged;
  int index;
  int itemCount;
  double viewportFraction;
  IndexedWidgetBuilder itemBuilder;
  bool autoPlay;
  int autoPlayDelay;
  double scale;

  Carousel3DWidget(
      {Key key,
      this.loop = true,
      this.duration = 1000,
      this.onChanged,
      this.index = 0,
      this.itemCount,
      this.viewportFraction = 0.6,
      this.itemBuilder,
      this.autoPlay = true,
      this.autoPlayDelay = 1500,
      this.scale = 0.7})
      : assert(itemBuilder != null || itemCount != null,
            "itemBuilder and transformItemBuilder must not be both null"),
        super(key: key);

  @override
  _Carousel3DWidgetState createState() => _Carousel3DWidgetState();
}

class _Carousel3DWidgetState extends State<Carousel3DWidget> {
  Timer _timer;
  IndexController _controller;

  @override
  void initState() {
    super.initState();
    _controller = IndexController();
    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      child: TransformerPageView(
        controller: _controller,
        key: UniqueKey(),
        loop: widget.loop,
        duration: Duration(milliseconds: widget.duration),
        onPageChanged: (int i) {
          if (widget.onChanged != null) widget.onChanged(i);
        },
        pageController: TransformerPageController(
            initialPage: widget.index,
            loop: widget.loop,
            itemCount: widget.itemCount,
            reverse: true,
            viewportFraction: widget.viewportFraction),
        transformer: Transformer3D(context,
            scale: widget.scale, viewportFraction: widget.viewportFraction),
        // index: bean.tag,
        itemBuilder: (BuildContext context, int i) {
          return widget.itemBuilder(context, i);
        },
        itemCount: widget.itemCount,
        viewportFraction: widget.viewportFraction ?? 0.6,
      ),
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          if (notification.dragDetails != null) {
            //by human
            if (_timer != null) _stopAutoPlay();
          }
        } else if (notification is ScrollEndNotification) {
          if (_timer == null) _startAutoPlay();
        }

        return false;
      },
    );
  }

  void _startAutoPlay() {
    if (!widget.autoPlay) return;
    assert(_timer == null, "Timer must be stopped before start!");
    _timer =
        Timer.periodic(Duration(milliseconds: widget.autoPlayDelay), _onTimer);
  }

  void _onTimer(Timer timer) {
    _controller.next(animation: true);
  }

  void _stopAutoPlay() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }
}
