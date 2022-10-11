using System;
using System.Linq;
using GameParts.Tools;
using Godot;

namespace GameParts;

public partial class PlayerTurn : GameState
{
    const int MaxNumActions = 3;
    [Export] Line2D _pathVisualizer;
    [Export] Label _debugPathLabel;
    [Export] Agent _player;

    Vector2i _target;
    Vector2i[] _generatedPath;
    int _numUsedActions;

    Vector2i[] GeneratedPath
    {
        get => _generatedPath;
        set
        {
            _generatedPath = value;
            _pathVisualizer.Points = _generatedPath.Select(
                point => PathFinder.Inst.PointToLocal(point))
                .ToArray();
        }
    }

    public Agent Player() => _player;

    public override void Enter()
    {
        _numUsedActions = 0;
    }

    public override void _Input(InputEvent @event)
    {
        if (IsFinished) return;
        
        if (@event.IsActionPressed("state_advance"))
        {
            // In this case, move the player along the path. Then remove the first element from _generatedPath.
            if (GeneratedPath.Length <= 0) return;
            Action a = new BasicMoveAction(_player, GeneratedPath[0]);
            if (!a.Do()) return;
            GeneratedPath = GeneratedPath.Skip(1).ToArray();
            _numUsedActions += 1;
        }
        
        if (@event is InputEventMouseButton { Pressed: true, ButtonIndex: MouseButton.Left } validMouseEvent)
            HandlePathTargetUpdate(validMouseEvent);
    }
    
    void HandlePathTargetUpdate(InputEventMouse validMouseEvent)
    {
        // update path visualizer
        if (PathFinder.Inst.IsPositionSolid(validMouseEvent.Position, out var convertedPosition)) return;
        _target = convertedPosition;
        GeneratedPath = PathFinder.Inst.FindPointPath(_player.GridPoint, _target).Skip(1).ToArray();
        
        // update path marker
        _debugPathLabel.Text = $"{_player.GridPoint} => {_target}: {GeneratedPath.Length} steps";
    }
}