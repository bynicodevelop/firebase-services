import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/UserService.dart';
import 'package:services/getaway/FirebaseAuthGtaway.dart';

class ServiceProvider extends StatelessWidget {
  final Widget child;

  const ServiceProvider({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserService>(
          create: (context) => UserService(
            firebaseAuthGetaway: FirebaseAuthGetaway(),
          ),
        )
      ],
      child: child,
    );
  }
}
