package alter.coredemo

import co.facemoji.avatar.AvatarAnimationData
import co.facemoji.avatar.AvatarController
import co.facemoji.math.Quaternion
import co.facemoji.math.Vec3
import co.facemoji.system.Timer
import kotlin.math.sin

/**
 * Animates the avatar if camera is not available or no face is detected
 */
class IdleAnimationAvatarController : AvatarController {
    private val timer = Timer.start()
    override fun frame(): AvatarAnimationData? {
        val time = timer.tick().elapsed.toFloat()
        val smile = 0.5f + 0.5f * sin(time * 0.5f)
        return AvatarAnimationData(
            mapOf("mouthSmile_L" to smile, "mouthSmile_R" to smile), // for the list of available expression, print co.facemoji.blendshapes.EXPRESSION_BLENDSHAPES
            AvatarAnimationData.DEFAULT_AVATAR_POSITION,
            Quaternion.Companion.fromRotation(0.3f * sin(time * 0.5f), Vec3.zAxis),
            Vec3.one * 0.5f
        )
    }
}