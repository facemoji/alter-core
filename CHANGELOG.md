# Changelog
All notable changes to this project will be documented in this file. This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.10.0 - 2022-02-01
### Added
- New classes for accessing camera on iOS and Javascript

### Changed
- Changing name from Facemoji to Alter
- The SDK is now publicly available

### Fixed
- (iOS) Multiple memory leaks on iOS
- (iOS) Multiple thread synchronization issues on iOS
- Accessory collisions for avatars
- Assets not properly updated from Alter servers

### Improved
- (JS) NN loading performance
- (JS) Avatar loading performance

## 0.9.0 - 2022-01-05
### Fixed
- Javascript implementation is now up to 3x faster
- Improve error messages for avatar loading

### Added
- New simplified Avatar API to avoid the need to create contexts and multiple helper objects

### Changed
- Re-worked Javascript API to be on-par with Android and iOS

## 0.8.0 - 2021-11-30
### Fixed
- Fix face tracker limiting rendering performance
- (iOS) Workaround for device crash on Apple A8 chipsets (iPad Air 2, iPad Mini 4, iPhone 6)
- (iOS) Reduce peak memory usage
- (iOS) Cache compiled neural net models to speed up startup and reduce disk usage
- (iOS) Improve neural net loading to avoid hiccups in first few frames

### Changed
- (JS) Removed co.facemoji* prefix from API classes
- (JS) Improve Typescript typings

## 0.7.7 - 2021-11-24
### Changed
- (JS) API now allows to limit avatar tracking only to rotation

## 0.7.6 - 2021-11-19
### Fixed
- (JS) Fix JS overload renames being applied to external definitions

## 0.7.5 - 2021-11-18
### Changed
- Redesign boneblender computation to be more predictable

## 0.7.4 - 2021-11-16
### Fixed
- (JS) NN data path respects base data location configuration

