import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juego del Gato'),
        actions: [
          IconButton(
            icon: Icon(Icons.gamepad),
            onPressed: () {
              context.read<GameProvider>().toggleGameMode();

              String modeMessage =
                  context.read<GameProvider>().isPlayingAgainstAI
                      ? 'Modo contra la IA activado'
                      : 'Modo multijugador activado';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(modeMessage),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, game, child) {
          String? winner = game.checkWinner();
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Jugador X: ${game.player1Score} - Jugador O: ${game.player2Score}',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  return GestureDetector(
                    onTap: () {
                      if (game.board[row][col] == null && winner == null) {
                        game.makeMove(row, col);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.grey[200],
                      ),
                      child: Center(
                        child: Text(
                          game.board[row][col] ?? '',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                winner == null
                    ? 'Turno de: ${game.isPlayer1Turn ? "Jugador X" : "Jugador O"}'
                    : winner == 'Empate'
                        ? '¡Empate!'
                        : '¡${winner} ganó!',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  game.resetBoard();
                },
                child: Text('Reiniciar Juego'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  game.resetScores();
                },
                child: Text('Reiniciar Puntajes'),
              ),
            ],
          );
        },
      ),
    );
  }
}
