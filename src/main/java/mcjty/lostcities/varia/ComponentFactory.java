package mcjty.lostcities.varia;

import net.minecraft.network.chat.Component;
import net.minecraft.network.chat.MutableComponent;

public class ComponentFactory {

    public static MutableComponent translatable(String key) {
        return Component.translatable(key);
    }

    public static MutableComponent literal(String text) {
        return Component.literal(text);
    }

import mcjty.lostcities.LostCities;
    public static MutableComponent keybind(String keybind) {
        return Component.keybind(keybind);
    }
}
