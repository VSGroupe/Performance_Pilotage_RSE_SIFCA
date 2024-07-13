import 'package:flutter/material.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

class DestinataireWidget extends StatefulWidget {
  const DestinataireWidget({super.key});

  @override
  State<DestinataireWidget> createState() => _DestinataireWidgetState();
}

class _DestinataireWidgetState extends State<DestinataireWidget> {
  final TextEditingController _emailController = TextEditingController();

  List<String> _mailsList = [];
  final List<String> _technicalSupportMails = [
    "projet.it@visionstrategie.com",
    "projet.dd@visionstrategie.com",
    "ing@visionstrategie.com"
  ];

  bool _isTechnicalSupportActive = false;

  void _toggleTechnicalSupport(bool isActive) {
    setState(() {
      _isTechnicalSupportActive = isActive;
      if (isActive) {
        for (var email in _technicalSupportMails) {
          if (!_mailsList.contains(email)) {
            _mailsList.add(email);
          }
        }
      } else {
        _mailsList.removeWhere((email) => _technicalSupportMails.contains(email));
      }
    });
  }

  void _addEmail(String email) {
    if (!_mailsList.contains(email)) {
      setState(() {
        _mailsList.add(email);
        _emailController.clear();
      });
    }
  }

  void _removeEmail(String email) {
    setState(() {
      _mailsList.remove(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text("Joindre le support technique, Oui"),
            const SizedBox(width: 5),
            Checkbox(
              checkColor: Colors.green,
              value: _isTechnicalSupportActive,
              onChanged: (bool? value) {
                _toggleTechnicalSupport(value ?? false);
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _emailController,
          onFieldSubmitted: (value) {
            if (GetUtils.isEmail(value)) {
              _addEmail(value);
            }
          },
          decoration: InputDecoration(
            hintText: "Entrez l'adresse mail du destinataire",
            contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Text("Envoyé à :"),
            const SizedBox(width: 30),
            Expanded(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _mailsList
                    .map((email) => Chip(
                          label: Text(email),
                          onDeleted: () => _removeEmail(email),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}




