import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:untitled/components/logo.dart';
import 'package:untitled/components/menu.dart';
import 'package:untitled/utils/add_space.dart';
import '../resources/resources.dart' as res;

class PositionedView extends StatelessWidget {
  final Widget positionChildWidget;
  final Widget childWidget;
  final bool isSlider;
  final bool isMenu;
  final double top;
  const PositionedView({Key? key,
    required this.positionChildWidget,
    this.childWidget = const Text(""),
    this.isSlider = false,
    this.isMenu = false,
    this.top = 370,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    // double scaffoHeight = Scaffold.of(context).appBarMaxHeight as double;
    return Scaffold(
        appBar: isMenu ? PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              flexibleSpace: Container(
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Run Wheelz",
                      style: textTheme.headline5?.copyWith(height: 24, color: Colors.white),
                    ),
                    addHorizontalSpace(40),
                    const Icon(Icons.verified_user, color: Colors.white,),
                    addHorizontalSpace(20),
                    const Icon(Icons.notification_add_rounded, color: Colors.white),
                    addHorizontalSpace(40),
                  ],
                )
              ),
            )) : null,
        drawer: isMenu ? Menu.menuData("Menu", res.menuItems) : null,
        body: Stack(
        children: <Widget>[
          Positioned(
          top: 0, left: 0, right: 0, bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 600, //MediaQuery.of(context).size.height - AppBar().preferredSize.height,
                padding: const EdgeInsets.only(top: 35),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(children: [
                  Logo(),
                  const SizedBox(height: 30,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                      child: isSlider == false ? null : ImageSlideshow(
                        width: MediaQuery.of(context).size.width,
                        height: 220,
                        initialPage: 0,
                        indicatorColor: Colors.blue,
                        indicatorBackgroundColor: Colors.grey,
                        autoPlayInterval: 3000,
                        isLoop: true,
                        children: [
                          Image.asset(
                            'images/img_1.png',
                            fit: BoxFit.fill,
                          ),
                          Image.asset(
                            'images/img_2.png',
                            fit: BoxFit.fill,
                          ),
                          Image.asset(
                            'images/img_3.png',
                            fit: BoxFit.fill,
                          ),
                        ],
                      ))
                ]),
              ),
            ],
          )),
          Positioned(
              top: isSlider ? 400 : top,
              left: 20,
              right: 20,
              child: positionChildWidget)
    ]));
  }
}
