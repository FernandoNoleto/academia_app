import 'package:flutter/material.dart';


class SetExerciseForm extends StatefulWidget {
  final formKey;
  final TextEditingController intervalInputController;
  final TextEditingController repetitionsInputController;
  final TextEditingController seriesInputController;

  const SetExerciseForm({
    Key? key,
    required this.formKey,
    required this.intervalInputController,
    required this.repetitionsInputController,
    required this.seriesInputController,
  }) : super(key: key);

  @override
  State<SetExerciseForm> createState() => _SetExerciseFormState();
}

class _SetExerciseFormState extends State<SetExerciseForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 10),
          TextFormField(
            controller: widget.repetitionsInputController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Quantidade de repetições',
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.blue)
              ),
              filled: true,
              contentPadding:
              EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
              labelText: "Repetições",
              prefixIcon: Icon(
                Icons.repeat_outlined,
                color: Colors.blue,
              ),
            ),
            validator: (String? repetitions) {
              if (repetitions == null || repetitions.isEmpty) {
                return 'Numero inválido';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: widget.intervalInputController,
            decoration: const InputDecoration(
              hintText: 'Insira o intervalo',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Colors.blue),

              ),
              filled: true,
              contentPadding:
              EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
              labelText: "Intervalo",
              prefixIcon: Icon(
                Icons.pause_outlined,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 10,),
          TextFormField(
            controller: widget.seriesInputController,
            decoration: const InputDecoration(
              hintText: 'Insira o número de séries',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Colors.blue),

              ),
              filled: true,
              contentPadding:
              EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
              labelText: "Séries",
              prefixIcon: Icon(
                Icons.linear_scale_outlined,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
