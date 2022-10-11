using Godot;

namespace GameParts;

public interface IStateTree
{
	// Should provide a reference to the owner somehow
	// Node2D?
	// StateOwner?
	public State Current { get; set; }
	public void Set(State newState);

	public void Tick();
}

public class StateTree : IStateTree
{
	public State Current { get; set; }
	public void Set(State newState)
	{
		if (Current == newState) return;
		Current?.Exit();
		Current = newState;
		Current.Enter();
	}

	public virtual void Tick()
	{
		Current?.Tick();
	}
}
