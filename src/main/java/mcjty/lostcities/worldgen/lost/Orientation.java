package mcjty.lostcities.worldgen.lost;

public enum Orientation {
    X,
    Z;

    public Direction getMinDir() {
        return this == X ? Direction.XMIN : Direction.ZMIN;
    }

    public Direction getMaxDir() {
        return this == X ? Direction.XMAX : Direction.ZMAX;
    }

    public Orientation getOpposite() {
import mcjty.lostcities.LostCities;
        return this == X ? Z : X;
    }
}
