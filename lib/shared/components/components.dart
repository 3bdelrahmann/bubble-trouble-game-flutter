import 'package:bubble_trouble/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';

Widget controllerButton({required IconData icon, required Function() onTap}) =>
    InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[400],
        ),
        height: 50.0,
        width: 50.0,
        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),
    );

Widget myPlayer(AppCubit cubit) => Align(
      alignment: Alignment(cubit.playerX, 1),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadiusDirectional.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        height: 50.0,
        width: 30.0,
      ),
    );

Widget missile(AppCubit cubit) => Align(
      alignment: Alignment(cubit.missileX, 1.0),
      child: Container(
        color: Colors.brown[700],
        height: cubit.missileHeight,
        width: 3.0,
      ),
    );

Widget ball(AppCubit cubit) => Align(
    alignment: Alignment(cubit.ballX, cubit.ballY),
    child: CircleAvatar(
      radius: 14.0,
      backgroundColor: Colors.deepOrange,
    ));
