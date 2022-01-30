import 'package:bubble_trouble/shared/components/components.dart';
import 'package:bubble_trouble/shared/cubit/cubit.dart';
import 'package:bubble_trouble/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.blue[200],
                  child: Center(
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        SafeArea(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Score: ${cubit.score}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        )),
                        ball(cubit),
                        missile(cubit),
                        myPlayer(cubit),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.green[800],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      controllerButton(
                          icon: cubit.playIcon,
                          onTap: () {
                            cubit.startGame(context);
                          }),
                      controllerButton(
                          icon: Icons.arrow_back,
                          onTap: () {
                            cubit.moveLeft();
                          }),
                      controllerButton(
                          icon: Icons.local_fire_department,
                          onTap: () {
                            cubit.fireMissile(context);
                          }),
                      controllerButton(
                          icon: Icons.arrow_forward,
                          onTap: () {
                            cubit.moveRight();
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
