//
//  Copyright © 2021 Omnipresence, Inc. All rights reserved.
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import UIKit
import AlterCore
import Metal
import CoreMedia

class ViewController: UIViewController {
    var avatarView: AvatarView!
    var lblFPS: UILabel?
    var lblHasFace: UILabel?
    var presetSwapExecutor: PeriodicExecutor?
    var viewLoading: UIActivityIndicatorView?
    var camera: CameraWrapper!
    var isLoading: Bool = true
    var fps = FPS(1.0)
    var presetIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a UI view for the avatar
        avatarView = AvatarView(frame: view.bounds)
        view.addSubview(avatarView)
        
        // Create camera capture to get facial expressions for the avatar
        camera = CameraWrapper()
        camera.start()
        
        // Create factory for downloading and creating avatars. Do not forget to get your avatar data key at https://studio.alter.xyz
        // You might want to handle errors more gracefully in your app. We just throw an exception here as this demo makes little sense without avatars!
        let avatarFactory = try! AvatarFactory.create(avatarDataUrlFromKey("YOUR-API-KEY-HERE")).rethrow()
        
        // Create first avatar. Note that loading avatars can take some time (network requests etc.) so we get an asynchronous Future object
        // that resolves when the avatar is ready to display.
        let avatarFuture = avatarFactory.createAvatarFromFile("avatar.json")
        
        // Start moving the avatar based on the user’s face from camera
        TrackerAvatarController.create(avatarFuture)
            .mapTry { controller in
                // Put this controller to the UI view
                self.avatarView.avatarController = controller
                
                // Pipe images from the video capture to the face tracking controller
                // You can adjust anything before sending the image. You can also analyze the face
                // tracking results at this time for your own purposes. We just check whether we detected
                // a face and display it in the UI.
                self.camera.addOnFrameListener { image in
                    let trackResult = controller.updateFromCamera(image)
                    self.onHasFace(trackResult?.hasFace() == true)
                }
            }
            .logError("Error creating face tracker controller") // When anything in the asynchronous pipeline fails, this function will log it
        
        // Put the avatar to the UI as soon as it finishes loading
        avatarFuture.logError("Error loading avatar").whenDone { avatar in
            guard let avatar = avatar else { return } // avatar is nil when an error ocurred (logError passes nil down the async pipeline)
            
            // Show the loaded avatar in the UI!
            self.avatarView.avatar = avatar
            self.onAvatarLoading(false)
        }
        
        // Load more avatars from ready-made presets and start swapping them around
        avatarFactory
            .parseAvatarMatricesFromFile("presets.json")
            .logError("Failed to load and parse avatar presets")
            .whenDone { presets in
                guard let presets = presets else { return } // presets are nil when an error ocurred
                self.presetSwapExecutor = PeriodicExecutor(20.0) { // swap avatar preset every few seconds
                    let presetIndex = self.presetIndex
                    Logger.info("Updating to avatar preset \(presetIndex)")
                    
                    // Update the avatar instance with a new preset
                    self.onAvatarLoading(true)
                    self.avatarView.avatar?.updateAvatarFromMatrix(presets[presetIndex])
                        .logError("Failed to process avatar preset \(presetIndex)")
                        .whenDone { _ in
                            self.onAvatarLoading(false)
                            Logger.info("Updated to avatar preset \(presetIndex)")
                        }
                    self.presetIndex = (presetIndex + 1) % presets.count
                }
            }
        
        // Report FPS regularly in the UI
        avatarView.setOnFrameListener({ _ in
            self.fps.tick { fps in self.onFPS(fps) }
        })
        
        setupUI()
    }
    
    /// Shuffles UI elements around depending on landscape/portrait mode
    func setupUI() {
        let fpsFrame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 16)
        let lblFPS = self.lblFPS ?? UILabel(frame: fpsFrame)
        lblFPS.frame = fpsFrame
        lblFPS.textColor = .black
        lblFPS.textAlignment = .center
        lblFPS.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        if self.lblFPS == nil {
            view.addSubview(lblFPS)
        }
        self.lblFPS = lblFPS
        
        let hasFaceFrame = CGRect(x: 0, y: 66, width: UIScreen.main.bounds.width, height: 16)
        let lblHasFace = self.lblHasFace ?? UILabel(frame: hasFaceFrame)
        lblHasFace.frame = hasFaceFrame
        lblHasFace.textAlignment = .center
        lblHasFace.textColor = .black
        lblHasFace.text = "Doing some magic..."
        lblHasFace.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        if self.lblHasFace == nil {
            view.addSubview(lblHasFace)
        }
        self.lblHasFace = lblHasFace
        
        let loadingFrame = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
        let viewLoading = self.viewLoading ?? UIActivityIndicatorView(frame: loadingFrame)
        viewLoading.frame = loadingFrame
        viewLoading.style = .large
        viewLoading.hidesWhenStopped = true
        if self.viewLoading == nil {
            viewLoading.startAnimating()
            view.addSubview(viewLoading)
        }
        self.viewLoading = viewLoading
        
        
        if self.avatarView.frame != view.bounds {
            self.avatarView.frame = view.bounds
        }
    }
    
    // These methods are important on iOS 13+, without enabling the notifications the app will remain locked in one mode
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    /// Called every few seconds, updates the UI label with FPS
    func onFPS(_ fps: Double) {
        DispatchQueue.main.async {
            self.lblFPS?.text = "FPS: \(Int(fps))"
        }
    }
    
    /// Updates the loading label of the avatar
    func onAvatarLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            self.isLoading = loading
            if loading {
                self.lblHasFace?.textColor = .black
                self.lblHasFace?.text = "Loading data"
                self.viewLoading?.startAnimating()
            } else {
                self.lblHasFace?.text = ""
                self.viewLoading?.stopAnimating()
            }
        }
    }
    
    /// Updates the face found/lost label in the UI
    func onHasFace(_ hasFace: Bool) {
        DispatchQueue.main.async {
            if (!self.isLoading) {
                self.lblHasFace?.textColor = .red
                self.lblHasFace?.text = hasFace ? "" : "No face detected"
            }
        }
    }
}

