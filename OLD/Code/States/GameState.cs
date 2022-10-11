using Godot;

namespace GameParts;

public partial class GameState : State
{
    [Export(PropertyHint.Range, "0, 10, 0.1,or_greater")]
    float _duration;
    [Export]
    Color _openColor = Colors.White;
    [Export]
    Color _closedColor = Colors.White * 0.0f;


    bool IsAnimating { get; set; }
    bool _isOpen;
    Tween _currentTween;
    
    public override bool IsFinished { get; protected set; }
    
    public override void Enter()
    {
        base.Enter();
        Open();
    }
    public override void Exit()
    {
        base.Exit();
        Close();
    }

    public override void Reset()
    {
        base.Reset();
        IsFinished = false;
        Close(true);
    }


    Tween Open(bool instant = false) => Animate(true, instant);
    Tween Close(bool instant = false) => Animate(false, instant);

    void FinishAnimating(bool toOpen)
    {
        _isOpen = toOpen;
        IsAnimating = false;
    }

    Tween Animate(bool toOpen, bool instant=false)
    {
        IsAnimating = true;
        if (_isOpen != toOpen)
            _currentTween?.Kill();
        // calculate dist between current alpha and desired alpha
        var desiredColor = toOpen ? _openColor : _closedColor;
        var durationModifier = instant ? 0 
            : Mathf.Abs(desiredColor.a - Modulate.a) / (_openColor.a - _closedColor.a);
        
        _currentTween = GetTree().CreateTween().SetEase(Tween.EaseType.InOut).SetTrans(Tween.TransitionType.Cubic);
        _currentTween.TweenProperty(this, "modulate", desiredColor, _duration * durationModifier);
        var clearIsAnimatingCB = new Callable(() => FinishAnimating(toOpen));
        _currentTween.TweenCallback(clearIsAnimatingCB);
        return _currentTween;
    }
}