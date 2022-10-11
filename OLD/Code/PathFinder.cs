using System.Linq;
using GameParts.Tools;
using Godot;

namespace GameParts;

public partial class PathFinder
{
    public static PathFinder Inst { get; private set; }

    AStarGrid2D _grid;
    TileMap _map;
    
    public PathFinder(TileMap map,
        AStarGrid2D.Heuristic heuristic = AStarGrid2D.Heuristic.Euclidean,
        AStarGrid2D.DiagonalModeEnum diagonal = AStarGrid2D.DiagonalModeEnum.OnlyIfNoObstacles) =>
        InitFromMap(map,
            heuristic,
            diagonal);


    void InitFromMap(TileMap map, AStarGrid2D.Heuristic heuristic, AStarGrid2D.DiagonalModeEnum diagonal)
    {
        Inst ??= this;
        _map = map;
        var cells = _map.GetUsedCells(0);
        _grid = new AStarGrid2D();
        _grid.Size =  _map.CalculateDimensions();
        _grid.CellSize = _map.TileSet.TileSize;
        _grid.Offset = _grid.CellSize * 0.5f;
        _grid.DefaultHeuristic = heuristic;
        _grid.DiagonalMode = diagonal;
        _grid.Update();

        foreach (var c in cells)
        {
            var tileData = _map.GetCellTileData(0, c);
            if (tileData.GetCustomData("Walkable").AsBool()) continue;
            _grid.SetPointSolid(c, true);
        }
    }


    public Vector2i[] FindPointPath(Vector2i start, Vector2i end)
    {
        return _grid.GetIdPath(start, end).Select(vec => vec.ToVector2I()).ToArray();
    }

    public bool IsPointSolid(Vector2i point)
    {
        return _grid.IsInBounds(point.x, point.y) && _grid.IsPointSolid(point);
    }
    
    public bool IsPositionSolid(Vector2 position, out Vector2i point)
    {
        point = _map.LocalToMap(position);
        return IsPointSolid(point);
    }

    public Vector2 PointToLocal(Vector2i sourcePoint)
    {
        return _map.MapToLocal(sourcePoint);
    }
    public Vector2i LocalToPoint(Vector2 localPosition)
    {
        return _map.LocalToMap(localPosition);
    }
}