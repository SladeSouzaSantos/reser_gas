import 'package:flutter/material.dart';

typedef GetTranslation = String Function(String key);
typedef BuildConfirmButton = Widget Function(VoidCallback onPressed);

class EntradaMassaMolecularWidget extends StatelessWidget {
  final GetTranslation getTranslation;
  final TextEditingController massaMolecularController;
  final VoidCallback onConfirm;
  final BuildConfirmButton buildConfirmButton;

  const EntradaMassaMolecularWidget({
    super.key,
    required this.getTranslation,
    required this.massaMolecularController,
    required this.onConfirm,
    required this.buildConfirmButton,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslation('aba_massa'),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: massaMolecularController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: getTranslation('label_massa_molecular'),
              labelStyle: const TextStyle(color: Colors.amber),
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54),),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber),),
            ),
          ),
          buildConfirmButton(onConfirm),
        ],
      ),
    );
  }
}