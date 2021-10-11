import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tweed_card_demo/constants.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tweed Card Demo',
      theme: ThemeData(
          backgroundColor: const Color(0x00000000),
          scaffoldBackgroundColor: const Color(0x00000000)),
      home: const MyHomePage(title: 'Tweed Card Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 60.0),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: TweedCard(),
          ),
        ),
      ),
    );
  }
}

class TweedCard extends StatefulWidget {
  const TweedCard({Key? key}) : super(key: key);

  @override
  _TweedCardState createState() => _TweedCardState();
}

class _TweedCardState extends State<TweedCard> {
  @override
  Widget build(BuildContext context) {
    var avatarSize = MediaQuery.of(context).size.width > 650 ? 64.0 : 48.0;
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: avatarSize,
            child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Image.asset('assets/avatar.png')),
          ),
          const Expanded(
            child: InfoSection(),
          )
        ],
      ),
    );
  }
}

class InfoSection extends StatefulWidget {
  const InfoSection({Key? key}) : super(key: key);

  @override
  _InfoSectionState createState() => _InfoSectionState();
}

class _InfoSectionState extends State<InfoSection>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var isDesktop = MediaQuery.of(context).size.width > 650;
    var textStyle = isDesktop ? normalTextDesktop : normalText;
    var linkTextStyle = isDesktop ? linkTextDesktop : linkText;
    var grigTitle = isDesktop ? normalTextDesktop : boldText;
    var grigSubtitle = isDesktop ? normalTextDesktopGrey : normalTextGrey;
    var text = isDesktop
        ? 'Practica tus habilidades de Grid CSS con este ejercicio de las capitales del mundo.'
        : 'leonidasesteban.com';
    var radious = isDesktop ? 28.0 : 20.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        isDesktop ? const HeaderDesktop() : const HeaderMobile(),
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text:
                    'Los retos de esta semana de /Proyectos son totalmente gratis, crea una sección de pricing y una galería de fotos ',
                style: textStyle),
            TextSpan(
                text: 'https://leonidasesteban.com/proyectos/cards-precios ',
                style: linkTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    var _url =
                        'https://leonidasesteban.com/proyectos/cards-precios';
                    await canLaunch(_url)
                        ? await launch(_url)
                        : throw 'Could not launch $_url';
                  }),
            TextSpan(
                text: 'https://leonidasesteban.com/proyectos/grid-gallery',
                style: linkTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    var _url =
                        'https://leonidasesteban.com/proyectos/grid-gallery';
                    await canLaunch(_url)
                        ? await launch(_url)
                        : throw 'Could not launch $_url';
                  }),
            TextSpan(
                text: ' estos los puedes hacer en 100% solo con HTML y CSS',
                style: textStyle)
          ]),
        ),
        const SizedBox(
          height: 16.0,
        ),
        Container(
          height: isDesktop ? 150 : 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radious)),
              border: Border.all(color: Colors.grey)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/image.png',
                fit: BoxFit.fitHeight,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Grig Gallery',
                        style: grigTitle,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        text,
                        style: grigSubtitle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        const LikeButton()
      ],
    );
  }
}

class LikeButton extends StatefulWidget {
  const LikeButton({Key? key}) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  var touched = false;
  int likes = 250;
  late final AnimationController _animationController;
  late final Animation<double> marked;

  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    marked = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.elasticInOut));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          touched = !touched;
          _animationController.repeat(
              min: 0.55, max: 1.0, period: const Duration(milliseconds: 1000));
          touched ? likes++ : likes--;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: touched
                ? ScaleTransition(
                    scale: marked,
                    child: SizedBox(
                      height: 16.0,
                      width: 19.0,
                      child: Image.asset('assets/heart-fill.png',
                          fit: BoxFit.fill),
                    ))
                : Image.asset('assets/heart.png', fit: BoxFit.fill),
          ),
          Text(
            '$likes',
            style: const TextStyle(
                fontSize: 16.0,
                fontFamily: 'Poppins-Light',
                color: Color.fromRGBO(110, 118, 125, 1)),
          )
        ],
      ),
    );
  }
}

class HeaderDesktop extends StatelessWidget {
  const HeaderDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fontSize = MediaQuery.of(context).size.width > 650 ? 16.0 : 12.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'LeonidasEsteban.css ',
          style: TextStyle(
              color: Colors.white, fontSize: fontSize, fontFamily: 'Poppins'),
        ),
        const SizedBox(
          width: 6.0,
        ),
        Text(
          '@LeonidasEsteban · 2h ',
          style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Poppins-Light',
              color: Colors.grey),
        ),
        const SizedBox(
          height: 8.0,
        ),
      ],
    );
  }
}

class HeaderMobile extends StatelessWidget {
  const HeaderMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fontSize = MediaQuery.of(context).size.width > 650 ? 16.0 : 12.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'LeonidasEsteban.css ',
          style: TextStyle(
              color: Colors.white, fontSize: fontSize, fontFamily: 'Poppins'),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Text(
          '@LeonidasEsteban · 2h ',
          style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Poppins-Light',
              color: Colors.grey),
        ),
        const SizedBox(
          height: 8.0,
        ),
      ],
    );
  }
}
