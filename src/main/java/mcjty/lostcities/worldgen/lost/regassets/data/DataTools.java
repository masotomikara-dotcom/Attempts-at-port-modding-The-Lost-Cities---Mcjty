package mcjty.lostcities.worldgen.lost.regassets.data;

import net.minecraft.resources.ResourceLocation;

import java.util.Optional;

public class DataTools {

    public static Optional<String> toNullable(Character c) {
        if (c == null) {
            return Optional.empty();
        } else {
            return Optional.of(Character.toString(c));
        }
    }

    public static Character getNullableChar(Optional<String> opt) {
        return opt.isPresent() ? opt.get().charAt(0) : null;
    }

    public static String toName(ResourceLocation rl) {
        if (rl.getNamespace().equals(mcjty.lostcities.mcjty.lostcities.LostCities.MODID)) {
            return rl.getPath();
        } else {
            return rl.toString();
        }
    }

    public static ResourceLocation fromName(String name) {
        if (name.contains(":")) {
            return new net.minecraft.resources.ResourceLocation(name);
        } else {
            return new net.minecraft.resources.ResourceLocation(mcjty.lostcities.mcjty.lostcities.LostCities.MODID, name);
        }
    }
}
