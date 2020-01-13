fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios duiet_tests
```
fastlane ios duiet_tests
```
Run Duiet.app tests
### ios release_with_increment_build_version
```
fastlane ios release_with_increment_build_version
```

### ios release_with_increment_patch_version
```
fastlane ios release_with_increment_patch_version
```

### ios release_with_increment_minor_version
```
fastlane ios release_with_increment_minor_version
```

### ios release_with_increment_major_version
```
fastlane ios release_with_increment_major_version
```

### ios update_dependencies
```
fastlane ios update_dependencies
```
Update dependencies managed by CocoaPods and Carthage
### ios update_tools
```
fastlane ios update_tools
```

### ios update_license_list
```
fastlane ios update_license_list
```

### ios sync_bitrise_yml
```
fastlane ios sync_bitrise_yml
```

### ios upload_build_cache
```
fastlane ios upload_build_cache
```
Archive build dependencies and upload it to GitHub Releases
### ios download_build_cache
```
fastlane ios download_build_cache
```
Download build dependencies and expand it
### ios renew_build_cache
```
fastlane ios renew_build_cache
```
Overwrite the　existing build cache with the latest

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
