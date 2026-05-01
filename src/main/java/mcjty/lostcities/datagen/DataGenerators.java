package mcjty.lostcities.datagen;

import mcjty.lostcities.LostCities;
import net.minecraft.data.DataGenerator;
import net.minecraftforge.data.event.GatherDataEvent;
import dev.architectury.event.EventResult;
import dev.architectury.injectables.annotations.ExpectPlatform;

@Mod.EventBusSubscriber(modid = LostCities.MODID, bus = Mod.EventBusSubscriber.Bus.MOD)
public class DataGenerators {

    @SubscribeEvent
    public static void gatherData(GatherDataEvent event) {
        DataGenerator generator = event.getGenerator();
        if (event.includeServer()) {
import mcjty.lostcities.LostCities;
            LCBlockTags blockTags = new LCBlockTags(generator, event.getLookupProvider(), event.getExistingFileHelper());
            generator.addProvider(event.includeServer(), blockTags);
        }
    }
}
