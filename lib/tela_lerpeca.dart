import 'dart:io';
//import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:majascan/majascan.dart';
import 'package:record_time_mcfil4/tela_tempo.dart';


class TelaLerPeca extends StatefulWidget {

  final String qrCodeMaquina ;
  TelaLerPeca({this.qrCodeMaquina});

  @override
  _TelaLerPecaState createState() => _TelaLerPecaState();

}

class _TelaLerPecaState extends State<TelaLerPeca> {

  //SplashPage page = new SplashPage();
  String _qrMaquina;
  String qrArara = "";
  String qr;


  @override
  void initState() {
    super.initState();
    if(widget.qrCodeMaquina != null){
      _qrMaquina = widget.qrCodeMaquina;
    } else{
      _qrMaquina = "Não recebeu o QRCode";
    }
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('RECORD TIME APP'),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,//mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(60.0, 5.0, 60.0, 5),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    child: Padding(padding: EdgeInsets.all(10.0,),
                      child: Text ("Máquina: $_qrMaquina",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: larguraTela*0.04, fontWeight: FontWeight.bold, color: Colors.blueGrey,
                            backgroundColor: Colors.white70,)
                      ),
                    ),
                  ),
                  Container(
                    width: larguraTela*0.6,
                    height: alturaTela*0.25,
                    padding: EdgeInsets.fromLTRB(10.0, 100.0, 10.0, 10.0),
                    child: Card(
                      child: Padding(padding: EdgeInsets.all(10.0,),
                        child: Text ("Leitura da Arara",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: larguraTela*0.04, fontWeight: FontWeight.bold, color: Colors.indigo,
                              backgroundColor: Colors.white70,)
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
                height: alturaTela*0.3,
                width: larguraTela*1,
                padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ButtonTheme(
                      height: alturaTela*0.2,
                      minWidth: larguraTela*0.8,
                      buttonColor: Colors.green,
                      child: RaisedButton(
                        onPressed:() async {
                          qrArara = await MajaScan.startScan(
                              title: "Leitura da Peça",
                              barColor: Colors.red,
                              titleColor: Colors.white,
                              qRCornerColor: Colors.redAccent,
                              qRScannerColor: Colors.deepOrangeAccent,
                              flashlightEnable: true
                          );
                          _exibirTelaTempo(qr1: _qrMaquina, qr2: qrArara);
                        },
                        child: Text ("Iniciar",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: larguraTela*0.09, color: Colors.white,),),
                      ),
                    ),
                  ],
                )
            ),
            Container(
                height: alturaTela*0.2,
                width: larguraTela*1,
                padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ButtonTheme(
                      height: 100.0,
                      minWidth: 200.0,
                      buttonColor: Colors.redAccent,
                      child: RaisedButton(
                        onPressed:() async {
                          exit(0);
                        },
                        child: Text ("Sair",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: larguraTela*0.09, color: Colors.white,),),
                      ),
                    ),
                  ],
                )
            ),
          ],
        )
    );
  }

 /* Future<String> scan({String a}) async {
    return a = await BarcodeScanner.scan();
  }*/

  void _exibirTelaTempo({qr1, qr2}){
    Navigator.push(context, MaterialPageRoute(builder: (context) => TelaTempo(qrCodeMaquina: _qrMaquina,qrCodeArara: qrArara)));
  }

}
