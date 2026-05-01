#!/bin/bash
cat <<EOF > settings.gradle
pluginManagement {
    repositories {
        maven { url "https://maven.fabricmc.net/" }
        gradlePluginPortal()
    }
}
rootProject.name = 'lostcities'
EOF

mkdir -p src/main/resources
cat <<EOF > src/main/resources/fabric.mod.json
{
  "schemaVersion": 1,
  "id": "lostcities",
  "version": "1.20.1",
  "name": "LostCities",
  "description": "Generate cities all over the world",
  "authors": [
    "McJty"
  ],
  "contact": {
    "homepage": "http://github.com/McJtyMods/LostCities/",
    "issues": "http://github.com/McJtyMods/LostCities/issues"
  },
  "license": "MIT",
  "environment": "*",
  "entrypoints": {
    "main": [
      "mcjty.lostcities.FabricEntrypoint"
    ]
  },
  "depends": {
    "fabricloader": ">=0.15.11",
    "minecraft": "~1.20.1",
    "fabric": "*",
    "architectury": "*"
  }
}
EOF

rm -rf src/main/resources/META-INF
find src/main/java -type f -name "*.java" -exec sed -i 's/net.minecraftforge.fml.common.Mod/dev.architectury.injectables.annotations.ExpectPlatform/g' {} +
find src/main/java -type f -name "*.java" -exec sed -i 's/net.minecraftforge.eventbus.api.SubscribeEvent/dev.architectury.event.EventResult/g' {} +
find src/main/java -type f -name "*.java" -exec sed -i 's/net.minecraftforge.common.MinecraftForge/dev.architectury.platform.Platform/g' {} +
find src/main/java -type f -name "*.java" -exec sed -i 's/net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext/dev.architectury.utils.Env/g' {} +
find src/main/java -type f -name "*.java" -exec sed -i 's/net.minecraftforge.api.distmarker.Dist/net.fabricmc.api.EnvType/g' {} +
find src/main/java -type f -name "*.java" -exec sed -i 's/net.minecraftforge.api.distmarker.OnlyIn/net.fabricmc.api.Environment/g' {} +

cat <<EOF > src/main/java/mcjty/lostcities/FabricEntrypoint.java
package mcjty.lostcities;
import net.fabricmc.api.ModInitializer;
public class FabricEntrypoint implements ModInitializer {
    @Override
    public void onInitialize() {
        new LostCities();
    }
}
EOF

cat <<EOF > build.gradle
plugins {
    id 'fabric-loom' version '1.6-SNAPSHOT'
}
version = '1.20.1-1.0.0'
group = 'mcjty.lostcities'
repositories {
    maven { url "https://maven.architectury.dev/" }
    maven { url "https://www.cursemaven.com" }
}
dependencies {
    minecraft 'com.mojang:minecraft:1.20.1'
    mappings 'net.fabricmc:yarn:1.20.1+build.10:v2'
    modImplementation 'net.fabricmc:fabric-loader:0.15.11'
    modImplementation 'net.fabricmc.fabric-api:fabric-api:0.92.2+1.20.1'
    modImplementation 'dev.architectury:architectury-fabric:9.2.14'
    modImplementation "curse.maven:mcjtylib-233105:4615378"
}
processResources {
    inputs.property "version", project.version
    filesMatching("fabric.mod.json") {
        expand "version": project.version
    }
}
tasks.withType(JavaCompile).configureEach {
    it.options.release = 17
}
EOF

cat <<EOF > gradle.properties
org.gradle.jvmargs=-Xmx2G
org.gradle.parallel=true
EOF

chmod +x gradlew
./gradlew clean build

