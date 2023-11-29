import 'package:flutter/material.dart';

class BotaoAzul extends StatelessWidget {
  final String texto;
  final double tamanho_fonte;
  final Color cor_fonte;
  final VoidCallback? ao_clicar;
  final FocusNode? marcador_foco;

  BotaoAzul({
        this.texto = "",
        this.tamanho_fonte = 20,
        this.cor_fonte = Colors.white,
        required this.ao_clicar,
        this.marcador_foco = null,
    });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
      ),
      onPressed: ao_clicar,
      focusNode: marcador_foco,
      child: Text(
        texto,
        style: TextStyle(
          color:  cor_fonte,
          fontSize: tamanho_fonte
        )
      ),
    );
  }
}
