package alter.coredemo

import co.facemoji.async.*
import co.facemoji.avatar.Avatar
import co.facemoji.avatar.AvatarFactory
import co.facemoji.avatar.TrackerAvatarController
import co.facemoji.avatar.context
import co.facemoji.functional.Try
import co.facemoji.tracker.*

/**
 * A simple class that connects camera feed with a facial expression tracker.
 */
class CameraTracker private constructor(
    val cameraWrapper: CameraWrapper,
    val faceTracker: FaceTracker
) {
    val lastResult: FaceTrackerResult? get() = faceTracker.lastResult
    var avatarController: TrackerAvatarController? = null
    var frontFacing = true

    private var onFaceTracked: (faceDetected: Boolean) -> Unit = {}

    init {
        cameraWrapper.start(frontFacing)
        cameraWrapper.addOnFrameListener(this::onCameraImage)
    }

    fun attachAvatar(avatar: Avatar) {
        avatarController = TrackerAvatarController(faceTracker, avatar)
    }


    /**
     * Stops the tracking and releases the camera
     */
    fun stop() {
        cameraWrapper.stop()
    }

    /**
     * (Re)-starts the camera (useful after the app gets suspended)
     */
    fun restart() {
        cameraWrapper.start(frontFacing)
    }

    /**
     * Switches between front and back cameras
     */
    fun switchCamera() {
        frontFacing = !frontFacing
        cameraWrapper.start(frontFacing)
    }

    fun setOnFaceTrackedListener(onFaceTracked: (faceDetected: Boolean) -> Unit) {
        this.onFaceTracked = onFaceTracked
    }

    // Called whenever a new camera frame is available
    private fun onCameraImage(cameraTexture: OpenGLTexture) {
        val avatarController = avatarController
        if (avatarController != null)
            avatarController.updateFromCamera(cameraTexture)
        else
            faceTracker.track(cameraTexture)

        onFaceTracked(lastResult?.hasFace() ?: false)

        // Serialize/deserialize tracking result for e.g. sending over WebRTC, use TrackerResultAvatarController for that
//        val serialized = lastResult?.serialize()
//        val deserialized = serialized?.let { deserializeResult(it).first }
    }


    companion object {
        fun create(avatarFactory: AvatarFactory): Future<Try<CameraTracker>> {
            val cameraWrapper = CameraWrapper(avatarFactory.context)
            return FaceTracker.createVideoTracker(
                avatarFactory.bundledFileSystem,
                cameraWrapper.openglContext
            ).mapTry {
                CameraTracker(cameraWrapper, it)
            }
        }
    }
}