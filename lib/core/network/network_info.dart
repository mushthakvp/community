// lib/core/network/network_info.dart
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
  Future<List<ConnectivityResult>> get connectivityResult;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    // Check if any connection type is available (not none)
    return result.any((connection) => connection != ConnectivityResult.none);
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return connectivity.onConnectivityChanged;
  }

  @override
  Future<List<ConnectivityResult>> get connectivityResult async {
    return await connectivity.checkConnectivity();
  }

  // Helper methods for specific connection types
  Future<bool> get isWifiConnected async {
    final result = await connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.wifi);
  }

  Future<bool> get isMobileConnected async {
    final result = await connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.mobile);
  }

  Future<bool> get isEthernetConnected async {
    final result = await connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.ethernet);
  }

  // Get the primary connection type
  Future<ConnectivityResult> get primaryConnectionType async {
    final result = await connectivity.checkConnectivity();
    if (result.isEmpty) return ConnectivityResult.none;

    // Prioritize connection types (wifi > ethernet > mobile > vpn > other)
    if (result.contains(ConnectivityResult.wifi)) {
      return ConnectivityResult.wifi;
    } else if (result.contains(ConnectivityResult.ethernet)) {
      return ConnectivityResult.ethernet;
    } else if (result.contains(ConnectivityResult.mobile)) {
      return ConnectivityResult.mobile;
    } else if (result.contains(ConnectivityResult.vpn)) {
      return ConnectivityResult.vpn;
    } else {
      return result.first;
    }
  }

  // Get connection quality description
  Future<String> get connectionDescription async {
    final result = await connectivity.checkConnectivity();

    if (result.isEmpty || result.contains(ConnectivityResult.none)) {
      return 'No connection';
    }

    List<String> connections = [];
    if (result.contains(ConnectivityResult.wifi)) {
      connections.add('WiFi');
    }
    if (result.contains(ConnectivityResult.mobile)) {
      connections.add('Mobile');
    }
    if (result.contains(ConnectivityResult.ethernet)) {
      connections.add('Ethernet');
    }
    if (result.contains(ConnectivityResult.vpn)) {
      connections.add('VPN');
    }

    return connections.isNotEmpty
        ? connections.join(', ')
        : 'Unknown connection';
  }
}
