<h1 align="center">
  <br>
  <img src="https://user-images.githubusercontent.com/130319/151848890-9bc3dcae-eeac-47af-bda3-e2d72b20fe3a.png" alt="Core by Alter" width="100%"></a>
  <br>
  Core by <a href="https://alter.xyz">Alter</a>
  <br>
</h1>


Core by [Alter](https://alter.xyz) is a cross-platform SDK consisting of a real-time 3D avatar system and [facial motion capture](https://github.com/facemoji/mocap4face) built from scratch for web3 interoperability and the open metaverse. Easily pipe avatars into your game, app or website. It just works. Check out the included code samples to learn how to get started. [Try the live demo](https://alter.xyz).

Please star us ⭐⭐⭐ on GitHub—it motivates us a lot!
# 📋 Table of Content

- [Tech Specs](#-tech-specs)
- [Motion Capture](#-facial-motion-capture)
- [Installation](#-installation)
- [License](#-license)
- [Use Cases](#-use-cases)
- [Links](#️-links)

# 🤓 Tech Specs

### 🚉 Supported Platforms

- iOS 13+
- Android 8+
- WebGL 2
- macOS (WIP)
- Windows (WIP)
- Unity (Soon)
- Unreal (Soon)

### ✨ Avatar Formats

- Head only
- A bust with clothing
- Accessories only (for e.g. AR filters) (Soon)
- Full body (Soon)

### 🌈 Variability

- Human and non-human
- From toddler to skeleton
- Genders and non-binary
- Full range of diversity

# 🤪 Motion Capture

### ✨ Features
- `42` tracked facial expressions via blendshapes
- Eye tracking including eye gaze vector
- Tongue tracking
- Light & fast, just `3MB` ML model size
- `≤ ±50°` pitch, `≤ ±40°` yaw and `≤ ±30°` roll tracking coverage
- [3D reprojection to input photo/video](https://studio.facemoji.co/docs/Re-projecting-3D-Faces-for-Augmented-Reality_a2d9e35a-3d9a-4fd1-b58a-51db06139d4d)
- Platform-suited API and packaging with internal optimizations
- Simultaneous back and front camera support
- Light & fast, just `3MB` ML model size

### 🤳 Input

- Any webcam
- Photo
- Video
- Audio

### 📦 Output

- [ARKit-compatible](https://developer.apple.com/documentation/arkit/arfaceanchor/blendshapelocation) blendshapes
- Head position and scale in 2D and 3D
- Head rotation in world coordinates
- Eye tracking including eye gaze vector
- 3D reprojection to the input photo/video
- Tongue tracking

### ⚡ Performance

- `50 FPS` on Pixel 4
- `60 FPS` on iPhone SE (1st gen)
- `90 FPS` on iPhone X or newer

### 💡 More information
If you only need the facial tracking technology, check out our [mocap4face](https://github.com/facemoji/mocap4face) repository!

# 💿 Installation



## Prerequisites
Register in [Alter Studio](https://studio.alter.xyz) to get a unique key to access avatar data from our servers.

See our example code to see where to put the key. Look for "YOUR-API-KEY-HERE".



## iOS

To run the example, simply open the attached XCode project and run it on your iPhone or iPad.

Do not forget to get your API key at [studio.alter.xyz](https://studio.alter.xyz) and paste it into the code. Look for "YOUR-API-KEY-HERE".

### SwiftPackage Installation
Add this repository as a dependency to your `Package.swift` or XCode Project.

### Manual iOS Installation
Download the [`AlterCore.xcframework`](frameworks/AlterCore.xcframework) from this repository and drag&drop it into your XCode Project.


## Android

To run the example, open the android-example project in Android Studio and run it on your Android phone.

Do not forget to get your API key at [studio.alter.xyz](https://studio.alter.xyz) and paste it into the code. Look for "YOUR-API-KEY-HERE".

### Gradle/Maven Installation for Android
Add this repository to your Gradle repositories in build.gradle:
```
repositories {
    // ...
    maven {
        name = "Alter"
        url = uri("https://facemoji.jfrog.io/artifactory/default-maven-local/")
    }
    // ...
}

// ...
dependencies {
    implementation "alter:alter-core:0.10.0"
}
```

## Browser/Javascript

To run the example, go to the js-example project and use `npm install` and `npm run dev` commands.

Do not forget to get your API key at [studio.alter.xyz](https://studio.alter.xyz) and paste it into the code. Look for "YOUR-API-KEY-HERE".

### NPM Installation

Install the dependency via `npm` or `yarn` command.
```
npm install @0xalter/alter-core@0.10.0
```

If you are using a bundler (such as Webpack), make sure to copy the assets from `@0xalter/alter-core` to your serving directory.
See [our Webpack config](js-example/webpack.config.common.js#L33) for an example of what needs to be copied.


# 📄 License

This library is provided under the [Alter SDK License Agreement](LICENSE.md). The sample code in this repository is provided under the [Alter Samples License](ios-example/LICENSE.md).

# 🚀 Use Cases

Any app or game experience that uses an avatar as a profile picture or for character animations. The only limit is your imagination.

- Audio-only chat apps
- Next-gen profile pics
- Live avatar experiences
- Snapchat-like lenses
- AR experiences
- VTubing apps
- Live streaming apps
- Face filters
- Personalized stickers
- AR games with facial triggers
- Role-playing games

# Known Limitations

This is an alpha release software—we are still ironing out bugs, adding new features and changing the data:

- Item names within an Avatar Matrix can change
- The SDK is still not 100 % thread safe and race conditions or memory leaks can occur rarely
- Documentation is very sparse, make sure to join our [Discord](https://discord.gg/alterz) or file an issue if you encounter problems

# ❤️ Links

- [Twitter](https://twitter.com/alterz)
- [Discord](https://discord.gg/alterz)
- [LinkedIn](https://www.linkedin.com/company/alterxyz/)
- [Blog](https://medium.com/@alterz/announcing-our-intentions-to-open-source-our-core-tech-62e7a87ce5be)
- [Learn more...](https://alter.xyz)
