import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:provider/provider.dart';
import 'Pages/PublicRepoPage.dart';
import 'Providers/UserProvider.dart';

void main() => runApp(
    ChangeNotifierProvider<UserProvider>(
      builder: (context) => UserProvider(),
      child: MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    )
);

class HomePage extends StatefulWidget {
  @override
  _StateHomePage createState() => _StateHomePage();
}

class _StateHomePage extends State<HomePage> {

  TextEditingController _controller = TextEditingController();

  void _getUser() {
    if (_controller.text == '') {
      Provider.of<UserProvider>(context).setMessage('Please Enter your username');
    } else {
      Provider.of<UserProvider>(context).fetchUser(_controller.text).then((value) {
        if (value) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PublicRepoPage()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: VStack([
          100.heightBox,
          Container(
            width: 120,
            height: 120,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage('https://github.githubassets.com/apple-touch-icon-180x180.png'),
            ),
          ).centered(),
          10.heightBox,
          'Github'.text.color(Vx.white).semiBold.size(40).makeCentered(),
          120.heightBox,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(.1)
            ),
            child: TextField(
              onChanged: (value) {
                Provider.of<UserProvider>(context).setMessage(null);
              },
              controller: _controller,
              enabled: !Provider.of<UserProvider>(context).isLoading(),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  errorText: Provider.of<UserProvider>(context).getMessage(),
                  border: InputBorder.none,
                  hintText: "Github Username",
                  hintStyle: TextStyle(color: Colors.grey)
              ),
            ),
          ),
          20.heightBox,
          MaterialButton(
            //padding: EdgeInsets.all(20),
            color: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            child: Align(
              child: Provider.of<UserProvider>(context).isLoading() ?
              CircularProgressIndicator(backgroundColor: Colors.white, strokeWidth: 2).p12() : 'Get Your PublicRepo Now'.text.color(Vx.white).make().p20()
            ), onPressed: () {
            _getUser();
          },
          )
        ]).px24(),
      ).scrollVertical(),
    );
  }
}