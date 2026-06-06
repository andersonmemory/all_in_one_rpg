import 'dart:async';
import 'package:flutter/material.dart';
import 'models/player_model.dart';
import 'widgets/card_widget/card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Player> _players = [];
  String? _selectedPlayerId;
  bool _isPaused = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          for (var player in _players) {
            if (player.id != _selectedPlayerId) {
              player.secondsWaiting++;
            }
          }
          // Sort after incrementing
          _sortPlayers();
        });
      }
    });
  }

  void _sortPlayers() {
    _players.sort((a, b) => a.secondsWaiting.compareTo(b.secondsWaiting));
  }

  void _addPlayer(String name) {
    if (name.trim().isEmpty) return;
    
    setState(() {
      final newPlayer = Player(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name.trim(),
        secondsWaiting: 0,
      );
      _players.add(newPlayer);
      
      // If it's the first player, automatically select them
      if (_players.length == 1) {
        _selectedPlayerId = newPlayer.id;
      }
      
      _sortPlayers();
    });
  }

  void _selectPlayer(String id) {
    setState(() {
      _selectedPlayerId = id;
      // Reset the selected player's time
      final player = _players.firstWhere((p) => p.id == id);
      player.secondsWaiting = 0;
      _sortPlayers();
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  Future<void> _showAddPlayerDialog() async {
    String playerName = '';
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Character'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter character name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => playerName = value,
            onSubmitted: (value) {
              _addPlayer(value);
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addPlayer(playerName);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Holofote manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _players.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'No players added yet',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _players.length,
              itemBuilder: (context, index) {
                final player = _players[index];
                return CardWidget(
                  key: ValueKey(player.id),
                  player: player,
                  isSelected: player.id == _selectedPlayerId,
                  onTap: () => _selectPlayer(player.id),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: _togglePause,
              backgroundColor: Colors.red,
              heroTag: 'pauseBtn',
              child: Icon(_isPaused ? Icons.play_arrow : Icons.pause, color: Colors.white),
            ),
            FloatingActionButton(
              onPressed: _showAddPlayerDialog,
              backgroundColor: Colors.blue,
              heroTag: 'addBtn',
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
