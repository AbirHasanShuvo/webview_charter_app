import 'package:chartered_app/providers/url_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late WebViewController _controller;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(ref.read(urlProvider)));
  }

  Future<void> _refreshPage() async {
    setState(() {
      _isLoading = true;
    });
    await _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CFO App'),
        elevation: 10,
        actions: [
          IconButton(onPressed: _refreshPage, icon: Icon(Icons.refresh)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading) Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
