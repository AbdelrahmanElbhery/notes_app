import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:notes_app/components/component.dart';
import 'package:notes_app/cubit/cubit.dart';
import 'package:notes_app/cubit/states.dart';
import 'package:notes_app/note_model.dart';

import 'edit_notes.dart';

class NotesHome extends StatelessWidget {
  const NotesHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteCubit, NoteStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .06,
                ),
                appbar_custom(
                  function: () {},
                  text: 'Notes',
                  icon: Icons.search,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: NoteCubit.get(context).notes?.length,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        itemBuilder: (context, index) => note_body(
                            model: NoteCubit.get(context).notes![index])))
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  context: context,
                  builder: (context) => Form(child: note_add()));
            },
            child: Icon(
              Icons.add,
              size: 30,
            ),
          ),
        );
      },
    );
  }
}

class note_body extends StatelessWidget {
  const note_body({
    super.key,
    required this.model,
  });
  final NoteModel model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          navigate_to(
              context: context,
              widget: EditNotes(
                model: model,
              ));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Color(model.color),
              borderRadius: BorderRadius.circular(17)),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                title: Text(
                  model.title,
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    model.subTitle,
                    style: TextStyle(fontSize: 18, color: Colors.black38),
                  ),
                ),
                trailing: IconButton(
                    onPressed: () {
                      NoteCubit.get(context).deleteNote(model);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.black,
                      size: 30,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0, top: 25),
                child: Text(
                  '${DateFormat.yMMMd().format(DateTime.parse(model.date))}',
                  style: TextStyle(fontSize: 14, color: Colors.black38),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class note_add extends StatefulWidget {
  note_add({Key? key}) : super(key: key);

  @override
  State<note_add> createState() => _note_addState();
}

class _note_addState extends State<note_add> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  var titlecontroller = TextEditingController();
  var detailscontroller = TextEditingController();
  int selectedindex = 0;
  List<Color> colors = [
    Color(0xff795C5F),
    Color(0xffA69658),
    Color(0xffD9B26F),
    Color(0xffFADF7F),
    Color(0xffF2E29F),
  ];
  Color selectedcolor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: formkey,
          child: Column(
            children: [
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Container(
                  height: 38 * 2,
                  child: ListView.builder(
                      itemCount: colors.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedindex = index;
                                selectedcolor = colors[index];
                                print(selectedcolor.value);
                              });
                            },
                            child: colorslists(
                              colors: colors[index],
                              selected: index == selectedindex,
                            ),
                          )),
                ),
              ),
              DefaultButton(
                  function: () {
                    if (formkey.currentState!.validate()) {
                      var newmodel = NoteModel(
                          title: titlecontroller.text,
                          subTitle: detailscontroller.text,
                          date: DateTime.now().toString(),
                          color: selectedcolor.value);
                      NoteCubit.get(context).AddNote(newmodel);
                      Navigator.pop(context);
                    }
                  },
                  text: 'add',
                  containerheight: MediaQuery.of(context).size.height * .045),
            ],
          ),
        ),
      ),
    );
  }
}

class colorslists extends StatelessWidget {
  const colorslists({
    super.key,
    required this.selected,
    required this.colors,
  });
  final bool selected;
  final Color colors;
  @override
  Widget build(BuildContext context) {
    return selected
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 38,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 36,
                backgroundColor: colors,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: colors,
            ),
          );
  }
}

class appbar_custom extends StatelessWidget {
  const appbar_custom({
    super.key,
    required this.text,
    required this.icon,
    required this.function,
  });
  final String text;
  final IconData icon;
  final VoidCallback function;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.black26, borderRadius: BorderRadius.circular(20)),
          child: IconButton(
              onPressed: function,
              icon: Icon(
                icon,
                size: 30,
              )),
        )
      ],
    );
  }
}
