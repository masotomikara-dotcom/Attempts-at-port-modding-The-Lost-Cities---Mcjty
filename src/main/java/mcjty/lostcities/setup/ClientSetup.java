package mcjty.lostcities.setup;

import dev.architectury.platform.Platform;
import net.minecraftforge.fml.event.lifecycle.FMLClientSetupEvent;

public class ClientSetup {

    public static void init(FMLClientSetupEvent event) {
        MinecraftForge.EVENT_BUS.register(new ClientEventHandlers());
    }
}
