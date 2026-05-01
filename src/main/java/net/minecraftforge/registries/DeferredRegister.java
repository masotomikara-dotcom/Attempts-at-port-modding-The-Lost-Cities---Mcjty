package net.minecraftforge.registries;
import java.util.function.Supplier;

public class DeferredRegister {
    public static DeferredRegister create(Object key, String modid) { return new DeferredRegister(); }
    public Object register(String name, Supplier sup) { return null; }
    public void register(Object bus) { }
    // Thêm hàm này để "khớp" với những gì Architectury đang cố làm
    public static DeferredRegister create(String modid, Object key) { return new DeferredRegister(); }
}
