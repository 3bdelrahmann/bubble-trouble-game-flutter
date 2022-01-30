import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bubble_trouble/shared/components/constants.dart';
import 'package:bubble_trouble/shared/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  // Player variables
  double playerX = 0.0;

  // Missile variables
  double missileX = 0.0;
  double missileHeight = 10.0;
  bool shot = false;

  // Ball variables
  double ballX = 0.0;
  double ballY = 0.0;
  var ballDirection = directions.LEFT;

  // Score counter
  int score = 0;

  // Play icon variables
  IconData playIcon = Icons.play_arrow;
  bool isPlay = false;

  // Press start button counter;
  int pressCounter = 0;

  void moveLeft() {
    if (playerX - 0.1 > -1) {
      playerX -= 0.1;
    }

    //to make the missile stay in its direction when it is in the middle of a shot
    if (!shot) {
      missileX = playerX;
    }
    emit(AppMovePlayerState());
  }

  void moveRight() {
    if (playerX + 0.1 < 1) {
      playerX += 0.1;
    }
    //to make the missile stay in its direction when it is in the middle of a shot
    if (!shot) {
      missileX = playerX;
    }
    emit(AppMovePlayerState());
  }

  void fireMissile(BuildContext context) {
    if (!shot) {
      Timer.periodic(Duration(milliseconds: 50), (timer) {
        // shot fired
        shot = true;

        // missile grows till it hits the top of the screen
        missileHeight += 10;

        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          // stop missile when it reaches the top of the screen
          resetMissile();
          timer.cancel();
        }
        // Check if missile has hit the ball
        if (ballY > heightToPosition(missileHeight, context) &&
            ((ballX - missileX).abs() < 0.03)) {
          resetMissile();
          ballX = 5;
          getPoints();
          timer.cancel();
        }

        emit(AppFireMissileState());
      });
    }
  }

  void resetMissile() {
    missileX = playerX;
    missileHeight = 10.0;
    shot = false;
    emit(AppResetMissileState());
  }

  void startGame(BuildContext context) {
    double time = 0;
    double height = 0;
    double velocity = 60; // How strong the ball jump
    score = 0;
    isPlay = true;
    pressCounter += 1; //pressed one time
    changePlayButton();

    Timer.periodic(Duration(milliseconds: 10), (timer) {
      // Quadratic equation that models a bounce (upside down parabola)
      height = -5 * time * time + velocity * time;

      // If the ball reaches the ground, reset the jump
      if (height < 0) {
        time = 0;
      }

      // Update new ball position
      ballY = heightToPosition(height, context);
      emit(AppMoveBallState());

      // If the ball hits the left wall, then change the direction to right
      if (ballX - 0.05 < -1) {
        ballDirection = directions.RIGHT;
        // If the ball hits the right wall, then change the direction to left
      } else if (ballX + 0.05 > 1) {
        ballDirection = directions.LEFT;
      }

      // Move the ball in the correct direction
      if (ballDirection == directions.LEFT) {
        ballX -= 0.05;
        emit(AppMoveBallState());
      } else if (ballDirection == directions.RIGHT) {
        ballX += 0.05;
        emit(AppMoveBallState());
      }
      // Keep the time going!
      time += 0.1;

      //check if the ball hits the player
      if (playerDies()) {
        timer.cancel();
        showDialog(
            context: context,
            builder: (context) {
              return Center(
                  child: Container(
                height: 150.0,
                width: 300.0,
                child: Card(
                  color: Colors.grey[700],
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Game over!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                        ),
                      ),
                      Text(
                        'Score : $score',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          startGame(context);
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ));
            });
      }

      //check if the pause button pressed
      if (pressCounter == 2) {
        timer.cancel();
        isPlay = false;
        changePlayButton();
      }
      if (pressCounter == 3) {
        pressCounter = 0;
        startGame(context);
      }
    });
  }

  // Converts height to a position
  double heightToPosition(double height, BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  bool playerDies() {
    // If the ball position and the player position are the same, then player dies
    if ((ballX - playerX).abs() < 0.05 && ballY > 0.95) {
      return true;
    } else {
      return false;
    }
  }

  void getPoints() {
    score += 1;
    emit(AppChangeScoreState());
  }

  void changePlayButton() {
    if (isPlay) {
      playIcon = Icons.close;
    } else {
      playIcon = Icons.play_arrow;
    }
    emit(AppChangePlayButtonState());
  }
}
