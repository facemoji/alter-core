# Facemoji Kit

Bring Facemoji into your app and let users [express themselves](https://apps.apple.com/app/id1418685721) more comfortably—or their alter ego—in fun, new ways with privacy. Unlike lenses or AR filters that are one-size-fits-all, Facemoji avatars can be personalized.

Facemoji Kit provides an accurate 3D head pose in world space, 51 facial expressions, and optionally a dense 3D mesh of a person’s face. Facemoji Kit uses blend shapes/morph targets ([FACS](https://en.wikipedia.org/wiki/Facial_Action_Coding_System) and [ARKit-compatible](https://developer.apple.com/documentation/arkit/arfaceanchor/blendshapelocation)) to animate a 2D or 3D character in ways that follow the user’s facial expressions in real-time.

![](https://paper-attachments.dropbox.com/s_C7BFD236070C71F9A3782B4A76576B1DBC5B0EBD4DDCD3EBD784C3F53FE76DED_1585000992759_facemojikit2.gif)

## How it works

RGB Input → [Magic NN](https://www.youtube.com/watch?v=7IhPgNGgUyQ) ✨ → Blend shapes weights and pose → Avatar modelling and rendering

## Key features
- Scalable facial tracking
    - A configurable trade-off between accuracy and speed
        - e.g. low-fidelity 2D vs. high-fidelity 3D avatars
- `1-2MB` ML model size
- 3D reprojection to the input photo/video
- No avatar mode similar to Snap's Lenses or Instagram's AR filters
- Supported platforms
    - Unified iOS/Mac OS X Kit with internal platform optimizations
    - Platform suited API and packaging
    - Basic Windows and Android support, full Windows and Android Kits coming soon

**Input**

RGB image or video

**Output**

- [FACS](https://en.wikipedia.org/wiki/Facial_Action_Coding_System) and [ARKit-compatible](https://developer.apple.com/documentation/arkit/arfaceanchor/blendshapelocation) blendshapes
- Gaze tracking
- Head position in 2D and 3D
- Head rotation and scale in world coordinates
- On desktop or high-end phones:
    - Dense mesh (up to `50 000` keypoints)
    - Face segmentation (per pixel)
    - UV and depth estimation
## Tracking speed

**Higher accuracy**

- `60 FPS` on iPhone SE
- `90 FPS` on iPhone X or newer

**Lower accuracy**

- `90 FPS` on iPhone SE
- `120 FPS` on iPhone X or newer
# Examples
- [Facemoji](https://apps.apple.com/app/id1418685721), our flagship app using the Kit :)
- [Facemoji for Mac](http://facemoji.co/formac/), bring your Facemoji to Zoom
- [Squad](https://apps.apple.com/app/apple-store/id1398048313), video chat and screen share with friends
- [One Word](https://apps.apple.com/us/app/one-word/id1482946490), a word game for friends
# Demo and download

Get the [TestFlight demo app](https://testflight.apple.com/join/LPgogCTf) or try one of the apps above. If you’re interested in licensing Facemoji Kit, have a question and want to chat, feel free to reach out to us [directly via email](mailto:robin@facemoji.co?subject=[GitHub]%20Facemoji%20Kit) or [join our chat room on Gitter](https://gitter.im/facemoji-kit/community).

# 3D Content

Facemoji Kit includes all the 3D accessories, models, textures, and shading assets to render Facemoji avatars in your app for your users. **There are over 1,000 items**, including hair styles, hats, sunglasses, face masks, animated accessories or even face tattoos. Accessories could be **white-labeled**.

## Accessories 
![](https://paper-attachments.dropbox.com/s_C7BFD236070C71F9A3782B4A76576B1DBC5B0EBD4DDCD3EBD784C3F53FE76DED_1585072985653_video.png)

## No avatar mode

Optional mode with no Facemoji and only 3D accessories with **occluders**.

![](https://paper-attachments.dropbox.com/s_C7BFD236070C71F9A3782B4A76576B1DBC5B0EBD4DDCD3EBD784C3F53FE76DED_1586454799479_nofacemoji.jpg)

## Diversity
![](https://paper-attachments.dropbox.com/s_C7BFD236070C71F9A3782B4A76576B1DBC5B0EBD4DDCD3EBD784C3F53FE76DED_1586454961806_20_04_02.png)



| ![](https://paper-attachments.dropbox.com/s_C7BFD236070C71F9A3782B4A76576B1DBC5B0EBD4DDCD3EBD784C3F53FE76DED_1586455576325_01.png) | ![](https://paper-attachments.dropbox.com/s_C7BFD236070C71F9A3782B4A76576B1DBC5B0EBD4DDCD3EBD784C3F53FE76DED_1586455576410_02.png) |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| ![](https://paper-attachments.dropbox.com/s_C7BFD236070C71F9A3782B4A76576B1DBC5B0EBD4DDCD3EBD784C3F53FE76DED_1586455576559_03.png) | ![](https://paper-attachments.dropbox.com/s_C7BFD236070C71F9A3782B4A76576B1DBC5B0EBD4DDCD3EBD784C3F53FE76DED_1586455576353_04.png) |
| ![](https://paper-attachments.dropbox.com/s_C7BFD236070C71F9A3782B4A76576B1DBC5B0EBD4DDCD3EBD784C3F53FE76DED_1586455577616_05.png) | ![](https://paper-attachments.dropbox.com/s_C7BFD236070C71F9A3782B4A76576B1DBC5B0EBD4DDCD3EBD784C3F53FE76DED_1586455576463_06.png) |


