import 'package:flutter/material.dart';
import 'package:new_emfor/widgets/chat/confirm_process.dart';
import 'package:new_emfor/widgets/chat/initial_process.dart';
import 'package:new_emfor/widgets/chat/guarantee_window.dart';
import 'package:new_emfor/widgets/chat/first_process.dart';
import 'package:new_emfor/widgets/chat/second_process.dart';
import 'package:new_emfor/widgets/chat/third_process.dart';

class GuaranteeWidget extends StatelessWidget {
  final int process;
  final bool principal;
  GuaranteeWidget(this.process, this.principal);

  Widget widget() {
    if (principal) {
      switch (process) {
        case 0:
          {
            return InitialProcess();
          }
          break;
        case 1:
          {
            return FirstProcess();
          }
          break;
        case 2:
          {
            return SecondProcess();
          }
          break;
        case 3:
          {
            return ThirdProcess();
          }
          break;

        default:
          {
            return SizedBox();
          }
          break;
      }
    } else {
      switch (process) {
        case 1:
          {
            return ConfirmProcess();
          }
          break;

        default:
          {
            return SizedBox();
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget();
  }
}
