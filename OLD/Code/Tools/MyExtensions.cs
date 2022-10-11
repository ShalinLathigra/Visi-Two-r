using Godot;

namespace GameParts.Tools;

public static class MyExtensions
{   
    /// <summary>
    /// Temporary fix while getusedrect is broken. Calculates the dimensions of a subject tilemap by iterating over cells
    /// This is not fast
    /// </summary>
    /// <param name="map"></param>
    /// <returns></returns>
    public static Vector2i CalculateDimensions(this TileMap map)
    {
        var cells = map.GetUsedCells(0);
        var minCorner = new Vector2i(0, 0);
        var maxCorner = new Vector2i(0, 0);
        foreach (var cell in cells)
        {
            minCorner.x = Mathf.Min(minCorner.x, cell.x);
            minCorner.y = Mathf.Min(minCorner.y, cell.y);
            maxCorner.x = Mathf.Max(maxCorner.x, cell.x);
            maxCorner.y = Mathf.Max(maxCorner.y, cell.y);
        }
        return maxCorner - minCorner + Vector2i.One;
    }

    public static Vector2i ToVector2I(this Vector2 vec)
    {
        return new Vector2i((int)vec.x, (int)vec.y);
    }
}