import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/providers/app_provider.dart';
import 'core/utils/secure_storage.dart';
import 'features/coupons/presentation/pages/coupon_home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPref.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget with FittorAppMixin {
  const MyApp({super.key});

  @override
  Widget responsive(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CouponHomePage(),
      ),
    );
  }
}
