#!/bin/bash

# 1. Force Upgrade Gradle Wrapper to 8.7
echo "Updating Gradle wrapper..."
sed -i 's/gradle-7.3-bin.zip/gradle-8.7-bin.zip/g' gradle/wrapper/gradle-wrapper.properties

# 2. Setup settings.gradle
echo "Configuring settings.gradle..."
cat <<EOM > settings.gradle
pluginManagement {
    repositories {
        maven { url "https://maven.fabricmc.net/" }
        gradlePluginPortal()
    }
}
rootProject.name = 'lostcities'
EOM

# 3. Setup build.gradle
echo "Configuring build.gradle..."
cat <<EOM > build.gradle
plugins {
    id 'fabric-loom' version '1.6-SNAPSHOT'
}
version = '1.20.1-1.0.0'
group = 'mcjty.lostcities'

repositories {
    maven { url "https://maven.architectury.dev/" }
    maven { url "https://api.modrinth.com/maven" } // Official Modrinth Maven
    maven { url "https://www.cursemaven.com" }
}

dependencies {
    minecraft 'com.mojang:minecraft:1.20.1'
    mappings 'net.fabricmc:yarn:1.20.1+build.10:v2'
    modImplementation 'net.fabricmc:fabric-loader:0.15.11'
    modImplementation 'net.fabricmc.fabric-api:fabric-api:0.92.2+1.20.1'
    modImplementation 'dev.architectury:architectury-fabric:9.2.14'
    
    // Using McJtyLib from Modrinth (Latest stable for 1.20.1 Fabric)
    modImplementation "maven.modrinth:mcjtylib:8.0.3-fabric"
}

tasks.withType(JavaCompile).configureEach {
    it.options.release = 17
}
EOM

# 4. Global Source Code Patching
echo "Patching Java source files..."
# Basic Forge to Architectury/Fabric replacements
find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.fml.common.Mod/dev.architectury.injectables.annotations.ExpectPlatform/g' {} +
find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.eventbus.api.SubscribeEvent/dev.architectury.event.EventResult/g' {} +
find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.common.MinecraftForge/dev.architectury.platform.Platform/g' {} +

# 5. Create Fabric Metadata
echo "Generating fabric.mod.json..."
mkdir -p src/main/resources
cat <<EOM > src/main/resources/fabric.mod.json
{
  "schemaVersion": 1,
  "id": "lostcities",
  "version": "1.20.1",
  "name": "LostCities",
  "description": "Generate cities all over the world",
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

# 6. Create Entrypoint
echo "Creating Fabric Entrypoint..."
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

# 7. Final Cleanup and Build
echo "Starting clean build..."
rm -rf libs/mcjtylib.jar # Remove the corrupted file from previous runs
chmod +x gradlew
./gradlew clean build --stacktrace 2>&1 | tee build_log.txt
