import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubit/cubit.dart';
import 'package:notes_app/cubit/states.dart';
import 'package:notes_app/note_model.dart';

import 'components/component.dart';
import 'notes_home.dart';

class EditNotes extends StatelessWidget {
  const EditNotes({Key? key, required this.model}) : super(key: key);
  final NoteModel model;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteCubit, NoteStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var titlecontroller = TextEditingController();
        var detailscontroller = TextEditingController();
        titlecontroller.text = model.title;
        detailscontroller.text = model.subTitle;
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                appbar_custom(
                    text: 'Edit Note',
                    icon: Icons.check,
                    function: () {
                      NoteCubit.get(context).updateNote(
                          model, titlecontroller.text, detailscontroller.text);
                      Navigator.pop(context);
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: DefaultFormField(
                      validate: (String? validate) {
                        if (validate!.isEmpty) {
                          return 'title can\'t be empty';
                        }
                        return null;
                      },
                      controller: titlecontroller,
                      label: 'Title'),
                ),
                DefaultFormField(
                    validate: (String? validate) {
                      if (validate!.isEmpty) {
                        return 'details can\'t be empty';
                      }
                      return null;
                    },
                    controller: detailscontroller,
                    label: 'details',
                    maxlines: 6),
              ],
            ),
          ),
        );
      },
    );
  }
}
