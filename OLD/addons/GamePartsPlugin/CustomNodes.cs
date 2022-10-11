#if TOOLS
using Godot;

namespace GameParts;

[Tool]
public partial class CustomNodes : EditorPlugin
{
	public override void _EnterTree()
	{
		// Initialization of the plugin goes here.
		var script = GD.Load<Script>("Agent.cs");
		var texture = GD.Load<Texture2D>("Agent.svg");
		AddCustomType("Agent", "Node2D", script, texture);
	}

	public override void _ExitTree()
	{
		// Clean-up of the plugin goes here.
		RemoveCustomType("Agent");
	}
}
#endif
