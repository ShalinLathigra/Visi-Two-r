using Godot;
namespace GameParts;

// All Agents can navigate.
// All navigates implement some parent class that represents grid objects.
public partial class Agent : Node2D	// Need to create a new one that inherits this information!
{
	// What is this going to do?
	const float MoveDuration = 0.5f;
	StateTree _tree;

	public Vector2i GridPoint { get; private set; }

	public override void _Ready()
	{
		_tree = new StateTree();
	}

	public void SnapToGrid()
	{
		GridPoint = PathFinder.Inst.LocalToPoint(Position);
		Position = PathFinder.Inst.PointToLocal(GridPoint);
	}

	public void MoveTo(Vector2i newPoint)
	{
		var endPosition = PathFinder.Inst.PointToLocal(newPoint);
		var cb = new Callable(() => GridPoint = newPoint);
		var tw = CreateTween().Parallel().SetEase(Tween.EaseType.InOut).SetTrans(Tween.TransitionType.Cubic);
		tw.TweenProperty(this as Node2D, "position", endPosition, MoveDuration);
		tw.TweenCallback(cb);
	}
}