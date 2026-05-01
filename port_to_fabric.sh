#!/bin/bash
# 1. Force Upgrade Gradle Wrapper Version
sed -i 's/gradle-7.3-bin.zip/gradle-8.7-bin.zip/g' gradle/wrapper/gradle-wrapper.properties

# 2. Setup Gradle Environment
cat <<EOM > settings.gradle
pluginManagement {
    repositories {
        maven { url "https://maven.fabricmc.net/" }
        gradlePluginPortal()
    }
}
rootProject.name = 'lostcities'
EOM

# 3. Fabric Metadata
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

# 4. Global Code Patching
find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.fml.common.Mod/dev.architectury.injectables.annotations.ExpectPlatform/g' {} +
find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.eventbus.api.SubscribeEvent/dev.architectury.event.EventResult/g' {} +
find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.common.MinecraftForge/dev.architectury.platform.Platform/g' {} +
find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext/dev.architectury.utils.Env/g' {} +
find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.api.distmarker.Dist/net.fabricmc.api.EnvType/g' {} +
find src -type f -name "*.java" -exec sed -i 's/net.minecraftforge.api.distmarker.OnlyIn/net.fabricmc.api.Environment/g' {} +

# 5. Create Entrypoint
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

# 6. Build Configuration
cat <<EOM > build.gradle
plugins {
    id 'fabric-loom' version '1.6-SNAPSHOT'
}
version = '1.20.1-1.0.0'
group = 'mcjty.lostcities'

repositories {
    maven { url "https://maven.architectury.dev/" }
    flatDir { dirs 'libs' }
}

sourceSets {
    main {
        java {
            srcDirs += ['src/api/java', 'src/generated/resources']
        }
    }
}

dependencies {
    minecraft 'com.mojang:minecraft:1.20.1'
    mappings 'net.fabricmc:yarn:1.20.1+build.10:v2'
    modImplementation 'net.fabricmc:fabric-loader:0.15.11'
    modImplementation 'net.fabricmc.fabric-api:fabric-api:0.92.2+1.20.1'
    modImplementation 'dev.architectury:architectury-fabric:9.2.14'
    implementation fileTree(dir: 'libs', include: ['*.jar'])
}

tasks.withType(JavaCompile).configureEach {
    it.options.release = 17
}
EOM

cat <<EOM > gradle.properties
org.gradle.jvmargs=-Xmx2G
org.gradle.parallel=true
EOM
mkdir -p libs
curl -L -s -o libs/mcjtylib.jar "https://www.cursemaven.com/curse/maven/mcjtylib-233105/4615378/mcjtylib-233105-4615378.jar"
chmod +x gradlew
./gradlew clean build --stacktrace
