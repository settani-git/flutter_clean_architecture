import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_mobile/features/github_repo/presentation/bloc/bloc.dart';
import 'package:remote_mobile/features/github_repo/presentation/pages/trending_page.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GithubRepoBloc>(
          builder: (BuildContext context) => sl<GithubRepoBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'UNITED REMOTE MOBILE CHALLENGE',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TrendingPage(),
      ),
    );
  }
}
