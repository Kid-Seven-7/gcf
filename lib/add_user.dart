import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcf_projects_app/globals.dart';
import 'package:gcf_projects_app/login.dart';
import 'usermanagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUser extends StatefulWidget{
  @override
  State createState() => new AddUserState();
}

final textKey = GlobalKey<EditableTextState>();

class AddUserState extends State<AddUser> with SingleTickerProviderStateMixin {

  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  DBCrypt dBCrypt = DBCrypt();
  //final _UsNumberTextInputFormatter _phoneNumberFormatter = _UsNumberTextInputFormatter();

//Text Controllers
  final textName = new TextEditingController();
  final textPassword = new TextEditingController();
  final textEmail = new TextEditingController();
  final textConfirmPassword = new TextEditingController();
  final textPhone = new TextEditingController();

  //Regex allowed characters
  static final RegExp nameRegExp = RegExp(r"^[a-zA-Z]+$");

  //  _formKey and _autoValidate
  final formKey = GlobalKey<FormState>();
  bool autoValidate = false;


  @override
  void dispose() {
    textName.dispose();
    textPassword.dispose();
    textEmail.dispose();
    super.dispose();
  }


  @override
  void initState() {
    //TEST
    pageNumber += 1;
    print('Login Page Number: $pageNumber');
    //TEST
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000));

    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeIn,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }


 /* Adding Phone Authentication*/
// String phoneNo;
  String smsCode;
  String verificationId;

  Future<void> verifyPhoneNumber() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('Phone Authenticated');
      });
    };

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
      print('verified');
    };

    final PhoneVerificationFailed verifyFailed = (AuthException exception) {
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(phoneNumber: this.textPhone.text, codeAutoRetrievalTimeout: autoRetrieve, codeSent: smsCodeSent, timeout: const Duration(seconds: 50),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verifyFailed);
  }


    /*Creating sms dialog*/
    Future<bool> smsCodeDialog(BuildContext context) {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: Text('Enter sms Code'),
              content: TextField(
                onChanged: (value) {
                  this.smsCode = value;
                },
              ),
              contentPadding: EdgeInsets.all(10.0),
              actions: <Widget>[
                new FlatButton(
                  child: Text('Done'),
                  onPressed: () {
                    FirebaseAuth.instance.currentUser().then((user) {
                      if (user != null) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed('/loginpage');
                      } else {
                        Navigator.of(context).pop();

                      }
                    });
                  },
                )
              ],
            );
          });
        }

    signIn() {

      try{

      FirebaseAuth.instance.signInWithPhoneNumber(verificationId: verificationId, smsCode: smsCode);

      }catch(e) {
        print(e.message);
        }
    }
    /*End of Phone Authentication*/


    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 140, 188, 63),
            title: Text('Add user'),

          ),
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.black87,
          body: ListView(
          scrollDirection: Axis.vertical,
            //fit: StackFit.expand,
            children: <Widget>[
              new Image(
                  image: new AssetImage("assets/images/login_back.png"),
                  fit: BoxFit.cover,
                  color: Colors.black87,
                  colorBlendMode: BlendMode.darken
              ),

              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                new Image(image: new AssetImage("assets/images/GCF-logo.png"), height: _iconAnimation.value * 100, width: _iconAnimation.value * 100,),
                  new Form(
                    key: formKey,
                    autovalidate: autoValidate,
                    child: Theme(
                      data: ThemeData(
                        brightness: Brightness.dark,
                        primarySwatch: Colors.green,
                        inputDecorationTheme: new InputDecorationTheme(
                            labelStyle: new TextStyle(
                              color: Color.fromARGB(255, 140, 188, 63),
                              fontSize: 20.0,)),
                      ),
                      child: new Container(
                        padding: const EdgeInsets.all(30.0),
                        child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new TextFormField(
                                  decoration: new InputDecoration(labelText: "Name", icon: Icon(Icons.person_outline)),
                                  keyboardType: TextInputType.text,
                                  //inputFormatters:<TextInputFormatter> [new LengthLimitingTextInputFormatter(50)],
                                  controller: textName,

                                  //Adding the validator to check the name inputs are correct.
                                  validator: validateNameInputs,
                                ),
                                new TextFormField(
                                  decoration: new InputDecoration(labelText: "Phone", icon: Icon(Icons.phone_android),),
                                  keyboardType: TextInputType.phone,
                                  controller: textPhone,
                                  inputFormatters: <TextInputFormatter> [WhitelistingTextInputFormatter.digitsOnly, _mobileFormatter,],
                                  onSaved: (val) => textPhone.text = val,


                                  //Adding the validator to check the password inputs are correct.
                                  validator: validatePhoneInputs,

                                ),
                                TextFormField(
                                  decoration: InputDecoration(labelText: "Password", icon: Icon(Icons.lock_outline),),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  controller: textPassword,
                                  onSaved: (val) => textPassword.text = val,

                                  //Adding the validator to check the password inputs are correct.
                                  validator: validatePasswordInputs,

                                ),
                                new TextFormField(
                                  decoration: new InputDecoration(labelText: "Confirm Password", icon: Icon(Icons.lock_outline),),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  controller: textConfirmPassword,

                                  //Adding the validator to check the password inputs are correct.
                                  validator: validateConfirmPasswordInputs,

                                ),
                                new Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                ),
                                new FlatButton(
                                  color: Color.fromARGB(255, 140, 188, 63),
                                  child: Text('Add User'),
                                  onPressed: () {

                                    //verifyPhoneNumber();
                                    validateAndSubmit();

                                    var hash = dBCrypt.hashpw(
                                        textPassword.text, dBCrypt.gensalt());
                                    print(hash);
                                  },
                                ),
                                new FlatButton(
                                  color: Color.fromARGB(0, 0, 0, 0),
                                  child: new Text("Already have an account? Login"),
                                  onPressed: () {
                                    Navigator.push(
                                        context, MaterialPageRoute(
                                        builder: (context) => new LoginPage()));
                                  },
                                ),
                              ],
                            ),
                           ),
                    ),
                  )
                ]
                        ),
                    ]
              )
      );
    }



    bool validateAndSaveInputs() {

      if (formKey.currentState.validate()) {
//    If all data are correct then save data to our variables
        print('Form is Valid');
        formKey.currentState.save();
        return true;
      } else {
//    If all data are not valid then start auto validation.
        print('Form is Invalid');
        return false;
      }
    }


    void validateAndSubmit() async {
      if (validateAndSaveInputs()) {
        try {
          FirebaseUser user = signIn().then((signedInUser) {
            UserManagement().storeNewUser(signedInUser, context);
          });

          if (user != null) {
            // Checking if user is already signed up
            final QuerySnapshot result = await Firestore.instance.collection(
                'user').where('id', isEqualTo: user.uid).where(
                'email', isEqualTo: user.email).where(
                'phone', isEqualTo: user.phoneNumber).limit(1).getDocuments();

            final List<DocumentSnapshot> documents = result.documents;

            //If user is already signed up
            if (documents.length != null) {
              print('#########-----User already Signed Up and Authenticated------#########');
              print(documents);
            }
            //return documents.length == 1;
            if (documents.length == 0) {
              // Update data to server if new user
              Firestore.instance.collection('user').document(user.uid).setData(
                  {
                    'uid': user.uid,
                    'email': user.email,
                    'phone': user.phoneNumber,
                  });
            }
          }
        } catch (e) {
          print(e.message);
        }
      }
    }


/*  Checking the text fields input if they are correct*/

    String validateNameInputs(String value) {
      if (value.isEmpty)
        return 'Name can\'t be empty.';
      if (value.length < 3)
        return 'Name can\'t be less than 3 charater.';
      /*if (!nameRegExp.hasMatch(value))
        return 'Name must contain only letters (a-zA-Z).';*/

      return null;
    }

    String validatePhoneInputs(String value) {
      if (value.isEmpty)
        return 'Phone number can\'t be empty.';
// South African Mobile number are of 10 digit only
      if (value.length >= 15){
        print(value);
        return 'Phone number digit can\'t be greater than 15';
      }
        else return null;
    }

    String validatePasswordInputs(String value) {
      if (value.isEmpty)
        return 'Password can\'t be empty.';
      if (value.length < 8) {
        return 'Password must be at least 8 characters long.';
      }
      return null;
    }

    String validateConfirmPasswordInputs(String value) {

      if (value != textPassword.text)
        return 'Passwords don\'t match';
      if (value.isEmpty)
        return 'Password can\'t be empty.';
      if (value.length < 8) {
        return 'Password must be at least 8 characters long.';
      }
      return null;
    }

}

// Format incoming numeric text to fit the format of (###) ###-#### ##...
class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();

    if (newTextLength >= 1) {
      newText.write('+');

      if (newValue.selection.end >= 1)
        selectionIndex++;
    }
    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + ' ');
      if (newValue.selection.end >= 2) selectionIndex += 1;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

final _mobileFormatter = NumberTextInputFormatter();



