import 'dart:convert';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task2/Models/User.dart';
import 'package:task2/Providers/UserProvider.dart';
import 'package:task2/Requests/GithubRequest.dart';

class PublicRepoPage extends StatefulWidget {
  @override
  _PublicRepoPageState createState() => _PublicRepoPageState();
}

class _PublicRepoPageState extends State<PublicRepoPage> {
  User user;
  List<User> users;

  @override
  Widget build(BuildContext context) {
    setState(() {
      user = Provider.of<UserProvider>(context).getUSer();

      Github(user.login).fetchFollowing().then((following) {
        Iterable list = json.decode(following.body);
        setState(() {
          users = list.map((model) => User.fromJson(model)).toList();
        });
      });
    });

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              brightness: Brightness.light,
              leading: BackButton(color: Vx.black),
              backgroundColor: Colors.white,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(user.avatar_url),
                        ),
                      ),
                      20.heightBox,
                      user.login.text.size(20).make()
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: 600,
                  child: 
                  users != null ?
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[200]))
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 60,
                                  height: 60,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(users[index].avatar_url),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(users[index].login, style: TextStyle(fontSize: 20, color: Colors.grey[700]),),
                              ],
                            ),
                            'Following'.text.color(Colors.blue).make(),
                          ],
                        ),
                      );
                    },
                  ) :
                  Container(child: 'Data is loading ...'.text.makeCentered()),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}