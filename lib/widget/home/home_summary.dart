import 'package:flutter/material.dart';

class HomeSummary extends StatefulWidget {
  @override
  _HomeSummaryState createState() => _HomeSummaryState();
}

class _HomeSummaryState extends State<HomeSummary> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Total Balance", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                SizedBox(height: 20),
                DropdownButton<String>(
                  hint: Text('Select Account'),
                  items: <String>['Account 1', 'Account 2', 'Account 3'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ],
            ),
            Text(
              'RS 2500.00',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_upward),
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                ),
                Text('RS. 1500'),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                ),
                Text('RS. 2500'),
              ],
            ),
            
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
          ElevatedButton(onPressed: () {}, child: Text('Day')),
          ElevatedButton(onPressed: () {}, child: Text('Week')),
          ElevatedButton(onPressed: () {}, child: Text('Month')),
          // ElevatedButton(onPressed: () {}, child: Text('Year')),
          // ElevatedButton(onPressed: () {}, child: Text('Period')),
              ],
            ),
          ],
        ),
        // child: Text('Welcome to Money Manager!'),
      );
  }
}