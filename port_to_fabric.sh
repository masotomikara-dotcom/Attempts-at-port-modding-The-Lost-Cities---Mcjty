#!/bin/bash

# 1. Upgrade Gradle
sed -i 's/gradle-7.3-bin.zip/gradle-8.7-bin.zip/g' gradle/wrapper/gradle-wrapper.properties

# 2. Configure build.gradle
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

# --- Patching Phase ---

# Remove incompatible Forge files
rm -rf src/main/java/mcjty/lostcities/datagen
rm -f src/main/java/mcjty/lostcities/setup/ForgeEventHandlers.java

# Add Missing Imports for Registry and Annotations
find src -type f -name "*.java" -exec sed -i '/package /a import dev.architectury.registry.registries.DeferredRegister;\nimport dev.architectury.registry.registries.RegistrySupplier;\nimport org.jetbrains.annotations.NotNull;\nimport org.jetbrains.annotations.Nullable;' {} +

# Convert old Forge/JSR305 annotations to JetBrains
find src -type f -name "*.java" -exec sed -i 's/@Nonnull/@NotNull/g' {} +
find src -type f -name "*.java" -exec sed -i 's/import javax.annotation.Nonnull;//g' {} +
find src -type f -name "*.java" -exec sed -i 's/import javax.annotation.Nullable;//g' {} +

# Fix Registry Syntax (MODID, Registry)
find src -type f -name "*.java" -exec sed -i 's/DeferredRegister.create(Registries\.\([A-Z_]*\), LostCities.MODID)/DeferredRegister.create(LostCities.MODID, Registries.\1)/g' {} +
find src -type f -name "*.java" -exec sed -i 's/RegistryObject/RegistrySupplier/g' {} +

# Clean up remaining Forge imports
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

# 3. Build
chmod +x gradlew
./gradlew clean build 2>&1 | tee build_log.txt
