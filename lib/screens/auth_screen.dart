import '../widgets/code_input.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String numer = "", errorMessage = "";
  bool validate, submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone verification"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Text(
            "Wprowadź numer telefonu",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            "Kod zostanie wysłany w celu zweryfikowania autentycznośc twojego numeru telefonu",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: InternationalPhoneNumberInput(
              focusNode: FocusNode(canRequestFocus: true),
              inputDecoration: InputDecoration(
                errorText: submitted ? "Nieprawidłowy numer telefonu" : null,
                fillColor: Colors.grey[200],
                filled: true,
              ),
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              onInputChanged: (PhoneNumber number) {
                numer = number.phoneNumber;
              },
              onInputValidated: (bool value) {
                validate = value;
              },
              ignoreBlank: false,
              autoValidate: false,
              selectorType: PhoneInputSelectorType.DIALOG,
              initialValue: PhoneNumber(isoCode: 'PL'),
              searchBoxDecoration:
                  InputDecoration(hintText: "Szukaj według nazwy kraju"),
            ),
          ),
          Expanded(child: SizedBox()),
          Container(
            width: 200,
            child: RaisedButton(
              onPressed: () {
                if (numer.isEmpty || !validate) {
                  setState(() {
                    submitted = true;
                  });
                } else {
                  submitted = false;
                  Navigator.of(context)
                      .pushNamed(CodeInput.routeName, arguments: numer);
                }
              },
              color: Colors.amber[500],
              elevation: 6,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(26),
                borderSide: BorderSide(width: 1, color: Colors.amber[500]),
              ),
              child: Text(
                "Dalej",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
