package net.minecraftforge.registries;
import net.minecraft.core.Registry;
import net.minecraft.resources.ResourceKey;
import java.util.function.Supplier;

public class DeferredRegister<T> {
    public static <T> DeferredRegister<T> create(ResourceKey<? extends Registry<T>> key, String modid) { return new DeferredRegister<>(); }
    public static <T> DeferredRegister<T> create(Object dummy, String modid) { return new DeferredRegister<>(); }
    public <I extends T> Object register(String name, Supplier<? extends I> sup) { return null; }
    public void register(Object bus) { }
}
