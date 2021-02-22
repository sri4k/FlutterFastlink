import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Fastlink',
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
        primarySwatch: Colors.yellow,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Fastlink'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            RaisedButton(
              child: Text('Launch Fastlink'),
              onPressed: () async {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => FastLinkView()));

                // var token = 'tZh1GwFkeU2yyYVbca8ujuNyELWy';
                // var uri = 'https://development.api.yodlee.com/ysl/accounts/';

                var baseUrl = 'https://sandbox.api.yodlee.com/ysl';
                // var loginName = 'cybervik@gmail.com';
                var loginName = 'sbMem5f94a37310f192';

                // var clientId = 'krusfRip0EZGyYmZbRLDkMQnbkekI2dB';
                var clientId = 'dEZABvPG2tod1oEooNb8idSTaDurkBLn';
                // var clientSecret = 'tRtr4sPBphGF5Tjj';
                var clientSecret = 'vzny6piDqGwIATdh';
                var token =
                    await getToken(baseUrl, loginName, clientId, clientSecret);

                await callApi(token, '$baseUrl/accounts/');
                await callApi(token, '$baseUrl/providerAccounts/');
                await callApi(token, '$baseUrl/holdings/');
                await callApi(token, '$baseUrl/holdings/securities/');
                await callApi(token, '$baseUrl/transactions/');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<String> getToken(String baseUrl, String loginName, String clientId,
      String clientSceret) async {
    var headers = {
      'Api-Version': '1.1',
      'loginName': loginName,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request('POST', Uri.parse('$baseUrl/auth/token'));
    request.bodyFields = {'clientId': clientId, 'secret': clientSceret};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var result = await response.stream.bytesToString();

    var userToken = '';
    if (response.statusCode < 300) {
      print(result);
      userToken = jsonDecode(result)['token']['accessToken'];
    } else {
      print(response.reasonPhrase);
    }
    return userToken;
  }

  Future callApi(String token, String uri) async {
    var headers = {
      'Api-Version': '1.1',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var request = http.Request('GET', Uri.parse(
        // 'https://development.api.yodlee.com/ysl/providerAccounts/10075955'));
        // 'https://development.api.yodlee.com/ysl/holdings?providerAccountId=10075702'));
        // 'https://development.api.yodlee.com/ysl/transactions?accountId=10337349'));
        uri));

    request.headers.addAll(headers);

    var response = await request.send();

    var result = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print(result);
    } else {
      print(response.reasonPhrase);
    }
    return result;
  }
}

class FastLinkView extends StatelessWidget {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FastLink'),
        ),
        body: WebView(
          initialUrl: 'about:blank',
          javascriptMode: JavascriptMode.unrestricted,
          debuggingEnabled: true,
          javascriptChannels: Set.from([
            JavascriptChannel(
                name: 'YWebViewHandler',
                onMessageReceived: (JavascriptMessage eventData) {
                  var message = jsonDecode(eventData.message);

                  print('Inside webview ***');

                  print('providerId *** ${message.data.providerId}');
                  print('providerName *** ${message.data.providerName}');
                  print('requestId *** ${message.data.requestId}');
                  print(
                      'providerAccountId *** ${message.data.providerAccountId}');

                  // print(message);

                  //TODO get transaction & account details
                })
          ]),
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            _loadFastLink();
          },
        ));
  }

  _loadFastLink() async {
    // String _htmlString = '''<html>
    //     <body>
    //         Hello Charan
    //         <form name="fastlink-form" action="" method="POST">
    //             <input name="accessToken" value="Bearer ndd2rrWGbiKokoCACARa7W1Gxjan" hidden="true" />
    //             <input name="extraParams" value="" hidden="true" />
    //         </form>
    //         <script type="text/javascript">
    //             window.onload = function () {
    //                 document.forms["fastlink-form"].submit();
    //             }
    //         </script>
    //     </body>
    //     </html>''';
    _controller.loadUrl(
        // 'http://192.168.0.64:5000/yodlee?token=UdTBhpfz5Whuz2zHC3b2ANlBv2Nf');
        'https://api.capitally.co/yodlee.html?token=QtzzWIKk1YDi5sFm8QUjalDWVieY');
    // 'https://www.google.com');
  }
}
