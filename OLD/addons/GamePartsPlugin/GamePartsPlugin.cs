#if TOOLS
using Godot;

namespace GameParts;
[Tool]
public partial class GamePartsPlugin : EditorPlugin
{
	public override void _EnterTree()
	{
		// Initialization of the plugin goes here.
		var script = GD.Load<Script>("res://addons/GamePartsPlugin/Agent.cs");
		var texture = GD.Load<Texture2D>("res://addons/GamePartsPlugin/Agent.svg");
		AddCustomType("Agent", "Node2D", script, texture);
	}

	public override void _ExitTree()
	{
		// Clean-up of the plugin goes here.
		RemoveCustomType("Agent");
	}
}
#endif
