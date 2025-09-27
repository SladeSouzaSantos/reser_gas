import 'package:flutter/material.dart';

class PaisButtonWidget extends StatelessWidget {
  final String caminhoImagem;
  final String idioma;
  final bool isSelected;
  final Function(String) onTap;

  const PaisButtonWidget({
    super.key,
    required this.caminhoImagem,
    required this.idioma,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double saturationFactor = isSelected ? 1.0 : 0.75;
    final double borderWidth = isSelected ? 4.0 : 2.0;
    final Color borderColor = isSelected ? Color.fromARGB(90, 255, 255, 255) : const Color.fromARGB(175, 255, 255, 255);
    final double imageOpacity = isSelected ? 1.0 : 0.9;
    
    return InkWell(
      onTap: () {
        onTap(idioma);
      },
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(90, 255, 255, 255),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Opacity(
                opacity: imageOpacity,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(<double>[
                    saturationFactor, 0, 0, 0, 0,
                    0, saturationFactor, 0, 0, 0,
                    0, 0, saturationFactor, 0, 0,
                    0, 0, 0, 1, 0,
                  ]),
                  child: Image.asset(
                    caminhoImagem,
                    height: 80.0,
                    width: 80.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            idioma,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

}