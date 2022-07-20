import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matching_app/provider/initset_provider.dart';
import 'package:matching_app/top/top.dart';
import 'package:provider/provider.dart';

class InputData extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final model = Provider.of<InitSetProvider>(context, listen: false);

    return FutureBuilder(
        future: model.inputData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: Colors.green,
                )
            );
          } else {
            return TopPage();
          }
        }
    );
  }
}