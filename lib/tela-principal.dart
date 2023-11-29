import 'package:bluetooth/tela-conectar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  BluetoothDevice? device;
  TextEditingController textEditingController = TextEditingController();
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  void _sendMessage(String message) {
    if (device != null) {
      try {
        bluetooth.write(message);
      } catch (error) {
        print("Erro ao enviar mensagem: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviar Mensagem Bluetooth'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                device != null ? '${device!.name} - ' : '',
                style: const TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelecionarDispositivo(
                        verificarDisponibilidade: true,
                        dispositivo: (conectado) {
                          setState(() {
                            device = conectado;
                          });
                        },
                      ),
                    ),
                  );
                },
                child: const Text('Conectar'),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para o Modo 1
                    },
                    child: const Text('Modo 1'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para o Modo 2
                    },
                    child: const Text('Modo 2'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para o Modo 3
                    },
                    child: const Text('Modo 3'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  hintText: 'Digite sua mensagem',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String message = textEditingController.text;
                  _sendMessage(message);
                },
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// class TelaPrincipal extends StatefulWidget{
//   @override
//   _TelaPrincipalState createState() => _TelaPrincipalState();
// }
//
// class _TelaPrincipalState extends State<TelaPrincipal>{
//
//   BluetoothDevice? device;
//   TextEditingController textEditingController = TextEditingController();
//
//
//   void _sendMessage() {
//     // if (device != null) {
//     //   String message = textEditingController.text;
//     //   bluetooth.write(message);
//     // }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Enviar Mensagem Bluetooth'),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: const EdgeInsets.only(top: 40),
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 '${device != null ? '${device!.name} - ' : ''}OSORIN',
//                 style: const TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: () {
//                   push(context, SelecionarDispositivo(
//                     verificarDisponibilidade: true,
//                     dispositivo: (conectado) {
//
//
//                     },
//                   ));
//                 },
//                 child: const Text('Conectar'),
//               ),
//               const SizedBox(height: 16.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       // Lógica para o Modo 1
//                     },
//                     child: const Text('Modo 1'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Lógica para o Modo 2
//                     },
//                     child: const Text('Modo 2'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Lógica para o Modo 3
//                     },
//                     child: const Text('Modo 3'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16.0),
//               TextField(
//                 controller: textEditingController,
//                 decoration: const InputDecoration(
//                   hintText: 'Digite sua mensagem',
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   _sendMessage();
//                 },
//                 child: const Text('Conectar e Enviar'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

  // Widget build(BuildContext context) {
  //   return SingleChildScrollView(
  //       child: Container(
  //         margin: EdgeInsets.only(top: 40),
  //         padding: EdgeInsets.all(16.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             Text(
  //               '${widget.conectado != null ? '${widget.conectado!.name} - ' : ''}OSORIN',
  //               style: const TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 16.0),
  //             ElevatedButton(
  //               onPressed: () {
  //                 // Navegar para a classe SelecionarDispositivo
  //                 push(context, SelecionarDispositivo(
  //                   verificarDisponibilidade: true, // Ou false, dependendo de suas necessidades
  //                   dispositivo: (conectado) {
  //                     // Implemente a lógica para lidar com o dispositivo selecionado aqui
  //                     // Você pode, por exemplo, abrir uma nova página para interagir com o dispositivo
  //
  //                   },
  //                 ));
  //               },
  //               child: const Text('Conectar'),
  //             ),
  //             const SizedBox(height: 16.0),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 ElevatedButton(
  //                   onPressed: () {
  //
  //                   },
  //                   child: const Text('Modo 1'),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //
  //                   },
  //                   child: const Text('Modo 2'),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //
  //                   },
  //                   child: const Text('Modo 3'),
  //                 ),
  //               ],
  //             ),
  //           ],
  //
  //      Scaffold(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           TextField(
  //             controller: textEditingController,
  //             decoration: InputDecoration(
  //               hintText: 'Digite sua mensagem',
  //             ),
  //           ),
  //           SizedBox(height: 20),
  //           ElevatedButton(
  //             onPressed: () async {
  //               await _connectToDevice();
  //               _sendMessage();
  //             },
  //             child: Text('Conectar e Enviar'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ),
  //         ),
  //
  //       ),
  //   );
  // }



