import 'dart:async';
import 'package:flutter/material.dart';
import 'image_picker_handler.dart';

// ignore: must_be_immutable
class ImagePickerDialogWidget extends StatelessWidget {
  late final ImagePickerHandler _listener;
  late final AnimationController? _controller;
  late BuildContext context;

  ImagePickerDialogWidget(this._listener, this._controller, {Key? key}) : super(key: key);

  Animation<double>? _drawerContentsOpacity;
  Animation<Offset>? _drawerDetailsPosition;

  void initState() {
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controller!),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.fastOutSlowIn,
    ));
  }

  getImage(BuildContext context) {
    if (_controller == null ||
        _drawerDetailsPosition == null ||
        _drawerContentsOpacity == null) {
      return;
    }
    _controller!.forward();
    showDialog(
      context: context,
      builder: (BuildContext context) => SlideTransition(
        position: _drawerDetailsPosition!,
        child: FadeTransition(
          opacity: ReverseAnimation(_drawerContentsOpacity!),
          child: this,
        ),
      ),
    );
  }

  void dispose() {
    _controller!.dispose();
  }

  startTime() async {
    var _duration = const Duration(milliseconds: 200);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context);
  }

  dismissDialog() {
    _controller!.reverse();
    startTime();
  }

  Widget botao(context, _texto) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: Theme.of(context).primaryColor),
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _texto,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              color: Theme.of(context).primaryColor,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Material(type: MaterialType.transparency, child: btnPhotos(context));
  }

  Widget btnPhotos(context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.8)),
      padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
              onTap: () => _listener.openCamera(),
              child: botao(context, "Camera")),
          const SizedBox(height: 10.0),
          GestureDetector(
              onTap: () => _listener.openGallery(),
              child: botao(context, "Galeria")),
          const SizedBox(height: 20.0),
          GestureDetector(
            onTap: () => dismissDialog(),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
              child: Text(
                "Cancelar",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    // fontWeight: FontWeight.w300,
                    fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
