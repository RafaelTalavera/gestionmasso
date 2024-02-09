import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Riesgo extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Form Builder Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('FormBuilder Basics'),
          // Añadir un botón de retroceso en el AppBar
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderCheckboxGroup(
                name: 'checkbox_group',
                options: [
                  FormBuilderFieldOption(value: 'option1'),
                  FormBuilderFieldOption(value: 'option2'),
                  FormBuilderFieldOption(value: 'option3'),
                ],
                onChanged: (values) {
                  print(values);
                },
                decoration: InputDecoration(labelText: 'Selecciona opciones'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.saveAndValidate()) {
                    print(_formKey.currentState!.value);
                  }
                },
                child: Text('Enviar formulario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
