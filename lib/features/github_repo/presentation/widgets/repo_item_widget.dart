import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remote_mobile/features/github_repo/domain/entities/github_repo.dart';

class RepoItemWidget extends StatelessWidget {
  final GithubRepo repo;

  RepoItemWidget({this.repo});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              repo.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.blue.shade900,
                  fontFamily: 'Raleway'),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              height: 30.0,
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: repo.description,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0,
                      color: Colors.black,
                      fontFamily: 'Raleway'),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset(
                      "assets/img/placeholder_img.jpg",
                      width: 40.0,
                      height: 40.0,
                    ),
                    Text(
                      repo.owner,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12.0,
                        color: Colors.blue,
                        fontFamily: 'Raleway',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      size: 26.0,
                    ),
                    Text(
                      NumberFormat.compact().format(repo.starCount).toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          fontFamily: 'Raleway'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
