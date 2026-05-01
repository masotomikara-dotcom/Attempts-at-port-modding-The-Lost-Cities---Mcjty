#!/bin/bash

# Upgrade Gradle
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

# Configure build.gradle
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

# --- Heavy Patching Phase ---

# 1. Remove Forge-only systems that cause 100+ errors
rm -rf src/main/java/mcjty/lostcities/datagen
rm -f src/main/java/mcjty/lostcities/setup/ForgeEventHandlers.java

# 2. Fix Missing Imports for Architectury Registry
# This adds the necessary import to files using DeferredRegister
find src -type f -name "*.java" -exec grep -l "DeferredRegister" {} + | xargs sed -i '1i import dev.architectury.registry.registries.DeferredRegister;'
find src -type f -name "*.java" -exec grep -l "RegistrySupplier" {} + | xargs sed -i '1i import dev.architectury.registry.registries.RegistrySupplier;'

# 3. Correct the Registry.create syntax (Final Fix)
find src -type f -name "*.java" -exec sed -i 's/DeferredRegister.create(Registries\.\([A-Z_]*\), LostCities.MODID)/DeferredRegister.create(LostCities.MODID, Registries.\1)/g' {} +

# 4. Clean up Forge annotations
find src -type f -name "*.java" -exec sed -i 's/@Mod(.*)//g' {} +
find src -type f -name "*.java" -exec sed -i 's/@EventBusSubscriber.*//g' {} +
find src -type f -name "*.java" -exec sed -i 's/import net.minecraftforge.*//g' {} +

# Metadata & Entrypoint
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

# Build and Sync
chmod +x gradlew
./gradlew clean build 2>&1 | tee build_log.txt

# Auto-push to GitHub
git add .
git commit -m "Auto-patch: Fix registry imports and remove Forge handlers"
git push origin 1.20.1
