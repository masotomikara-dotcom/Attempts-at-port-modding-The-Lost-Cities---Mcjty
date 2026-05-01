#!/bin/bash

# Upgrade Gradle to 8.7 for Java 17/21 compatibility
sed -i 's/gradle-7.3-bin.zip/gradle-8.7-bin.zip/g' gradle/wrapper/gradle-wrapper.properties

# Configure settings.gradle
cat <<EOM > settings.gradle
pluginManagement {
    repositories {
        maven { url "https://maven.fabricmc.net/" }
        gradlePluginPortal()
    }
}
rootProject.name = 'lostcities'
EOM

# Configure build.gradle with Mojmap and Architectury
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

# --- Start Patching Phase ---

# Remove Forge-specific DataGen (Incompatible with Fabric)
rm -rf src/main/java/mcjty/lostcities/datagen

# Remove Forge @Mod annotations and event subscribers
find src -type f -name "*.java" -exec sed -i 's/@Mod(.*)//g' {} +
find src -type f -name "*.java" -exec sed -i 's/@EventBusSubscriber.*//g' {} +
find src -type f -name "*.java" -exec sed -i 's/import net.minecraftforge.fml.common.Mod;//g' {} +

# Replace legacy javax annotations with JetBrains standard
find src -type f -name "*.java" -exec sed -i 's/import javax.annotation.Nonnull;/import org.jetbrains.annotations.NotNull;/g' {} +
find src -type f -name "*.java" -exec sed -i 's/import javax.annotation.Nullable;/import org.jetbrains.annotations.Nullable;/g' {} +
find src -type f -name "*.java" -exec sed -i 's/@Nonnull/@NotNull/g' {} +

# Redirect Forge side-loading logic to Architectury Platform
find src -type f -name "*.java" -exec sed -i 's/DistExecutor.unsafeRunWhenOn/if (dev.architectury.platform.Platform.getEnv().isClient())/g' {} +

# Fix Registry system (Forge DeferredRegister -> Architectury)
find src -type f -name "*.java" -exec sed -i 's/DeferredRegister.create/DeferredRegister.create(LostCities.MODID, /g' {} +
find src -type f -name "*.java" -exec sed -i 's/.register(IEventBus.*)//g' {} +

# Clean up remaining Forge lifecycle imports
find src -type f -name "*.java" -exec sed -i 's/import net.minecraftforge.fml.event.lifecycle.FMLCommonSetupEvent;//g' {} +
find src -type f -name "*.java" -exec sed -i 's/import net.minecraftforge.fml.event.lifecycle.FMLClientSetupEvent;//g' {} +

# Prepare Fabric metadata
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

# Create the Fabric-compatible main entry point
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

# Finalize and Build
chmod +x gradlew
./gradlew clean build 2>&1 | tee build_log.txt
