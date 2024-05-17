import 'dart:async';
import 'dart:convert';
import 'dart:io' as io; // Namespace for dart:io
import 'package:deteksi_buah_karbit/widgets/constant.dart';
import 'package:deteksi_buah_karbit/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CameraSection extends StatefulWidget {
  const CameraSection({Key? key}) : super(key: key);

  @override
  State<CameraSection> createState() => _CameraSectionState();
}

class _CameraSectionState extends State<CameraSection> {
  int deteksi = 1;
  late InAppWebViewController webViewController;

  @override
  void initState() {
    super.initState();
    // Start a timer to fetch the data every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      fetchDeteksiValueFromAPI();
    });
  }

  void fetchDeteksiValueFromAPI() async {
    try {
      // Create an HttpClient with a bad certificate
      final httpClient = io.HttpClient()
        ..badCertificateCallback =
            ((io.X509Certificate cert, String host, int port) => true) as bool
                Function(io.X509Certificate, String, int)?;

      // Make a GET request to the API endpoint
      final uri = Uri.parse('https://proxy66.rt3.io:33911/predict');
      final request = await httpClient.getUrl(uri);
      final response = await request.close();

      // Check if the request was successful
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = jsonDecode(responseBody);
        setState(() {
          deteksi = data['predict'];
        });
      } else {
        print('Failed to fetch deteksi value: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch deteksi value: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri('https://proxy66.rt3.io:33911/video_feed'),
        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
            useOnDownloadStart: true,
            mediaPlaybackRequiresUserGesture: false,
          ),
          android: AndroidInAppWebViewOptions(
            allowFileAccess: true,
            allowContentAccess: true,
          ),
          ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
          ),
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          //Do some checks here to decide if CANCELS or PROCEEDS
          return ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED);
        },
      ),
      bottomNavigationBar: Container(
        height: 380,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: Column(
                children: [
                  Text(
                    'Hasil Deteksi :',
                    style: primaryTextStyle,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  if (deteksi == 0)
                    Image.asset(
                      'assets/Icon/danger.png',
                      width: 50,
                      height: 50,
                    ),
                  if (deteksi == 1)
                    Image.asset(
                      'assets/Icon/save.png',
                      width: 50,
                      height: 50,
                    ),
                  SizedBox(height: deteksi == 0 ? 10 : 20),
                  Text(
                    deteksi == 0
                        ? 'Mangga terdeteksi karbit!'
                        : 'Mangga terdeteksi bukan karbit!',
                    style: GoogleFonts.poppins(
                        color: deteksi == 0 ? Colors.red : Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 280,
                    child: Text(
                      deteksi == 0
                          ? 'Waspadalah! Mangga ini terdeteksi mengandung karbit. Pilihlah buah yang lebih sehat untuk konsumsi Anda.'
                          : 'Mangga ini bukan karbit sehingga aman untuk dikonsumsi dan matang secara alami',
                      textAlign:
                          deteksi == 0 ? TextAlign.justify : TextAlign.center,
                      style: secondaryTextStyle,
                    ),
                  ),
                  SizedBox(height: deteksi == 0 ? 20 : 20),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [primaryColor, secondaryColor]),
                        borderRadius: BorderRadius.circular(50)),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 110,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/Icon/arrow_left.png',
                              width: 24,
                              height: 28,
                            ),
                            SizedBox(width: 15),
                            Text('Kembali', style: buttonStyle),
                          ],
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
