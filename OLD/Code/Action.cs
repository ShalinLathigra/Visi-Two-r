using Godot;

namespace GameParts;

public abstract class Action
{
    protected readonly Agent Target;

    protected Action(Agent target)
    {
        GD.Print(target.GetClass());
        Target = target;
    }

    // Check if this can run
    public virtual bool CanDo() => false;
	
    // Do the action if not _used
    public abstract bool Do();

    // Revert the action if _used
    public abstract void Undo();
}

public class BasicMoveAction : Action
{
    readonly Vector2i _dest; // always gonna be a unit vector. Can only take one action at a time
    readonly Vector2i _origin;
    public BasicMoveAction(Agent target, Vector2i dest) : base(target)
    {
        _dest = dest;
        _origin = target.GridPoint;
    }

    public override bool CanDo()
    {
        return !PathFinder.Inst.IsPointSolid(_dest);
    }

    public override bool Do()
    {
        if (!CanDo()) return false;
        GD.Print(Target.IsClass(nameof(Agent)));
        Target.MoveTo(_dest);
        return true;
    }

    public override void Undo()
    {
        Target.MoveTo(_origin);
    }
}
/* Agents exist. Can either be idle, play an animation, or be dead. Contains state.
 * Actions exist. Given a reference to an Agent, will tell the agent to play an animation or something and will set off movements.
 *		Every variant of Action must also have an "Undo"/"Revert"/"Cancel" method which undoes the state change that it caused
 *		i.e. for the player "cancel" will revert the cost drain,
 *
 * Actions are how the Agent state information is altered. Movement, Attacking, Spawning a Tentacle, Shoving, etc.
 *		Are all actions
 * 
 * Player input state needs to track the set of recent shit going on.
*/
