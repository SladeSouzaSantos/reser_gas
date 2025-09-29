import 'package:flutter/material.dart';

typedef GetTranslation = String Function(String key);
typedef BuildConfirmButton = Widget Function(VoidCallback onPressed);

class RadioGroup<T> extends StatelessWidget {
  const RadioGroup({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.child,
  });

  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class EntradaDensidadeWidget extends StatelessWidget {
  final GetTranslation getTranslation;
  final String selectedDensityType;
  final ValueChanged<String?> onDensityChange;
  final TextEditingController densityController;
  final VoidCallback onConfirm;
  final BuildConfirmButton buildConfirmButton;

  const EntradaDensidadeWidget({
    super.key,
    required this.getTranslation,
    required this.selectedDensityType,
    required this.onDensityChange,
    required this.densityController,
    required this.onConfirm,
    required this.buildConfirmButton,
  });

  @override
  Widget build(BuildContext context) {
    final String densityUnit = selectedDensityType == 'Seca' 
      ? getTranslation('densidade_seco') 
      : getTranslation('densidade_umido'); 

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslation('aba_densidade'),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          RadioGroup<String>(
            groupValue: selectedDensityType,
            onChanged: onDensityChange, 
            child: Column(
              children: [
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(getTranslation('densidade_seco'), style: const TextStyle(color: Colors.white70)),
                  value: 'Seca',
                  groupValue: selectedDensityType,
                  onChanged: onDensityChange,
                  activeColor: Colors.amber,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(getTranslation('densidade_umido'), style: const TextStyle(color: Colors.white70)),
                  value: 'Úmida',
                  groupValue: selectedDensityType,
                  onChanged: onDensityChange,
                  activeColor: Colors.amber,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          TextField(
            controller: densityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: getTranslation('label_densidade').replaceAll('{0}', densityUnit),
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