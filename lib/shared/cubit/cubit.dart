import 'package:todo_app/modules/archive_tasks/archive_tasks.dart';
import 'package:todo_app/modules/done_tasks/done_tasks.dart';
import 'package:todo_app/modules/new_tasks/new_tasks.dart';
import 'package:todo_app/shared/cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bloc/bloc.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool floatingActionButtonIsOpen = false;
  void changeFloatiogActionButton({required bool value}) {
    floatingActionButtonIsOpen = value;
    emit(AppChangeFloationActionButtonState());
  }

  int currentIndex = 0;
  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchiveTasks(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];
  void changeBottomNavgatorBar(index) {
    currentIndex = index;
    emit(AppChangeBottomNavgatorBarState());
  }

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('Created database');
        database
            .execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, description TEXT, status TEXT)',
        )
            .then((value) {
          print('Created Table');
        }).catchError((error) {
          print('error when created Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('Database Opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
      getDataFromDatabase(database);
    });
  }

  insertDatabase({
    required String title,
    required String time,
    required String date,
    required String description,
  }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tasks (title, time, date, description, status) VALUES ("$title", "$time", "$date", "$description", "new")',
      )
          .then((value) {
        print('$value record inserted');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('record not inserted because ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archiveTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateDatabase({
    required String status,
    required int id,
  }) async {
    database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', ['$status', id]).then((value) {
      print ('$value updated');
      getDataFromDatabase(database);
      emit(AppUpdateDataBaseState());
    }).catchError((error){
      print ('not updated because ${error.toString()}');
    });
  }

  void deleteDatabase({
    required int id,
  }) async {
    database?.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      print('$value it is deleted');
      getDataFromDatabase(database);
      emit((AppDeleteDatabaseState()));
    }).catchError((error){
      print ('not deleted because ${error.toString()}');
    });
  }
}
