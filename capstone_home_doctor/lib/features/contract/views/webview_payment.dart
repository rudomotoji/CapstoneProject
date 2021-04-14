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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SuccessNotification()));
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
