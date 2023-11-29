import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'botao_azul.dart';

class SelecionarDispositivo extends StatefulWidget {
  final bool verificarDisponibilidade;
  final Function(BluetoothDevice) dispositivo;

  SelecionarDispositivo({
    this.verificarDisponibilidade = true,
    required this.dispositivo,
  });

  @override
  _SelecionarDispositivoState createState() => _SelecionarDispositivoState();
}

class _SelecionarDispositivoState extends State<SelecionarDispositivo> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDevice> dispositivos = [];
  late bool _estaDescobrindo;
  Set<String> dispositivosDescobertos = Set<String>();

  @override
  void initState() {
    super.initState();
    _estaDescobrindo = widget.verificarDisponibilidade;
    _inicializarBluetooth();
  }

  void _inicializarBluetooth() {
    _iniciarDescoberta();
    _obterDispositivosVinculados();
  }

  void _obterDispositivosVinculados() async {
    try {
      final dispositivosVinculados = await bluetooth.getBondedDevices();
      setState(() {
        dispositivos = dispositivosVinculados;
      });
    } catch (error) {
      print("Erro ao obter dispositivos emparelhados: $error");
    }
  }

  void _reiniciarDescoberta() {
    dispositivosDescobertos.clear();
    dispositivos.clear();
    setState(() {
      _estaDescobrindo = true;
    });
    _iniciarDescoberta();
  }

  void _iniciarDescoberta() {
    _estaDescobrindo = true;
    bluetooth.startDiscovery().listen((BluetoothDiscoveryResult r) {
      setState(() {
        final dispositivo = r.device;
        if (!dispositivosDescobertos.contains(dispositivo.address)) {
          dispositivosDescobertos.add(dispositivo.address);
          dispositivos.add(dispositivo);
        }
      });
    }).onDone(() {
      setState(() {
        _estaDescobrindo = false;
      });
    });
  }

  @override
  void dispose() {
    bluetooth.cancelDiscovery();
    super.dispose();
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      await bluetooth.connect(device);
    } catch (error) {
      print("Erro ao conectar ao dispositivo: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar dispositivo'),
        actions: <Widget>[
          _estaDescobrindo
              ? FittedBox(
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.replay),
                  onPressed: _reiniciarDescoberta,
                )
        ],
      ),
      body: ListView.builder(
        itemCount: dispositivos.length,
        itemBuilder: (context, index) {
          final dispositivo = dispositivos[index];
          return ListTile(
            leading: const Icon(Icons.devices),
            title: Text(dispositivo.name ?? 'Dispositivo sem nome'),
            subtitle: Text(dispositivo.address.toString()),
            trailing: BotaoAzul(
              texto: "Conectar",
              ao_clicar: () {
                _connectToDevice(dispositivo);
                widget.dispositivo(dispositivo);
                Navigator.pop(context);
              },
              cor_fonte: Colors.greenAccent,
            ),
          );
        },
      ),
    );
  }
}

// class SelecionarDispositivo extends StatefulWidget {
//   final bool verificarDisponibilidade;
//   final Function dispositivo;
//   SelecionarDispositivo({
//     this.verificarDisponibilidade = true,
//     required this.dispositivo,
//   });
//   @override
//   _SelecionarDispositivoState createState() => _SelecionarDispositivoState();
// }
//
// class _SelecionarDispositivoState extends State<SelecionarDispositivo> {
//   FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
//   List<BluetoothDevice> dispositivos = [];
//   late bool _estaDescobrindo;
//   Set<String> dispositivosDescobertos = Set<String>();
//
//   @override
//   void initState() {
//     super.initState();
//     _estaDescobrindo = widget.verificarDisponibilidade;
//     if (_estaDescobrindo) {
//       _iniciarDescoberta();
//     }
//     FlutterBluetoothSerial.instance.getBondedDevices().then((List<BluetoothDevice> dispositivosVinculados) {
//       setState(() {
//         dispositivos = dispositivosVinculados;
//       });
//     });
//   }
//
//   void _reiniciarDescoberta() {
//     dispositivosDescobertos.clear();
//     dispositivos.clear();
//     setState(() {
//       _estaDescobrindo = true;
//     });
//     _iniciarDescoberta();
//   }
//
//   void _iniciarDescoberta() {
//     _estaDescobrindo = true;
//     FlutterBluetoothSerial.instance.startDiscovery().listen((BluetoothDiscoveryResult r) {
//       setState(() {
//         final dispositivo = r.device;
//         if (!dispositivosDescobertos.contains(dispositivo.address)) {
//           dispositivosDescobertos.add(dispositivo.address);
//           dispositivos.add(dispositivo);
//         }
//       });
//     }).onDone(() {
//       setState(() {
//         _estaDescobrindo = false;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     FlutterBluetoothSerial.instance.cancelDiscovery();
//     super.dispose();
//   }
//
//   Future<void> _connectToDevice() async {
//     if (dispositivos.isNotEmpty) {
//       // Substitua "DeviceName" pelo nome do dispositivo Bluetooth que você deseja conectar
//       BluetoothDevice? desiredDevice;
//       for (var device in dispositivos) {
//         if (device.name == "HC-05") {
//           desiredDevice = device;
//           break;
//         }
//       }
//       if (desiredDevice != null) {
//         try {
//           await bluetooth.connect(desiredDevice);
//         } catch (error) {
//           print("Erro ao conectar ao dispositivo: $error");
//         }
//       } else {
//         print("Dispositivo não encontrado.");
//       }
//     } else {
//       print("Nenhum dispositivo emparelhado encontrado.");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Selecionar dispositivo'),
//         actions: <Widget>[
//           _estaDescobrindo
//               ? FittedBox(
//             child: Container(
//               margin: EdgeInsets.all(16.0),
//               child: const CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(
//                   Colors.white,
//                 ),
//               ),
//             ),
//           )
//               : IconButton(
//             icon: Icon(Icons.replay),
//             onPressed: _reiniciarDescoberta,
//           )
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: dispositivos.length,
//         itemBuilder: (context, index) {
//           final dispositivo = dispositivos[index];
//           return ListTile(
//             leading: const Icon(Icons.devices),
//             title: Text(dispositivo.name ?? 'Dispositivo sem nome'),
//             subtitle: Text(dispositivo.address.toString()),
//             trailing: BotaoAzul(
//               texto: "Conectar",
//               ao_clicar: () {
//                 _connectToDevice();
//                 widget.dispositivo(dispositivo);
//                 pop(context);
//               },
//               cor_fonte: Colors.greenAccent,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

//EXPLICAÇOES NECESSARIAS LER!!!
/*
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class SelecionarDispositivo extends StatefulWidget {
  final bool verificarDisponibilidade;
  final Function naPaginaChat;

  SelecionarDispositivo({
    this.verificarDisponibilidade = true,
    required this.naPaginaChat,
  });

  @override
  _SelecionarDispositivoState createState() => _SelecionarDispositivoState();
}

Nesta seção, estamos importando os pacotes necessários e definindo a classe SelecionarDispositivo como um StatefulWidget.
Essa classe aceita dois parâmetros: verificarDisponibilidade (um valor booleano para indicar se a descoberta de dispositivos deve ser feita)
e naPaginaChat (uma função que será chamada quando um dispositivo for tocado na lista).
 */

/*
class _SelecionarDispositivoState extends State<SelecionarDispositivo> {
  List<BluetoothDevice> dispositivos = [];
  late bool _estaDescobrindo;

Aqui, estamos criando a classe _SelecionarDispositivoState, que é o estado associado ao SelecionarDispositivo.
Estamos definindo duas variáveis: dispositivos para armazenar a lista de dispositivos Bluetooth e _estaDescobrindo para controlar
se a descoberta de dispositivos está ocorrendo.
 */

/*
  @override
  void initState() {
    super.initState();

    _estaDescobrindo = widget.verificarDisponibilidade;

    if (_estaDescobrindo) {
      _iniciarDescoberta();
    }

    FlutterBluetoothSerial.instance.getBondedDevices().then((List<BluetoothDevice> dispositivosVinculados) {
      setState(() {
        dispositivos = dispositivosVinculados;
      });
    });
  }

No método initState, estamos configurando o estado inicial. Definimos _estaDescobrindo com base no valor passado via widget.verificarDisponibilidade.
Se a descoberta estiver ativada, chamamos _iniciarDescoberta() para iniciar a descoberta de dispositivos Bluetooth.
Também estamos obtendo os dispositivos vinculados usando FlutterBluetoothSerial.instance.getBondedDevices() e atualizando a lista dispositivos.
 */

/*
  void _reiniciarDescoberta() {
    setState(() {
      _estaDescobrindo = true;
    });
    _iniciarDescoberta();
  }

  void _iniciarDescoberta() {
    FlutterBluetoothSerial.instance.startDiscovery().listen((BluetoothDiscoveryResult r) {
      setState(() {
        dispositivos.add(r.device);
      });
    }).onDone(() {
      setState(() {
        _estaDescobrindo = false;
      });
    });
  }

Os métodos _reiniciarDescoberta() e _iniciarDescoberta() são usados para iniciar a descoberta de dispositivos Bluetooth.
_reiniciarDescoberta() configura _estaDescobrindo como verdadeiro e chama _iniciarDescoberta() para iniciar a descoberta.
O método _iniciarDescoberta() inicia a descoberta de dispositivos Bluetooth usando FlutterBluetoothSerial.instance.startDiscovery().listen().
Quando um dispositivo é descoberto, ele é adicionado à lista dispositivos, e quando a descoberta é concluída (indicado por onDone()), _estaDescobrindo é definido como falso.
 */

/*
  @override
  void dispose() {
    // Cancelar a descoberta ao sair da página
    FlutterBluetoothSerial.instance.cancelDiscovery();
    super.dispose();
  }

O método dispose() é usado para cancelar a descoberta de dispositivos Bluetooth quando a página é descartada para evitar vazamentos de recursos.
 */

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecionar dispositivo'),
        actions: <Widget>[
          _estaDescobrindo
              ? FittedBox(
                  child: Container(
                    margin: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: _reiniciarDescoberta,
                )
        ],
      ),
      body: ListView.builder(
        itemCount: dispositivos.length,
        itemBuilder: (context, index) {
          final dispositivo = dispositivos[index];
          return ListTile(
            title: Text(dispositivo.name ?? 'Dispositivo sem nome'),
            subtitle: Text(dispositivo.address),
            onTap: () {
              widget.naPaginaChat(dispositivo);
            },
          );
        },
      ),
    );
  }
}

No método build(), estamos criando a interface do usuário.
Usamos um Scaffold com uma barra de aplicativo que exibe o título "Selecionar dispositivo"
e um ícone de recarga se a descoberta estiver em andamento, ou um ícone de repetição se a descoberta estiver pausada.
A lista de dispositivos é exibida em um ListView.builder() onde cada dispositivo
é representado por um ListTile com o nome, endereço e uma função de toque para widget.naPaginaChat(dispositivo).
 */
