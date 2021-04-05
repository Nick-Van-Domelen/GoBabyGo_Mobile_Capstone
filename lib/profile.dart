import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testing_app/home.dart';

class profile extends StatefulWidget{
  profile({Key key, this.gsi, this.signIn}) : super(key: key);
 // profile({Key key, this.signIn}) : super (key:key);
  //final String gsi;
  final GoogleSignInAccount gsi;
  final GoogleSignIn signIn;
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile>{
  @override
  TextEditingController _controllerParentName;
  TextEditingController _controllerChildName;
  TextEditingController _controllerEmail;

  Widget build(BuildContext context){

    Future <void> _signOut() async {
      Navigator.of(context).pop();
      await FirebaseAuth.instance.signOut();
      widget.signIn.disconnect();
      //_googleSignIn.disconnect();
      print("logging out");
     // _googleSignIn.signOut();

      return new MyHomePage();
    }

    final _controllerParentName = TextEditingController();
    _controllerParentName.text = widget.gsi.displayName;
    final _controllerChildName = TextEditingController();
    _controllerChildName.text = "ChildName";
    final _controllerEmail = TextEditingController();
    _controllerEmail.text = widget.gsi.email;

    return new Scaffold(
        appBar: AppBar(

          title: Text('Profile', style: TextStyle(color: Colors.white, fontSize:24)),
          backgroundColor: Colors.orange[900],
          centerTitle: true,
        ),
        body: Container(
            child: Center(
                child:Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height:1),
                    Container(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                      child: TextField(
                        onChanged: (text){
                          //on change of value
                          print("ParentName Text: ${_controllerParentName.text}");
                        },
                        controller: _controllerParentName,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(40.0),
                            ),
                          ),
                          //contentPadding: EdgeInsets.all(20.0),
                          labelText: "Parents Name",
                          alignLabelWithHint: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: _controllerParentName.text,
                          hintStyle: TextStyle(color: Colors.orange[900]),
                        ),
                      ),
                    ),
                    Container(          //Childs Name
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),

                      child: TextField(
                        onChanged: (text){
                          //on change of value
                          print("ChildName Text: ${_controllerChildName.text}");
                        },
                        controller: _controllerChildName,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(40.0),
                            ),
                          ),
                          //contentPadding: EdgeInsets.all(20.0),
                          labelText: "Child's Name",
                          alignLabelWithHint: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: _controllerChildName.text,
                          hintStyle: TextStyle(color: Colors.orange[900]),
                        ),
                      ),
                    ),
                    Container(                    //Email
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                      child: TextField(
                        onChanged: (text){
                          //on change of value
                          print("Email Text: ${_controllerEmail.text}");
                        },
                        controller: _controllerEmail,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(40.0),
                            ),
                          ),
                          //contentPadding: EdgeInsets.all(20.0),
                          labelText: "Email",
                          alignLabelWithHint: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: TextStyle(color: Colors.orange[900]),
                          hintText: _controllerEmail.text.toString(),
                        ),
                      ),
                    ),
                    RaisedButton(
                      splashColor: Colors.grey,
                      color: Colors.orange[900],
                      onPressed: () {
                        //TODO: //add validation
                        //add validation,
                        //submit form,
                        //push to next create acct page
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                      highlightElevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height:10.0),
                    RaisedButton(
                      splashColor: Colors.grey,
                      color: Colors.grey,
                      onPressed: () {
                        _signOut();
                        //TODO: //add validation
                        //log user out
                        //return to main page.
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                      highlightElevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Sign Out',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }
}