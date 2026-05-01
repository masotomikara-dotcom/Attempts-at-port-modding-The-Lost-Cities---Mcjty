#!/bin/bash

sed -i 's/gradle-7.3-bin.zip/gradle-8.7-bin.zip/g' gradle/wrapper/gradle-wrapper.properties

cat <<EOM > settings.gradle
pluginManagement {
    repositories {
        maven { url "https://maven.fabricmc.net/" }
        gradlePluginPortal()
    }
}
rootProject.name = 'lostcities'
EOM

cat <<EOM > build.gradle
plugins {
    id 'fabric-loom' version '1.6-SNAPSHOT'
}
version = '1.20.1-1.0.0'
group = 'mcjty.lostcities'

repositories {
    maven { url "https://maven.architectury.dev/" }
    maven { url "https://api.modrinth.com/maven" }
    flatDir { dirs 'libs' }
}

dependencies {
    minecraft 'com.mojang:minecraft:1.20.1'
    mappings loom.officialMojangMappings()
    modImplementation 'net.fabricmc:fabric-loader:0.15.11'
    modImplementation 'net.fabricmc.fabric-api:fabric-api:0.92.2+1.20.1'
    modImplementation 'dev.architectury:architectury-fabric:9.2.14'
    implementation fileTree(dir: 'libs', include: ['*.jar'])
}

tasks.withType(JavaCompile).configureEach {
    it.options.release = 17
}
EOM

find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.fml.common.Mod/dev.architectury.injectables.annotations.ExpectPlatform/g' {} +
find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.eventbus.api.SubscribeEvent/dev.architectury.event.EventResult/g' {} +
find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.api.distmarker.Dist/net.fabricmc.api.EnvType/g' {} +
find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.api.distmarker.OnlyIn/net.fabricmc.api.Environment/g' {} +
find src -type f -name "*.java" -exec sed -i 's/Dist.CLIENT/EnvType.CLIENT/g' {} +
find src -type f -name "*.java" -exec sed -i 's/Dist.DEDICATED_SERVER/EnvType.SERVER/g' {} +
find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.fml.loading.FMLPaths/net.fabricmc.loader.api.FabricLoader/g' {} +
find src -type f -name "*.java" -exec sed -i 's/FMLPaths.CONFIGDIR.get()/FabricLoader.getInstance().getConfigDir()/g' {} +
find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.registries.ForgeRegistries/net.minecraft.core.registries.BuiltInRegistries/g' {} +
find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.registries.DeferredRegister/dev.architectury.registry.registries.DeferredRegister/g' {} +
find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.registries.RegistryObject/dev.architectury.registry.registries.RegistrySupplier/g' {} +
find src -type f -name "*.java" -exec sed -i 's/import net.minecraftforge.*;//g' {} +

mkdir -p src/main/resources
cat <<EOM > src/main/resources/fabric.mod.json
{
  "schemaVersion": 1,
  "id": "lostcities",
  "version": "1.20.1",
  "name": "LostCities",
  "description": "Port of Lost Cities to Fabric",
  "authors": ["McJty"],
  "license": "MIT",
  "environment": "*",
  "entrypoints": { "main": ["mcjty.lostcities.FabricEntrypoint"] },
  "depends": {
    "fabricloader": ">=0.15.11",
    "minecraft": "~1.20.1",
    "fabric": "*",
    "architectury": "*"
  }
}
EOM

mkdir -p src/main/java/mcjty/lostcities
cat <<EOM > src/main/java/mcjty/lostcities/FabricEntrypoint.java
package mcjty.lostcities;
import net.fabricmc.api.ModInitializer;
public class FabricEntrypoint implements ModInitializer {
    @Override
    public void onInitialize() {
        new LostCities();
    }
}
EOM

chmod +x gradlew
./gradlew clean build 2>&1 | tee build_log.txt
