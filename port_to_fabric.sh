#!/bin/bash

# 1. Force Upgrade Gradle Wrapper to version 8.7
echo "Upgrading Gradle Wrapper..."
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

# 3. Setup build.gradle for Fabric port
echo "Configuring build.gradle..."
cat <<EOM > build.gradle
plugins {
    id 'fabric-loom' version '1.6-SNAPSHOT'
}
version = '1.20.1-1.0.0'
group = 'mcjty.lostcities'

repositories {
    maven { url "https://maven.architectury.dev/" }
    maven { url "https://www.cursemaven.com" }
    flatDir { dirs 'libs' }
}

dependencies {
    minecraft 'com.mojang:minecraft:1.20.1'
    mappings 'net.fabricmc:yarn:1.20.1+build.10:v2'
    modImplementation 'net.fabricmc:fabric-loader:0.15.11'
    modImplementation 'net.fabricmc.fabric-api:fabric-api:0.92.2+1.20.1'
    modImplementation 'dev.architectury:architectury-fabric:9.2.14'
    
    // Using local jar from libs folder to avoid maven resolution issues
    implementation fileTree(dir: 'libs', include: ['*.jar'])
}

tasks.withType(JavaCompile).configureEach {
    it.options.release = 17
}
EOM

# 4. Generate Fabric Metadata
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

# 5. Create Fabric Entrypoint
echo "Creating Fabric Entrypoint..."
mkdir -p src/main/java/mcjty/lostcities
cat <<EOM > src/main/java/mcjty/lostcities/FabricEntrypoint.java
package mcjty.lostcities;
import net.fabricmc.api.ModInitializer;
public class FabricEntrypoint implements ModInitializer {
    @Override
    public void onInitialize() {
        // LostCities main class initialization
        new LostCities();
    }
}
EOM

# 6. Manually download McJtyLib (Fixed version for 1.20.1)
echo "Downloading McJtyLib dependency..."
mkdir -p libs
curl -L -s -o libs/mcjtylib.jar "https://www.cursemaven.com/curse/maven/mcjtylib-233105/4615378/mcjtylib-233105-4615378.jar"

# Check if file download was successful
if [ ! -s libs/mcjtylib.jar ]; then
    echo "ERROR: McJtyLib download failed or file is empty!"
    exit 1
fi

# 7. Execute Build and export log
echo "Starting build process..."
chmod +x gradlew
./gradlew clean build --stacktrace 2>&1 | tee build_log.txt
