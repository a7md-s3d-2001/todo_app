import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var taskTitleController = TextEditingController();
  var taskTimeController = TextEditingController();
  var taskDateController = TextEditingController();
  var taskDescriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              elevation: 0.0,
              brightness: Brightness.dark,
            ),
            body: cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                  if (cubit.floatingActionButtonIsOpen) {
                    if (formKey.currentState!.validate()){
                      cubit.insertDatabase(
                          title: taskTitleController.text,
                          time: taskTimeController.text,
                          date: taskDateController.text,
                          description: taskDescriptionController.text,
                      );
                    }
                  } else {
                    scaffoldKey.currentState!.showBottomSheet((context) => Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildTextFormField(
                              title: 'Task Title',
                              icon: Icons.title,
                              validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return 'title must be not empty';
                                }
                                return null;
                              },
                              controller: taskTitleController,
                              onTap: () {},
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            buildTextFormField(
                              title: 'Task Time',
                              icon: Icons.watch_later_outlined,
                              validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return 'time must be not empty';
                                }
                                return null;
                              },
                              controller: taskTimeController,
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  taskTimeController.text =
                                      value!.format(context).toString();
                                });
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            buildTextFormField(
                              title: 'Task Date',
                              icon: Icons.calendar_today_outlined,
                              validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return 'date must be not empty';
                                }
                                return null;
                              },
                              controller: taskDateController,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2022-01-01'),
                                ).then((value) {
                                  taskDateController.text = DateFormat.yMMMd().format(value!);
                                });
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            buildTextFormField(
                              title: 'Task Description',
                              icon: Icons.description_outlined,
                              validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return 'description must be not empty';
                                }
                                return null;
                              },
                              controller: taskDescriptionController,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    )).closed.then((value){
                      cubit.changeFloatiogActionButton(value: false,);
                      taskTitleController.text = '';
                      taskTimeController.text = '';
                      taskDateController.text = '';
                      taskDescriptionController.text = '';
                    });
                  }

                  cubit.changeFloatiogActionButton(value: true,);
                },
              child: cubit.floatingActionButtonIsOpen? Icon(Icons.add,) : Icon(Icons.edit,),
              elevation: 0.0,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index){
               cubit.changeBottomNavgatorBar(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'New',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done_all_outlined),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archive',
                ),
              ],
              elevation: 0.0,
            ),
          );
        },
      ),
    );
  }
}
