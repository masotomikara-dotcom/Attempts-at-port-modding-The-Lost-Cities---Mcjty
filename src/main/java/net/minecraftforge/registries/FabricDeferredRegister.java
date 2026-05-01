package net.minecraftforge.registries;
import java.util.function.Supplier;

public class FabricDeferredRegister {
    public static FabricDeferredRegister create(Object key, String modid) { return new FabricDeferredRegister(); }
    public static FabricDeferredRegister create(String modid, Object key) { return new FabricDeferredRegister(); }
    public Object register(String name, Supplier sup) { return null; }
    public void register(Object bus) { }
}
