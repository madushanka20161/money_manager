import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppConfig.backgroundWrapper(
        context,
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/app-icon.png',
                width: MediaQuery.of(context).size.width/2.5,
                height: MediaQuery.of(context).size.width/2.5,
              ),
              SizedBox(height: 20),
              Text('Money Mate', style: TextStyle(fontSize: AppConfig.headerFontSize*1.5, color: AppConfig.fontColor, fontWeight: FontWeight.bold),),
              Text('Smart Way to Manage Your Money', style: AppConfig.fontStyle,),
              SizedBox(height: 20),
              CircularProgressIndicator(
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text('Loading your wallet...', style: AppConfig.fontStyle,),
            ],
          ),
        )
      )
    );
  }
}
