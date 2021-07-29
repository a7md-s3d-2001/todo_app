import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';

Widget buildTextFormField ({
  required String title,
  required TextEditingController controller,
  required IconData icon,
  required var validator,
  var onTap,
}) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: title,
      labelStyle: TextStyle(
        color: Colors.grey[400],
      ),
      prefixIcon: Icon(icon,),
      border: OutlineInputBorder(),
    ),
    controller: controller,
    onTap: onTap,
    keyboardType: TextInputType.text,
    validator: validator,
  );
}

Widget buildTaskItem (Map model, context) {
  AppCubit cubit = AppCubit.get(context);
  return Dismissible(
    key: Key(model['id'].toString()),
    child:  Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              child: Text(model['time']),
              radius: 40.0,
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model['title'],
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    model['date'],
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(model['description'],
                      style: TextStyle(
                        color: Colors.grey,
                      )),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    cubit.updateDatabase(
                      id: model['id'],
                      status: 'done',
                    );
                  },
                  icon: Icon(
                    Icons.check_box,
                    color: Colors.green,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    cubit.updateDatabase(
                      id: model['id'],
                      status: 'archive',
                    );
                  },
                  icon: Icon(
                    Icons.archive,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    cubit.updateDatabase(
                      id: model['id'],
                      status: 'new',
                    );
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    cubit.deleteDatabase(id: model['id']);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    onDismissed: (direction) {
      cubit.deleteDatabase(id: model['id']);
    },
  );
}

Widget noTasks () {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu, color: Colors.grey,size: 100.0,),
        Text('No Tasks yet, please add some tasks', style: TextStyle(
          color: Colors.grey,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),)
      ],
    ),
  );
}

Widget view (List<Map> tasks) {
  return tasks.length <= 0 ? noTasks() : ListView.separated(
    padding: const EdgeInsetsDirectional.all(10.0,),
    itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
    separatorBuilder: (context, index) => SizedBox(height: 10.0,),
    itemCount: tasks.length,
  );
}