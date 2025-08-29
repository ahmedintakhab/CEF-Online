import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../My_cources/ongoing_completed_main_screen.dart';
import '../My_cources/ongoing_screen.dart';
import 'success_payment_dialog.dart'; // Import the corrected dialog

class CheckoutWebviewScreen extends StatefulWidget {
  final String url;

  const CheckoutWebviewScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<CheckoutWebviewScreen> createState() => _CheckoutWebviewScreenState();
}

class _CheckoutWebviewScreenState extends State<CheckoutWebviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Optional: Update UI with progress if needed
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true; // Show loader when page starts loading
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false; // Hide loader when page finishes loading
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false; // Hide loader on error
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading page: ${error.description}')),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            // Check if the URL matches the target URL
            if (request.url.startsWith('https://cefonlineacademy.com/student/pending-payments')) {
              // Show SuccessPaymentDialog
              showDialog(
                context: context,
                barrierDismissible: false, // Prevent dismissing by tapping outside
                builder: (context) => SuccessPaymentDialog(
                  onOkPressed: () {
                    Navigator.pop(context); // Dismiss the dialog
                    // Navigate to OngoingScreen, replacing HomeMainScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OngoingCompletedScreen(),
                      ),
                    );
                  },
                ),
              );
              return NavigationDecision.prevent; // Prevent the WebView from loading the URL
            }
            return NavigationDecision.navigate; // Allow other URLs to load
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF78A03F),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // Set back arrow icon color to white
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF78A03F), // Match app theme
                strokeWidth: 3.w,
              ),
            ),
        ],
      ),
    );
  }
}