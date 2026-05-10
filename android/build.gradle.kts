allprojects {
    repositories {
        google()
        mavenCentral()
    }
    
    // Exclude problematic sign_in_with_apple plugin
    configurations.all {
        exclude(group = "com.aboutyou.dart_packages", module = "sign_in_with_apple")
        exclude(group = "io.flutter.plugins.sign_in_with_apple")
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
