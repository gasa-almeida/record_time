import 'dart:convert';
//import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:majascan/majascan.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';
//import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:record_time_mcfil4/tela_lerpeca.dart';
import 'package:http/http.dart' as http;

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  void navigationToNextPage() {
    Navigator.pushReplacementNamed(context, '/HomePage');
  }

  //final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  //QRViewController controller;
  String qrCodeMaquina = "";
  String qR;


  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    //definição para bloquear o giro de tela
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Colors.white,
        body: Column(children: <Widget>[
             Container(
                width: larguraTela * 1.0,
                height: alturaTela * 0.25,
                padding: EdgeInsets.fromLTRB(
                    70.0, alturaTela * 0.01, 70.0, alturaTela * 0.01),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: new Image.asset(
                        'images/mcfill.jpg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                    70.0, alturaTela * 0.01, 70.0, alturaTela * 0.01),
                width: larguraTela * 1.0,
                height: alturaTela * 0.2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("RECORD TIME APP",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: larguraTela * 0.065,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            backgroundColor: Colors.white70,
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                    70.0, alturaTela * 0.01, 70.0, alturaTela * 0.01),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("Identificação da Máquina...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                            backgroundColor: Colors.white70,
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ButtonTheme(
                        height: alturaTela * 0.22,
                        minWidth: larguraTela * 0.7,
                        buttonColor: Colors.blueAccent,
                        child: RaisedButton(
                          onPressed: () async {
                            qrCodeMaquina = await MajaScan.startScan(
                                  title: "Leitura da Máquina",
                                  barColor: Colors.blue,
                                  titleColor: Colors.white,
                                  qRCornerColor: Colors.blue,
                                  qRScannerColor: Colors.lightBlueAccent,
                                  flashlightEnable: true
                              );
                            String solicitacao =
                                "http://mcfil.dynamicrs.com.br/api/maquinaexist/$qrCodeMaquina";
                            _validaMaquina(solicitacao);
                          },
                          child: Text(
                            "Iniciar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: larguraTela * 0.08,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.fromLTRB(100.0, 50.0, 100.0, 20.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "by",
                      style: TextStyle(fontSize: larguraTela * 0.04),
                    ),
                    Expanded(
                      child: new Image.asset('images/logo_dynamic.png',
                          width: larguraTela * 0.6,
                          height: alturaTela * 0.06,
                          fit: BoxFit.contain),
                    )
                  ],
                ),
              )
            ]),
          );
  }

  /*Future<String> scan({String a}) async {
    return a = await BarcodeScanner.scan();

  }*/

  /*void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCodeMaquina = scanData;
      });
    });
  }*/

/*  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }*/

  void _exibirTelaLerPeca({qr}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TelaLerPeca(
                  qrCodeMaquina: qr,
                )));
  }

  _validaMaquina(String solicitacao) async {
    bool resp = false;
    http.Response response = await http.get(solicitacao);
    resp = json.decode(response.body)["success"];

    if (resp== false){
      print("Máquina não não autenticada!");
    }else{
      print("Máquina Autenticada!");
    }

    if (resp == false) {

      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: new Text("Validação da Máquina"),
            content: new Text("A Máquina lida não está cadastrada no sistema."),
            actions: <Widget>[
              // define os botões na base do dialogo
              FlatButton(
                child: Text("Tentar novamente"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      _exibirTelaLerPeca(qr: qrCodeMaquina);

    }
  }
}
