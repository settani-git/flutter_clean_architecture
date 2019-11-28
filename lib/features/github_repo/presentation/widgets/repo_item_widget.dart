import 'package:flutter/material.dart';
import 'package:remote_mobile/features/github_repo/domain/entities/github_repo.dart';

class RepoItemWidget extends StatelessWidget {
  final GithubRepo repo;

  RepoItemWidget({this.repo});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      child: Column(
        children: <Widget>[
          Text(
            repo.name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                fontFamily: 'Raleway'),
          ),
          Text(
            repo.description.length >= 50
                ? repo.description.substring(50) + ' ...'
                : repo.description,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
                fontFamily: 'Raleway'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(
                "assets/img/placeholder_img.jpg",
                width: 50.0,
                height: 50.0,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    size: 12.0,
                  ),
                  Text(
                    repo.starCount.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12.0,
                        fontFamily: 'Raleway'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
