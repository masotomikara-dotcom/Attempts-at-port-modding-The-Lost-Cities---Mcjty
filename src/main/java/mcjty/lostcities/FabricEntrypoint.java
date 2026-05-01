package mcjty.lostcities;
import net.fabricmc.api.ModInitializer;
public class FabricEntrypoint implements ModInitializer {
    @Override
    public void onInitialize() {
        new LostCities();
    }
}
