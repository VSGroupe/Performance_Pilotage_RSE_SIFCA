import 'package:flutter/material.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:toggle_switch/toggle_switch.dart';

class DestinataireWidget extends StatefulWidget {
  const DestinataireWidget({super.key});

  @override
  State<DestinataireWidget> createState() => _DestinataireWidgetState();
}

class _DestinataireWidgetState extends State<DestinataireWidget> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
             Text(tr.technicalSupport),
            const SizedBox(width: 30),
            ToggleSwitch(
              cornerRadius: 90.0,
              initialLabelIndex: 0,
              activeFgColor: Colors.white,
              activeBgColors: [
                [Colors.red[800]!],
                [Colors.green[800]!]
              ],
              inactiveFgColor: Colors.white,
              totalSwitches: 2,
              minHeight: 15,
              minWidth: 15,
              radiusStyle: true,
              // cancelToggle: (index) async {
              //   return;
              // },
            ),
          ],
        ),
        const SizedBox(height: 40),
        TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value!=null && value.length < 10 ) {
                  return tr.occurredErrorMessage;
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: "",
                  contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2
                      )
                  )
              ),
            ),
        const SizedBox(height: 40),
         Row(
          children: [
            Text("'${tr.sendTo} :"),
            const SizedBox(width: 30),
            const Wrap()
          ],
        )
      ],
    );
  }
}
