import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:new_emfor/widgets/button.dart';
import 'package:new_emfor/widgets/profile/enter_code.dart';

class VerifyPhone extends StatefulWidget {
  static const String routeName = "verify-phone";
  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  String numer = "", errorMessage = "";
  bool validate, submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 32,
              ),
              padding: EdgeInsets.all(16),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
            SizedBox(
              height: 20,
            ),
            MyButton(
              horizontalPadding: 45,
              onPressed: () => Navigator.of(context)
                  .pushNamed(EnterCode.routeName, arguments: numer),
            ),
          ],
        ),
      ),
    );
  }
}
