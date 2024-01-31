import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class Habit {
  final String name;
  bool isCompleted;

  Habit(this.name, this.isCompleted);
}

class HabitsBloc {
  final List<Habit> _habits = [];
  final _habitsController = StreamController<List<Habit>>();

  Stream<List<Habit>> get habitsStream => _habitsController.stream;

  List<Habit> get habits => _habits;

  void addHabit(String name) {
    _habits.add(Habit(name, false));
    _habitsController.sink.add(_habits);
  }

  void toggleHabit(int index) {
    _habits[index].isCompleted = !_habits[index].isCompleted;
    _habitsController.sink.add(_habits);
  }

  void dispose() {
    _habitsController.close();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seguimiento de Hábitos',
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
          accentColor: Colors.orange,
        ),
      ),
      home: HabitTrackerPage(),
    );
  }
}

class HabitTrackerPage extends StatefulWidget {
  @override
  _HabitTrackerPageState createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
  final _habitsBloc = HabitsBloc();
  final _habitNameController = TextEditingController();

  @override
  void dispose() {
    _habitsBloc.dispose();
    _habitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seguimiento de Hábitos'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _habitNameController,
                    decoration: InputDecoration(
                      labelText: 'Agregar Hábito',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _habitsBloc.addHabit(_habitNameController.text);
                    _habitNameController.clear();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Habit>>(
              stream: _habitsBloc.habitsStream,
              initialData: [],
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].name),
                      trailing: Checkbox(
                        value: snapshot.data![index].isCompleted,
                        onChanged: (_) {
                          _habitsBloc.toggleHabit(index);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
