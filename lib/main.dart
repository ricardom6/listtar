import 'dart:convert';
import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


void main() => runApp(
    MaterialApp(
      home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDoController = TextEditingController();


  List _toDoList = [
    //"Tarefa A", "Tarefa B",
    //"Tarefa C", "Tarefa D",
  ];
  void _addToDo(){
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["titulo"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["status"] = false;
      newToDo["inicio"] = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy ]);
      _toDoList.add(newToDo);
    });
  }

  //obter dados
  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  //salvar dados
  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  //ler o arquivo de dados
  Future<File> _getFile() async{
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/dados_tarefa.json");
  }

  @override
  Widget build(BuildContext context) {
    //configurando o appBar
    AppBar appBar = AppBar(
      title: Text("Lista de Tarefas"),
      backgroundColor: Colors.black26,
      centerTitle: true,
    );

    TextField textField = TextField(
      controller: _toDoController,
      decoration: InputDecoration(
        labelText: "Nova Tarefa",
        labelStyle: TextStyle(color: Colors.black),
      ),
    );
        RaisedButton btnAdd = RaisedButton(
          onPressed: _addToDo,
          color: Colors.black,
          child: Text("ADD"),
          textColor: Colors.white,
    );

    //pag 82
    //configurando a linha do input e button
    Row row = Row(
      children: <Widget>[
        Expanded(child: textField),
        btnAdd,
      ],
    );

    //configurando o container do topo
    Container containerTop = Container(
      padding: EdgeInsets.fromLTRB(18.0, 1.0, 6.0, 1.0),
      child: row,
    );
    ListView listViewTarefas = ListView.builder(
      padding: EdgeInsets.only(top:10.0),
      itemCount: _toDoList.length,
      itemBuilder: (context, index){
        return CheckboxListTile(
          title: Text(_toDoList[index]["titulo"]),
          value: false,
          secondary: CircleAvatar(
            child: Icon(Icons.check),
          ),
        );
      },
    );



    //configurando a coluna
    Column column = Column(
      children: <Widget> [
        containerTop,
        Expanded(          child: listViewTarefas,)
      ],
    );

    //configurando o elemento na tela
    Scaffold scaffold = Scaffold(
      appBar: appBar,
      backgroundColor: Colors.cyan,
      body: column,
    );
    return scaffold;
  }
}
