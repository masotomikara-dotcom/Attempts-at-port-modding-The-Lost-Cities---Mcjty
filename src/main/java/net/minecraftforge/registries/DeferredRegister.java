package net.minecraftforge.registries;
import java.util.function.Supplier;

public class DeferredRegister {
    public static DeferredRegister create(Object key, String modid) { return new DeferredRegister(); }
    public Object register(String name, Supplier sup) { return null; }
    public void register(Object bus) { }
}
