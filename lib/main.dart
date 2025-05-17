import 'package:app_lifecycle_observer/app_lifecycle_observer.dart';
import 'package:connectivity_observer/connectivity_observer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyAppStatusScreenGenerated(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyAppStatusScreenGenerated extends ConsumerWidget {
  const MyAppStatusScreenGenerated({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AppLifecycleStateの監視
    final appLifecycleState = ref.watch(appLifecycleObserverProvider);

    // ネットワーク接続状態の監視 (List<ConnectivityResult>)
    // AsyncValue<List<ConnectivityResult>> が返ってくる
    final connectivityResultsAsync = ref.watch(connectivityResultProvider);

    // 主要なネットワーク接続状態の監視 (単一のConnectivityResult)
    final primaryConnectivity = ref.watch(primaryConnectivityResultProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'App Lifecycle State: ${appLifecycleState.name}', // appLifecycleObserverProviderは直接AppLifecycleStateを返す
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Network Status (connectivity_plus):',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            connectivityResultsAsync.when( // StreamProviderと同様にwhenで処理
              data: (results) {
                if (results.isEmpty || results.contains(ConnectivityResult.none)) {
                  return const Text('Not connected');
                }
                return Text('Connected via: ${results.map((r) => r.name).join(', ')}');
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
            ),
            const SizedBox(height: 20),
            Text(
              'Primary Network Status:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Current primary connection: ${primaryConnectivity.name}'), // primaryConnectivityProviderは直接ConnectivityResultを返す
          ],
        ),
      ),
    );
  }
}
