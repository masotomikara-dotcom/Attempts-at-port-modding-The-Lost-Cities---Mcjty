package mcjty.lostcities.setup;

import mcjty.lostcities.worldgen.lost.regassets.*;
import mcjty.lostcities.worldgen.lost.regassets.StuffSettingsRE;
import net.minecraft.core.Registry;
import net.minecraft.resources.ResourceKey;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.resources.ResourceKey;
import net.minecraft.core.Registry;
import net.minecraftforge.eventbus.api.IEventBus;

public class CustomRegistries {

    public static final ResourceKey<Registry<BuildingRE>> BUILDING_REGISTRY_KEY = ResourceKey.createRegistryKey(new net.minecraft.resources.ResourceLocation(mcjty.lostcities.LostCities.MODID, "buildings"));
    public static final net.minecraftforge.registries.DeferredRegister BUILDING_DEFERRED_REGISTER = net.minecraftforge.registries.DeferredRegister.create(null, "lostcities");

    public static final ResourceKey<Registry<PaletteRE>> PALETTE_REGISTRY_KEY = ResourceKey.createRegistryKey(new net.minecraft.resources.ResourceLocation(mcjty.lostcities.LostCities.MODID, "palettes"));
    public static final net.minecraftforge.registries.DeferredRegister PALETTE_DEFERRED_REGISTER = net.minecraftforge.registries.DeferredRegister.create(null, "lostcities");

    public static final ResourceKey<Registry<BuildingPartRE>> PART_REGISTRY_KEY = ResourceKey.createRegistryKey(new net.minecraft.resources.ResourceLocation(mcjty.lostcities.LostCities.MODID, "parts"));
    public static final net.minecraftforge.registries.DeferredRegister PART_DEFERRED_REGISTER = net.minecraftforge.registries.DeferredRegister.create(null, "lostcities");

    public static final ResourceKey<Registry<StyleRE>> STYLE_REGISTRY_KEY = ResourceKey.createRegistryKey(new net.minecraft.resources.ResourceLocation(mcjty.lostcities.LostCities.MODID, "styles"));
    public static final net.minecraftforge.registries.DeferredRegister STYLE_DEFERRED_REGISTER = net.minecraftforge.registries.DeferredRegister.create(null, "lostcities");

    public static final ResourceKey<Registry<ConditionRE>> CONDITIONS_REGISTRY_KEY = ResourceKey.createRegistryKey(new net.minecraft.resources.ResourceLocation(mcjty.lostcities.LostCities.MODID, "conditions"));
    public static final net.minecraftforge.registries.DeferredRegister CONDITIONS_DEFERRED_REGISTER = net.minecraftforge.registries.DeferredRegister.create(null, "lostcities");

    public static final ResourceKey<Registry<CityStyleRE>> CITYSTYLES_REGISTRY_KEY = ResourceKey.createRegistryKey(new net.minecraft.resources.ResourceLocation(mcjty.lostcities.LostCities.MODID, "citystyles"));
    public static final net.minecraftforge.registries.DeferredRegister CITYSTYLES_DEFERRED_REGISTER = net.minecraftforge.registries.DeferredRegister.create(null, "lostcities");

    public static final ResourceKey<Registry<MultiBuildingRE>> MULTIBUILDINGS_REGISTRY_KEY = ResourceKey.createRegistryKey(new net.minecraft.resources.ResourceLocation(mcjty.lostcities.LostCities.MODID, "multibuildings"));
    public static final net.minecraftforge.registries.DeferredRegister MULTIBUILDINGS_DEFERRED_REGISTER = net.minecraftforge.registries.DeferredRegister.create(null, "lostcities");

    public static final ResourceKey<Registry<VariantRE>> VARIANTS_REGISTRY_KEY = ResourceKey.createRegistryKey(new net.minecraft.resources.ResourceLocation(mcjty.lostcities.LostCities.MODID, "variants"));
    public static final net.minecraftforge.registries.DeferredRegister VARIANTS_DEFERRED_REGISTER = net.minecraftforge.registries.DeferredRegister.create(null, "lostcities");

    public static final ResourceKey<Registry<WorldStyleRE>> WORLDSTYLES_REGISTRY_KEY = ResourceKey.createRegistryKey(new net.minecraft.resources.ResourceLocation(mcjty.lostcities.LostCities.MODID, "worldstyles"));
    public static final net.minecraftforge.registries.DeferredRegister WORLDSTYLES_DEFERRED_REGISTER = net.minecraftforge.registries.DeferredRegister.create(null, "lostcities");

    public static final ResourceKey<Registry<PredefinedCityRE>> PREDEFINEDCITIES_REGISTRY_KEY = ResourceKey.createRegistryKey(new net.minecraft.resources.ResourceLocation(mcjty.lostcities.LostCities.MODID, "predefinedcities"));
    public static final net.minecraftforge.registries.DeferredRegister PREDEFINEDCITIES_DEFERRED_REGISTER = net.minecraftforge.registries.DeferredRegister.create(null, "lostcities");

    public static final ResourceKey<Registry<PredefinedSphereRE>> PREDEFINEDSPHERES_REGISTRY_KEY = ResourceKey.createRegistryKey(new net.minecraft.resources.ResourceLocation(mcjty.lostcities.LostCities.MODID, "predefinedspheres"));
    public static final net.minecraftforge.registries.DeferredRegister PREDEFINEDSPHERES_DEFERRED_REGISTER = net.minecraftforge.registries.DeferredRegister.create(null, "lostcities");

    public static final ResourceKey<Registry<ScatteredRE>> SCATTERED_REGISTRY_KEY = ResourceKey.createRegistryKey(new net.minecraft.resources.ResourceLocation(mcjty.lostcities.LostCities.MODID, "scattered"));
    public static final net.minecraftforge.registries.DeferredRegister SCATTERED_DEFERRED_REGISTER = net.minecraftforge.registries.DeferredRegister.create(null, "lostcities");

    public static final ResourceKey<Registry<StuffSettingsRE>> STUFF_REGISTRY_KEY = ResourceKey.createRegistryKey(new net.minecraft.resources.ResourceLocation(mcjty.lostcities.LostCities.MODID, "stuff"));
    public static final net.minecraftforge.registries.DeferredRegister STUFF_DEFERRED_REGISTER = net.minecraftforge.registries.DeferredRegister.create(null, "lostcities");

    public static void init() {
        BUILDING_DEFERRED_REGISTER.register(bus);
        PALETTE_DEFERRED_REGISTER.register(bus);
        PART_DEFERRED_REGISTER.register(bus);
        STYLE_DEFERRED_REGISTER.register(bus);
        CONDITIONS_DEFERRED_REGISTER.register(bus);
        CITYSTYLES_DEFERRED_REGISTER.register(bus);
        MULTIBUILDINGS_DEFERRED_REGISTER.register(bus);
        VARIANTS_DEFERRED_REGISTER.register(bus);
        WORLDSTYLES_DEFERRED_REGISTER.register(bus);
        PREDEFINEDCITIES_DEFERRED_REGISTER.register(bus);
        PREDEFINEDSPHERES_DEFERRED_REGISTER.register(bus);
        SCATTERED_DEFERRED_REGISTER.register(bus);
        STUFF_DEFERRED_REGISTER.register(bus);
    }

}
