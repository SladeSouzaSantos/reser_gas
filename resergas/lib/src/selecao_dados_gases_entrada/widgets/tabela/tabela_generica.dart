import 'package:flutter/material.dart';

typedef AoRemover<T> = void Function(T item);

typedef ConstrutorDeCelula<T> = Widget Function(T item, int indiceColuna);

class ColunaTabela {
  final String titulo;
  final int flex;
  final TextAlign alinhamentoTexto;

  const ColunaTabela({
    required this.titulo,
    required this.flex,
    this.alinhamentoTexto = TextAlign.left,
  });
}

class LinhaTabelaGenerica<T> extends StatelessWidget {
  final T item;
  final List<Widget> celulas;
  final Widget? widgetAcao;

  const LinhaTabelaGenerica({
    super.key,
    required this.item,
    required this.celulas,
    this.widgetAcao,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          
          ...celulas,
          
          if (widgetAcao != null)
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: widgetAcao,
              ),
            ),
        ],
      ),
    );
  }
}

class TabelaDadosGenerica<T> extends StatelessWidget {
  final List<T> dados;
  final List<ColunaTabela> colunas;
  final ConstrutorDeCelula<T> construtorDeCelula;
  final AoRemover<T>? aoRemover;
  final Widget? rodape;

  const TabelaDadosGenerica({
    super.key,
    required this.dados,
    required this.colunas,
    required this.construtorDeCelula,
    this.aoRemover,
    this.rodape,
  });

  @override
  Widget build(BuildContext context) {
    final bool temColunaAcao = aoRemover != null;
    
    final linhaCabecalho = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ...colunas.map((col) => Expanded(
            flex: col.flex,
            child: Text(
              col.titulo,
              style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
              textAlign: col.alinhamentoTexto,
            ),
          )),
          
          if (temColunaAcao)
            const Expanded(
              flex: 2, 
              child: SizedBox(), 
            ),
        ],
      ),
    );
    
    final linhasDeDados = dados.map((item) {
      final celulas = List.generate(
        colunas.length, 
        (index) => Expanded(
          flex: colunas[index].flex,
          child: construtorDeCelula(item, index),
        ),
      );
      
      final widgetAcao = temColunaAcao 
          ? IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red, size: 18),
              onPressed: () => aoRemover!(item),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            )
          : null;

      return LinhaTabelaGenerica<T>(
        key: ValueKey(item.hashCode),
        item: item,
        celulas: celulas,
        widgetAcao: widgetAcao,
      );
    }).toList();
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2228),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white38),
      ),
      child: Column(
        children: [
          linhaCabecalho,
          const Divider(color: Colors.white38, height: 1),          
          ...linhasDeDados,
          if (rodape != null) ...[
            const Divider(color: Colors.white38, height: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: rodape!,
            ),
          ],
        ],
      ),
    );
  }
}