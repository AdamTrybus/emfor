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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 50,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 18.0,
                      ),
                      child: Text(
                        "Wprowadź numer telefonu",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Text(
                "Kod zostanie wysłany w celu zweryfikowania autentyczności twojego numeru telefonu",
                style: Theme.of(context).textTheme.overline,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: InternationalPhoneNumberInput(
                focusNode: FocusNode(canRequestFocus: true),
                autoFocus: true,
                inputDecoration: InputDecoration(
                    errorText:
                        submitted ? "Nieprawidłowy numer telefonu" : null,
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1.6)),
                    hintText: "12 345 67 89"),
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
                      .pushNamed(CodeInput.routeName, arguments: numer);
                }
              },
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
