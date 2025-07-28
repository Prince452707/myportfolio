import 'dart:io';
import 'dart:convert';

void main() async {
  print('🚀 Starting project analysis and fixes...\n');
  
  // 1. Check and create required directories
  await _checkAndCreateDirectories();
  
  // 2. Analyze the code
  await _runFlutterAnalyze();
  
  // 3. Fix common issues
  await _fixCommonIssues();
  
  print('\n✅ Project analysis and fixes completed!');
}

Future<void> _checkAndCreateDirectories() async {
  print('🔍 Checking required directories...');
  
  final directories = [
    'assets/images',
    'assets/animations',
    'assets/sounds',
    'assets/fonts',
    'assets/models',
    'assets/shaders',
    'lib/constants',
    'lib/screens',
    'lib/widgets',
    'lib/providers',
    'lib/services',
  ];
  
  for (var dir in directories) {
    final directory = Directory(dir);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
      print('   ✅ Created directory: $dir');
    }
  }
  
  // Create empty files if they don't exist
  final files = [
    'lib/constants/app_colors.dart',
    'lib/constants/app_assets.dart',
    'lib/main.dart',
  ];
  
  for (var file in files) {
    final fileObj = File(file);
    if (!await fileObj.exists()) {
      await fileObj.create(recursive: true);
      print('   ✅ Created file: $file');
    }
  }
}

Future<void> _runFlutterAnalyze() async {
  print('\n🔍 Running Flutter analyze...');
  final process = await Process.run('flutter', ['analyze'], runInShell: true);
  print(process.stdout);
  if (process.stderr != null && process.stderr.isNotEmpty) {
    print('⚠️  Warnings/Errors:');
    print(process.stderr);
  }
}

Future<void> _fixCommonIssues() async {
  print('\n🔧 Applying common fixes...');
  
  // 1. Fix Android build.gradle
  await _fixAndroidBuildGradle();
  
  // 2. Fix iOS deployment target
  await _fixIosDeploymentTarget();
  
  // 3. Update Android manifest
  await _updateAndroidManifest();
  
  // 4. Update Info.plist
  await _updateIosInfoPlist();
  
  print('   ✅ Applied common fixes');
}

Future<void> _fixAndroidBuildGradle() async {
  try {
    final buildGradleFile = File('android/app/build.gradle');
    if (await buildGradleFile.exists()) {
      String content = await buildGradleFile.readAsString();
      
      // Update compileSdkVersion and targetSdkVersion
      content = content.replaceAll(
        'compileSdkVersion flutter.compileSdkVersion',
        'compileSdkVersion 34',
      );
      
      content = content.replaceAll(
        'targetSdkVersion flutter.targetSdkVersion',
        'targetSdkVersion 34',
      );
      
      // Enable multidex
      if (!content.contains('multiDexEnabled true')) {
        content = content.replaceFirst(
          'defaultConfig {',
          'defaultConfig {\n        multiDexEnabled true',
        );
      }
      
      await buildGradleFile.writeAsString(content);
      print('   ✅ Updated Android build.gradle');
    }
  } catch (e) {
    print('   ⚠️  Could not update Android build.gradle: $e');
  }
}

Future<void> _fixIosDeploymentTarget() async {
  try {
    final podfile = File('ios/Podfile');
    if (await podfile.exists()) {
      String content = await podfile.readAsString();
      
      // Update iOS deployment target
      if (!content.contains("platform :ios, '12.0'")) {
        content = content.replaceFirst(
          RegExp(r"platform :ios,.*"),
          "platform :ios, '12.0'",
        );
        await podfile.writeAsString(content);
        print('   ✅ Updated iOS deployment target to 12.0');
      }
    }
  } catch (e) {
    print('   ⚠️  Could not update iOS deployment target: $e');
  }
}

Future<void> _updateAndroidManifest() async {
  try {
    final manifestFile = File('android/app/src/main/AndroidManifest.xml');
    if (await manifestFile.exists()) {
      String content = await manifestFile.readAsString();
      
      // Add internet permission if not exists
      if (!content.contains('android.permission.INTERNET')) {
        content = content.replaceFirst(
          '<application',
          '<uses-permission android:name="android.permission.INTERNET"/>\n    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>\n    <application',
        );
      }
      
      // Enable cleartext traffic for debug
      if (!content.contains('android:usesCleartextTraffic')) {
        content = content.replaceFirst(
          'android:label="myportfolio"',
          'android:label="myportfolio"\n        android:usesCleartextTraffic="true"',
        );
      }
      
      await manifestFile.writeAsString(content);
      print('   ✅ Updated AndroidManifest.xml');
    }
  } catch (e) {
    print('   ⚠️  Could not update AndroidManifest.xml: $e');
  }
}

Future<void> _updateIosInfoPlist() async {
  try {
    final plistFile = File('ios/Runner/Info.plist');
    if (await plistFile.exists()) {
      String content = await plistFile.readAsString();
      
      // Add NSAppTransportSecurity for HTTP requests
      if (!content.contains('NSAppTransportSecurity')) {
        final insertAfter = '<dict>\n';
        final atsConfig = '''
        <key>NSAppTransportSecurity</key>
        <dict>
            <key>NSAllowsArbitraryLoads</key>
            <true/>
        </dict>\n'''.trim();
        
        content = content.replaceFirst(
          insertAfter,
          '$insertAfter    $atsConfig\n',
        );
        
        await plistFile.writeAsString(content);
        print('   ✅ Updated Info.plist with ATS settings');
      }
    }
  } catch (e) {
    print('   ⚠️  Could not update Info.plist: $e');
  }
}
