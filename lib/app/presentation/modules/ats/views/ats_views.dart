import 'package:flutter/material.dart';

class AtsFormulario extends StatefulWidget {
  const AtsFormulario({super.key});
  @override
  State<AtsFormulario> createState() => _AtsFormulario(); {
  }

}

class _AtsFormulario extends State<AtsFormulario>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analiís de trabajos seguro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pop();
          },),
    ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // Color celeste claro
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AtsForm(),
          ),
        ),
      ),
    );
  }
}

class AtsForm extends StatefulWidget{
  @override
   _MyFormState createState() => _MyFormState(); 

  }

class _MyFormState extends State<AtsForm>{


  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}


