import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'features/exchange/presentation/bloc/exchange_cubit.dart';
import 'features/exchange/presentation/pages/exchange_page.dart';

void main() {
  initDependencies();
  runApp(const ExchangeApp());
}

class ExchangeApp extends StatelessWidget {
  const ExchangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExchangeCubit>(),
      child: MaterialApp(
        title: 'Exchange Calculator',
        theme: appTheme(),
        debugShowCheckedModeBanner: false,
        home: const ExchangePage(),
      ),
    );
  }
}
