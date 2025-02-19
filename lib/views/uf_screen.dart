import 'package:flutter/material.dart';
import '/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

class UfScreen extends StatefulWidget {
  const UfScreen({super.key});

  @override
  _UfScreenState createState() => _UfScreenState();
}

class _UfScreenState extends State<UfScreen> {
  final _formKey = GlobalKey<FormState>();
  final _empresaController = TextEditingController();
  final _ufController = TextEditingController();
  List<Map<String, dynamic>> empresas = [];

  void _agregarEmpresa() async {
    if (_formKey.currentState!.validate()) {
      final nombreEmpresa = _empresaController.text;
      final cantidadUF = double.tryParse(_ufController.text) ?? 0;

      if (cantidadUF > 0) {
        try {
          final valorUF = await ApiService.getUfValue();
          final valorPesos = cantidadUF * valorUF;

          setState(() {
            empresas.add({
              'nombre': nombreEmpresa,
              'uf': cantidadUF,
              'pesos': valorPesos,
            });
          });

          _empresaController.clear();
          _ufController.clear();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al obtener el valor de la UF')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La cantidad de UF debe ser mayor a 0')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 63, 80, 175),
        title: Text(
          'Convertidor UF',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _empresaController,
                        decoration: InputDecoration(
                          labelText: 'Nombre de la empresa',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el nombre de la empresa';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _ufController,
                        decoration: InputDecoration(
                          labelText: 'Cantidad de UF',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa la cantidad de UF';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _agregarEmpresa,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 63, 80, 175),
                        ),
                        child: Icon(Icons.add, size: 24, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //SizedBox(height: 24),
            Flexible(
              child: ListView.builder(
                itemCount: empresas.length,
                itemBuilder: (context, index) {
                  final empresa = empresas[index];
                  return ListTile(
                    title: Text(empresa['nombre']),
                    subtitle: Text(
                      '${empresa['uf']} UF = \$${empresa['pesos'].toInt()} CLP',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
