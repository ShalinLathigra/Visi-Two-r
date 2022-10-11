using Godot;

namespace GameParts;

public abstract partial class State : Node2D, IStateTree
{
	public State Current { get; set; }
	/// <summary>
	/// This is either an entity or a State.
	/// i.e. Sniper -> Attack
	///		 Attack -> Aim
	///		 Attack -> Fire
	/// Attack is done if interrupted or if it has been cancelled otherwise
	/// </summary>
	protected IStateTree TreeOwner;

	/// <summary>
	/// Property access
	/// </summary>
	public virtual bool IsFinished { get; protected set; }

	/// <summary>
	///	Virtual methods handling 
	/// </summary>
	public virtual void Enter() => GD.Print("Entering State", GetType().ToString());
	public virtual void Exit() => GD.Print("Exiting State", GetType().ToString());
	public void Set(State newState)
	{
		if (Current == newState) return;
		Current?.Exit();
		Current = newState;
		Current.Enter();
	}

	public virtual void Tick() { }
	public virtual void Reset() { }
}