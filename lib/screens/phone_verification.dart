import '../widgets/code_input.dart';
import '../widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneVerification extends StatefulWidget {
  static const routeName = "/phone-verification";
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  String numer = "", errorMessage = "";
  bool validate, submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Text(
            "Wprowadź numer telefonu",
            style: Theme.of(context).textTheme.display1,
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            "Kod zostanie wysłany w celu zweryfikowania autentycznośc twojego numeru telefonu",
            style: Theme.of(context).textTheme.overline,
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
          MyButton(
            onPressed: () {
              if (numer.isEmpty || !validate) {
                setState(() {
                  submitted = true;
                });
              } else {
                submitted = false;

                Navigator.of(context)
                    .pushNamed(CodeInput.routeName, arguments: {
                  "phone": numer,
                  "login": ModalRoute.of(context).settings.arguments,
                });
              }
            },
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
