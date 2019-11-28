import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_mobile/features/github_repo/domain/entities/github_repo.dart';
import 'package:remote_mobile/features/github_repo/domain/usecases/get_trending_repos_usecase.dart';
import 'package:remote_mobile/features/github_repo/presentation/bloc/bloc.dart';
import 'package:remote_mobile/features/github_repo/presentation/widgets/repo_item_widget.dart';

class TrendingPage extends StatefulWidget {
  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GithubRepoBloc>(context).add(
      GetGithubReposEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              buildAppBar(),
              SliverList(
                delegate: SliverChildListDelegate([
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _initAndBuildReposList(),
                    ),
                  ),
                ]),
              ),
            ],
          ),
          bottomNavigationBar: buildBottomNavigationBar(),
        ),
      ),
    );
  }

  Widget _initAndBuildReposList() {
    return BlocBuilder<GithubRepoBloc, GithubRepoState>(
      builder: (context, state) {
        if (state is Loading) {
          return buildLoadingWidget();
        } else if (state is Loaded) {
          return buildReposList(state.repos);
        } else if (state is Error) {
          return buildErrorDisplayWidget(state.message);
        } else
          return Container();
      },
    );
  }

  buildReposList(List<GithubRepo> repos) {
    List<Widget> widgets = buildReposColumnWidgets(repos);
    return Column(
      children: <Widget>[
        ...widgets,
      ],
    );
  }

  buildReposColumnWidgets(List<GithubRepo> repos) {
    List<Widget> widgets = [];
    repos.forEach((repo){
      RepoItemWidget(repo: repo);
    });
    return widgets;
  }

  buildErrorDisplayWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
            child: Text(
          message,
        )),
      ),
    );
  }

  buildLoadingWidget() {
    return Center(
      child: Container(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }

  SliverAppBar buildAppBar() {
    return SliverAppBar(
      expandedHeight: 150.0,
      floating: false,
      pinned: true,
      elevation: 5.0,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "Trending ",
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  )),
              TextSpan(
                  text: "Repos",
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    color: Colors.black,
                    fontSize: 20.0,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          title: Text("Trending"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text("Settings"),
        ),
      ],
    );
  }
}
