import 'package:dummy_account/user_area.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Signin extends StatelessWidget {

  String verificationId;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
    FirebaseUser user;
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      user = await _auth.currentUser();
    }
    else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
      );
      user = (await _auth.signInWithCredential(credential)).user;
    }

    return user;
  }



  /// method to verify phone number and handle phone auth
  Future<void>_verifyPhoneNumber(String phoneNumber) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final PhoneVerificationCompleted verified = (AuthCredential authResult){
      FirebaseAuth.instance.signInWithCredential(authResult);
      print('Signed in');
    };

    final PhoneVerificationFailed verificationfailed = (AuthException authException){
      print(authException.message);
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]){
      this.verificationId =verId;
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout= (String verId){
      this.verificationId = verId;
    };


    await _auth.verifyPhoneNumber(
        phoneNumber: '+91'+phoneNumber,
        timeout: Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeAutoRetrievalTimeout: autoTimeout,
      codeSent: smsSent,
    );
  }



//  /// will get an AuthCredential object that will help with logging into Firebase.
//  _verificationComplete(AuthCredential authCredential) async {
//    AuthResult authResult= await FirebaseAuth.instance.signInWithCredential(authCredential);
//    print(authResult.toString());
//    print('Verified');
//  }
//
//  _smsCodeSent(String verificationId, List<int> code) {
//    // set the verification code so that we can use it to log the user in
//    var _smsVerificationCode = verificationId;
//    print('codesent');
//  }
//
//  _verificationFailed(AuthException authException) {
//    print(authException.message.toString());
//    print('failed');
//  }
//
//  _codeAutoRetrievalTimeout(String verificationId) {
//    // set the verification code so that we can use it to log the user in
//    var _smsVerificationCode = verificationId;
//    print('retreival');
//  }


//
//    /// NOTE: Either append your phone number country code or add in the code itself
//    /// Since I'm in India we use "+91 " as prefix `phoneNumber`
//
//    /// The below functions are the callbacks, separated so as to make code more redable
//    void verificationCompleted(AuthCredential phoneAuthCredential) {
//      print('verificationCompleted');
//      print(phoneAuthCredential);
//    }
//
//    void verificationFailed(AuthException error) {
//      print(error);
//    }
//
//    void codeSent(String verificationId, [int code]) {
//      print('codeSent');
//    }
//
//    void codeAutoRetrievalTimeout(String verificationId) {
//      print('codeAutoRetrievalTimeout');
//    }
//    Future<void> _submitPhoneNumber(String phoneNumber) async {
//    await FirebaseAuth.instance.verifyPhoneNumber(
//      /// Make sure to prefix with your country code
//      phoneNumber: phoneNumber,
//
//      /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
//      timeout: Duration(milliseconds: 10000),
//
//      /// If the SIM (with phoneNumber) is in the current device this function is called.
//      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
//      verificationCompleted: verificationCompleted,
//
//      /// Called when the verification is failed
//      verificationFailed: verificationFailed,
//
//      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
//      codeSent: codeSent,
//
//      /// After automatic code retrival `tmeout` this function is called
//      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//    ); // All the callbacks are above
//  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 85),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Builder(
              builder:(context)=> MaterialButton(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Log in with google\t'),
                    Icon(Icons.search),
                  ],
                ),
                onPressed: () async{
                  FirebaseUser user = await _handleSignIn();
                  String show= await Navigator.push(context, MaterialPageRoute(builder: (context)=>Playground(user, _googleSignIn)));
                  print(show);
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(show,
                      style: TextStyle(
                          letterSpacing: 2, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                      duration: Duration(milliseconds: 2000),
                      backgroundColor: Colors.grey[500],
                  ));
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
            ),
            SizedBox(height: 30,),
            MaterialButton(
                color: Colors.blueAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Log in with phone number\t'),
                    Icon(Icons.phone)
                  ],
                ),
                onPressed: (){
                  String number;
                  Alert(
                    style: AlertStyle(backgroundColor: Colors.white, titleStyle: TextStyle(color: Colors.blueGrey[800])),
                      context: context,
                      title: 'Enter phone number',
                      content: TextField(
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          prefixText: '+91 ',
                          icon: Icon(Icons.phone, color: Colors.blueGrey,),
                          hintText: '1234567890',
                          hintStyle: TextStyle(color: Colors.grey),
                          focusColor: Colors.black,
                        ),
                        cursorColor: Colors.blueGrey[400],
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          number=value;
                          print(value);
                        },
                      ),
                      buttons: [
                        DialogButton(
                          onPressed: (){
//                            _submitPhoneNumber(number);
                            _verifyPhoneNumber(number);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: Colors.blueAccent,
                        ),
                      ]).show();
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
          ],
        ),
      ),
    );
  }
}
