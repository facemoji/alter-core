package alter.coredemo

import android.Manifest
import android.annotation.SuppressLint
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.ImageView
import android.widget.TextView
import co.facemoji.ALTER_CORE_VERSION
import co.facemoji.async.*
import co.facemoji.avatar.*
import co.facemoji.avatar.data.AvatarMatrix
import pub.devrel.easypermissions.AfterPermissionGranted
import pub.devrel.easypermissions.EasyPermissions
import co.facemoji.logging.*
import co.facemoji.math.Col
import co.facemoji.system.FPS

class MainActivity : AppCompatActivity() {
    companion object {
        const val CAMERA_REQUEST_CODE: Int = 1337
        init {
            // intercept Alter Core logs
            Logger.addLogListener { logLevel, s ->
                when (logLevel) {
                    LogLevel.Warning -> Log.w("AlterCore", s)
                    LogLevel.Error -> Log.e("AlterCore", s)
                    else -> {}
                }
            }
        }
    }

    // for the best performance, keep only one AvatarFactory instance during the application run
    private var avatarFactory: AvatarFactory? = null
    private var avatarView: AvatarView? = null
    // the avatar is loaded asynchronously, keep the future result so that we can schedule
    // face tracking initialization to its completion when camera permission is granted
    private var avatarFuture: Future<Avatar?>? = null
    private var avatar: Avatar? = null
    private var avatarPresets: List<AvatarMatrix> = emptyList()

    private val idleAnimationAvatarController = IdleAnimationAvatarController()

    private var cameraTracker: CameraTracker? = null

    private val fps = FPS(2.0) // used to show fps every 2 seconds
    private lateinit var presetSwapExecutor: PeriodicExecutor
    private var presetIndex = 0

    private lateinit var info: TextView
    private var infoFps = "Loading avatar"
    private var infoNoFace = ""

    @SuppressLint("SourceLockedOrientationActivity")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Log.i("MainActivity", "Alter Core version: $ALTER_CORE_VERSION")

        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

        setContentView(R.layout.activity_main)

        info = findViewById(R.id.info)
        updateInfo()

        // Create factory for downloading and creating avatars. Do not forget to get your avatar data key at https://studio.alter.xyz
        // You might want to handle errors more gracefully in your app. We just log and return here as this demo makes little sense without avatars!
        avatarFactory = AvatarFactory
            .create(avatarDataUrlFromKey("YOUR-API-KEY-HERE"), this)
            .logError("Failed to create avatar factory") // returns the factory if the create is successful, otherwise returns null and logs an error
            ?: return

        // Create an Android view that holds the avatar and handles all the 3D rendering.
        // We need to create it from the factory as the factory and the view need to share an OpenGL context.
        avatarView = avatarFactory?.createAvatarView()

        // Add a simple controller (see IdleAnimationController.kt) to animate the avatar when camera tracking is not running
        // or when no face is detected
        avatarView?.avatarController = idleAnimationAvatarController

        // Make the Avatar view transparent so that we can use it as an overlay over other views.
        avatarView?.isOpaque = false

        // Add the view to the main container
        findViewById<ViewGroup>(R.id.avatarContainer).addView(avatarView)

        // Create our first avatar. Note that loading avatars can take some time (network requests etc.) so we get an asynchronous Future object
        // that resolves when the avatar is ready to display.
        avatarFuture = avatarFactory
            ?.createAvatarFromFile("avatar.json"/*, avatarFactory?.bundledFileSystem*/) // uncomment to load the Avatar matrix from app assets
            ?.logError("Failed to create avatar") // maps the Future<Try<Avatar>> to Future<Avatar?>, logging an error and resolving to null if the load fails

        // When the avatar finishes loading, display it in the view
        avatarFuture?.whenDone { avatar ->
            if (avatar == null) return@whenDone // the load failed, the error was logged above
            this.avatar = avatar
            avatar.setBackgroundColor(Col.TRANSPARENT)
            avatarView?.avatar = avatar
            avatarView?.setOnFrameListener { _ ->
                fps.tick { updateInfo(fps = "${it.toInt()} FPS") }
            }
        }

        // Put the avatar to the UI as soon as it finishes loading
        avatarFactory
            ?.parseAvatarMatricesFromFile("presets.json"/*, avatarFactory?.bundledFileSystem*/) // uncomment to load the avatar presets from app assets
            ?.logError("Failed to load and parse avatar presets")
            ?.whenDone {
                avatarPresets = it ?: emptyList()
                if (avatarPresets.isNotEmpty())
                    presetSwapExecutor = PeriodicExecutor(20.0) { // swap avatar preset every 20 seconds
                        val presetIndex = this.presetIndex
                        Log.i("Avatar presets", "Updating to avatar preset $presetIndex")
                        avatar
                            ?.updateAvatarFromMatrix(avatarPresets[presetIndex])
                            ?.logError("Failed to process avatar preset $presetIndex")
                            ?.whenDone { Log.i("Avatar presets", "Updated to avatar preset $presetIndex") }
                        this.presetIndex = (presetIndex + 1) % avatarPresets.size
                    }

            }

        requestCameraPermission()
    }

    @AfterPermissionGranted(CAMERA_REQUEST_CODE)
    @Suppress("UNUSED") // used by Easy Permissions
    private fun onCameraEnabled() {
        val cameraFuture = CameraTracker
            .create(avatarFactory ?: return)
            .logError("Failed to create camera tracker")

        // When camera is ready, prepare a facial expression controller
        Future
            .both(avatarFuture ?: return, cameraFuture) // have to wait for the avatar future as well because it may still be pending
            .whenDone { (avatar, cameraTracker) ->
                if (avatar == null || cameraTracker == null) return@whenDone
                runOnUiThread {
                    // Switch front and back cameras when tapping the button
                    findViewById<ImageView>(R.id.switchCamera).setOnClickListener {
                        cameraTracker.switchCamera()
                    }
                }

                this.cameraTracker = cameraTracker
                cameraTracker.attachAvatar(avatar)
                cameraTracker.setOnFaceTrackedListener {
                    updateInfo(noFace = if (it) "" else "No face detected")
                }

                // Set the face tracking controller to control the avatar view, fall back to the simple "idle" controller
                // if no face is detected.
                avatarView?.avatarController =
                    FallbackAvatarController(cameraTracker.avatarController ?: return@whenDone, idleAnimationAvatarController)
            }
    }

    private fun requestCameraPermission() {
        EasyPermissions.requestPermissions(
            this,
            "We need camera to breathe life to the avatar",
            CAMERA_REQUEST_CODE,
            Manifest.permission.CAMERA
        )
    }

    @SuppressLint("SetTextI18n")
    private fun updateInfo(fps: String? = null, noFace: String? = null) {
        runOnUiThread {
            infoFps = fps ?: infoFps
            infoNoFace = noFace ?: infoNoFace
            info.text = "$infoFps\n$infoNoFace"
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
    }


    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<String>,
            grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        EasyPermissions.onRequestPermissionsResult(requestCode, permissions, grantResults, this)
    }
}
