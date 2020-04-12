import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:record_time_mcfil4/tela_lerpeca.dart';
import 'package:http/http.dart' as http;

class TelaTempo extends StatefulWidget {
  final String qrCodeArara;
  final String qrCodeMaquina;

  TelaTempo({this.qrCodeArara, this.qrCodeMaquina});

  @override
  _TelaTempoState createState() => _TelaTempoState();


}


class _TelaTempoState extends State<TelaTempo> {
  bool _iniciou = true;
  String _txtCronometro = '00:00:00';
  final _cronometro = new Stopwatch();
  final _timeout = const Duration(seconds: 1);
  String _qrMaquina = "";
  String _qrArara= "";
  List _parciais = [];
  String _parcial = "";
  var _horaInicio = "";
  var _horaFim = "";

  //DadosLidos dadoslidos1 = new DadosLidos();


  @override
  void initState() {
    super.initState();
    if(widget.qrCodeArara != null){
      _qrArara = widget.qrCodeArara;
      _qrMaquina = widget.qrCodeMaquina;
    } else{
      _qrArara= "Não recebeu o QRCode";
    }
  }


  @override
  Widget build(BuildContext context) {

    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    ScrollController _scrollController = new ScrollController();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('RECORD TIME APP'),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: larguraTela*0.9,
              height: alturaTela*0.15,
              padding: EdgeInsets.fromLTRB(50.0, 1.0, 60.0, 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    child: Padding(padding: EdgeInsets.all(10.0,),
                      child: Text ("Máquina: $_qrMaquina",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: larguraTela*0.035, fontWeight: FontWeight.bold, color: Colors.blueGrey,
                            backgroundColor: Colors.white70,)
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(padding: EdgeInsets.all(8.0,),
                      child: Text ("Arara: $_qrArara",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: larguraTela*0.035, fontWeight: FontWeight.bold, color: Colors.blueGrey,
                            backgroundColor: Colors.white70,)
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Card(
                child: Padding(padding: EdgeInsets.all(1.0),
                  child: Text ("Tempo de produção",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: larguraTela*0.038, fontWeight: FontWeight.bold, color: Colors.indigo,
                        backgroundColor: Colors.white70,)
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  ButtonTheme(
                    minWidth: larguraTela*0.8,
                    height: alturaTela*0.14,
                    buttonColor: _iniciou ? Colors.green : Colors.redAccent,
                    child: RaisedButton(
                      child: _iniciou ? Text("Iniciar", style: TextStyle(color: Colors.white, fontSize: larguraTela*0.07),) :
                      Text("Finalizar", style: TextStyle(color: Colors.white, fontSize: larguraTela*0.07)),
                      onPressed: (){
                        _startStopButtonPressed();
                      },
                    ),
                  ),

                  Card(
                    //borderOnForeground: true,
                    child: FittedBox(
                      fit: BoxFit.none,
                      child: Text(_txtCronometro, style: TextStyle(fontSize: larguraTela*0.06),),
                    ),
                  ),
                  Card(
                    color: Colors.white70,
                    child: SizedBox(
                      height: alturaTela*0.3,
                      width: larguraTela*1,
                      child: ListView.builder(
                          controller: _scrollController,
                          reverse: false,
                          shrinkWrap: true,
                          padding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                          itemCount: _parciais.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: EdgeInsets.fromLTRB(larguraTela*0.2, 1.0, larguraTela*0.18, 1.0),
                              title: Center(
                                //padding: const EdgeInsets.all(8.0),
                                child: Text("${_parciais[index]}", style: TextStyle(fontSize: larguraTela*0.034),),
                              ),
                            );
                          }
                      ),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: larguraTela*0.8,
                    height: alturaTela*0.14,
                    buttonColor: Colors.blueAccent,
                    child:  RaisedButton(
                        child: Text("Proxima manga", style: TextStyle(color: Colors.white, fontSize: larguraTela*0.07),),
                        onPressed: (){
                          _enviaParcialLista();
                          _parcial = _txtCronometro;
                          _enviarDadosLidos();
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 1),
                            curve: Curves.easeOut,
                          );
                        }
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }


  void _enviarDadosLidos({String codbarpeca, String codbarmaquina, String timeinicio, String timefim, String parcial}) async {
    var rota = "http://mcfil.dynamicrs.com.br/api/dadosbrutosparciais";
    var header = {"Content-Type" : "application/json"};

    Map dadosInicio = {
      "codbarpeca": _qrArara,
      "codbarmaquina": _qrMaquina,
      "timeinicio": _horaInicio,
      "timefim": "",
      "timeparcial": ""
    };

    Map dadosParcial = {
      "codbarpeca": _qrArara,
      "codbarmaquina": _qrMaquina,
      "timeinicio": _horaInicio,
      "timefim": "",
      "timeparcial": _parcial
    };

    Map dadosFim = {
      "codbarpeca": _qrArara,
      "codbarmaquina": _qrMaquina,
      "timeinicio": _horaInicio,
      "timefim": _horaFim,
      "timeparcial": _parcial
    };


    if ( _horaInicio != "" && _horaFim == "" && _parcial == ""){
      
      String _corpodadosInicio = json.encode(dadosInicio);
      await http.post(rota, headers: header, body: _corpodadosInicio);

      print("Json Enviado Inicio: $_corpodadosInicio");

    } else if ( _horaInicio != "" && _horaFim == "" && _parcial != ""){

      String _corpodadosParcial = json.encode(dadosParcial);
      await http.post(rota, headers: header, body: _corpodadosParcial);

      print("Json Enviado parcial: $_corpodadosParcial");

    } else {
      /* String _corpodadosParcial = json.encode(dadosParcial);
      await http.post(rota, headers: header, body: _corpodadosParcial); */

      String _corpodadosFim = json.encode(dadosFim);
      var resp = await http.post(rota, headers: header, body: _corpodadosFim);
      print(resp.body);
    }

  }


  void _enviaParcialLista ()  {
    setState(() {
      Map <String, dynamic> novaParcial = Map();
      novaParcial["timeparcial"] = _txtCronometro;
      _parciais.add(novaParcial);
      //print(_txtCronometro);
    });
  }

  void _startTimeout() {
    new Timer(_timeout, _handleTimeout);
  }

  void _handleTimeout() {
    if (_cronometro.isRunning) {
      _startTimeout();
    }
    setState(() {
      _setStopwatchText();
    });
  }

  void _startStopButtonPressed() {
    setState(() {
      if (_cronometro.isRunning) {
        _iniciou = true;
        _exibirConfirmacao(_qrMaquina);

      } else {
        _iniciou = false;
        _horaInicio = DateFormat("HH:mm:ss").format(DateTime.now());
        _enviarDadosLidos();
        _cronometro.start();
        _startTimeout();

      }
    });
  }

  void _resetButtonPressed(){
    if(_cronometro.isRunning){
      _startStopButtonPressed();
    }
    setState(() {
      _cronometro.reset();
      _setStopwatchText();
    });
  }

  void _setStopwatchText(){
    _txtCronometro = _cronometro.elapsed.inHours.toString().padLeft(2,'0') + ':'+
        (_cronometro.elapsed.inMinutes%60).toString().padLeft(2,'0') + ':' +
        (_cronometro.elapsed.inSeconds%60).toString().padLeft(2,'0');
  }

  void _exibirConfirmacao(qr) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Confirmação"),
          content: new Text("Confirma a finalização do processo?"),
          actions: <Widget>[
            // define os botões na base do dialogo
            FlatButton(
              child: Text("Sim"),
              onPressed: (){
                _horaFim = DateFormat("HH:mm:ss").format(DateTime.now());
                _enviaParcialLista();
                _parcial = _txtCronometro;
                Navigator.push(context, MaterialPageRoute(builder: (context) => TelaLerPeca(qrCodeMaquina: qr,)));
                _enviarDadosLidos();
                _parcial = "";
                _cronometro.stop();
                _resetButtonPressed();
              },
            ),
            FlatButton(
              child: Text("Não"),
              onPressed:(){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}