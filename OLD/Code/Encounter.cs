using Godot;

namespace GameParts;

public partial class Encounter : Node2D
{
	[Export] PlayerTurn _playerTurn;
	[Export] GameTurn _gameTurn;
	[Export] TileMap _tileMap;
	[Export] Marker2D _spawnPosition;

	StateTree _tree;
	PathFinder _path;
	Agent _player;

	public override void _Ready()
	{
		// Set up AStar Components
		_path = new PathFinder(_tileMap);
		
		// Set up game state
		_tree = new StateTree();
		_tree.Set(_playerTurn);
		
		// Set up player
		_player = _playerTurn.Player();
		_player.Position = _spawnPosition.Position;
		_player.SnapToGrid();
	}

	public override void _Process(double delta)
	{
		base._Process(delta);
		_tree.Tick();

		if (_tree.Current == _playerTurn && _playerTurn.IsFinished) _tree.Set(_gameTurn);
		if (_tree.Current == _gameTurn && _gameTurn.IsFinished) _tree.Set(_playerTurn);
	}
}
