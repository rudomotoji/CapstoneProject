import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/success.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VNPayWebView extends StatefulWidget {
  final String url;

  const VNPayWebView({Key key, this.url}) : super(key: key);
  @override
  _VNPayWebViewState createState() => _VNPayWebViewState();
}

class _VNPayWebViewState extends State<VNPayWebView> {
  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeaderWidget(
              title: 'Thanh toán',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.NONE,
            ),
            Expanded(
              child: WebView(
                onWebViewCreated: (WebViewController webViewController) =>
                    {_webViewController = webViewController},
                navigationDelegate: (navigation) {
                  if (navigation.url.contains('https://vnpay.vn/')) {
                    print('RESULT: ${_webViewController.toString()}');
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => SuccessNotification()));
                    //
                    // showDialog(
                    //   barrierDismissible: false,
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return Center(
                    //       child: ClipRRect(
                    //         borderRadius: BorderRadius.all(Radius.circular(5)),
                    //         child: BackdropFilter(
                    //           filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    //           child: Container(
                    //             width: 200,
                    //             height: 200,
                    //             decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(10),
                    //                 color: DefaultTheme.WHITE.withOpacity(0.8)),
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 SizedBox(
                    //                   width: 100,
                    //                   height: 100,
                    //                   child: Image.asset(
                    //                       'assets/images/ic-checked.png'),
                    //                 ),
                    //                 Text(
                    //                   'Thanh toán thành công',
                    //                   style: TextStyle(
                    //                       color: DefaultTheme.GREY_TEXT,
                    //                       fontSize: 15,
                    //                       fontWeight: FontWeight.w400,
                    //                       decoration: TextDecoration.none),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // );

                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.of(context).pop();
                    });
                    return NavigationDecision.navigate;
                  }
                  _webViewController.loadUrl(navigation.url);
                  return NavigationDecision.prevent;
                },
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
