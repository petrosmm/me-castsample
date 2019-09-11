//
//  ViewController.swift
//  testcast20190403
//
//  Created by Maximus Peters on 4/3/19.
//

import UIKit
import GoogleCast

let kCastControlBarsAnimationDuration: TimeInterval = 0.20
// Requests updated media status information from the receiver.

class ViewController: UIViewController,
    Castable,
    GCKUIMiniMediaControlsViewControllerDelegate {

        // navigation button for the chrome bar
        @IBOutlet private var myNavigationItem: UINavigationItem!
        @IBOutlet weak private var _miniMediaControlsContainerView: UIView!

        @IBOutlet weak var _miniMediaControlsHeightConstraint: NSLayoutConstraint!

        private var miniMediaControlsViewController: GCKUIMiniMediaControlsViewController!
        var miniMediaControlsViewEnabled = false {
            didSet {
                if self.isViewLoaded {
                    self.updateControlBarsVisibility()
                }
            }
        }

        var overriddenNavigationController: UINavigationController?

        override var navigationController: UINavigationController? {

            get {
                return overriddenNavigationController
            }

            set {
                overriddenNavigationController = newValue
            }
        }
        var miniMediaControlsItemEnabled = false


        @IBAction func playerStatusButton(_ sender: Any) {
            print("\nCastManager.shared.state: \(CastManager.shared.playerState.rawValue)")
            print("\nCastManager.shared.state: \(CastManager.shared.playerState)")
            let x = CastManager.shared.playerState
            print("\nhasConnectionEstablished: \(CastManager.shared.hasConnectionEstablished)")
        }

        // A builder object for constructing new or derived GCKMediaInformation instances.
        // https://github.com/PopcornTimeTV/PopcornTimeTV/blob/master/PopcornTime/UI/iOS/View%20Controllers/CastPlayerViewController.swift
        private var mediaInfo = GCKMediaInformationBuilder()

        // livestream Url
        private let url = URL(string: "http://media.smc-host.com:1935/csat.tv/smil:csat.smil/playlist.m3u8")!

        // Options for loading media with GCKRemoteMediaClient.
        private let loadOptions = GCKMediaLoadOptions()

        // check connection button
        @IBAction func myButton(_ sender: Any) {
            play()
        }

        func setupCastButton() {
            let castButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            castButton.tintColor = UIColor.purple
            myNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: castButton)
        }

        // Set media metadata: https://developers.google.com/cast/docs/ios_sender/integrate#set_media_metadata
        // How to add/use GCKMediaQueue in Swift? https://stackoverflow.com/questions/55092942/how-to-add-use-gckmediaqueue-in-swift
        // Media Playback Messages: https://developers.google.com/cast/docs/reference/messages
        func play() {
            let metadata = GCKMediaMetadata(metadataType: GCKMediaMetadataType.generic)
            let deviceNameOrStudio = CastManager.shared.currentCastSession?.device.friendlyName ?? "studio.string"
            metadata.setString(deviceNameOrStudio + "title", forKey: kGCKMetadataKeyTitle)
            //
            // if let image = media.smallCoverImage, let url = URL(string: image) {  }
            // width: 480, height: 720
            metadata.addImage(GCKImage(url: URL(string: "https://www.csat.tv/images/1234.PNG")!, width: 197, height: 220))

            metadata.setString(deviceNameOrStudio, forKey: kGCKMetadataKeyStudio)

            mediaInfo = GCKMediaInformationBuilder(contentURL: url)
            mediaInfo.contentID = url.relativeString
            mediaInfo.streamType = GCKMediaStreamType.none
            mediaInfo.contentType = "video/m3u" // not "video/m3u8"
            mediaInfo.metadata = metadata
            mediaInfo.streamDuration = 0
            mediaInfo.textTrackStyle = GCKMediaTextTrackStyle.createDefault()

            if (false) {
                loadOptions.autoplay = false
            }

            // GCKRemoteMediaClientListener.remoteMediaClientDidUpdateQueue
            CastManager.shared.remoteMediaClient?.loadMedia(mediaInfo.build(), with: loadOptions)
            if (false) {
                CastManager.shared.remoteMediaClient?.play()
                listenForCastConnection()
            }
        }

        func play2() {

        }

        private func listenForCastConnection() {
            let sessionStatusListener: (CastSessionStatus) -> Void = { status in
                print("\nstatus: \(status)")
            }

            CastManager.shared.addSessionStatusListener(listener: sessionStatusListener)
        }

        // What exactly is init coder aDecoder?
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            print("\nviewDidLoad")

            let castContext = GCKCastContext.sharedInstance()
            self.miniMediaControlsViewController = castContext.createMiniMediaControlsViewController()
            self.miniMediaControlsViewController.delegate = self
            self.updateControlBarsVisibility()
            self.installViewController(self.miniMediaControlsViewController, inContainerView: self._miniMediaControlsContainerView)

            if (false) { listenForCastConnection() }
            setupCastButton()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            print("\nviewWillAppear\n")
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            print("\nviewDidAppear\n")

        }

        func updateControlBarsVisibility() {
            if self.miniMediaControlsViewEnabled &&
                self.miniMediaControlsViewController.active // && self.googleCastBarButton.isHidden
                {
                    self._miniMediaControlsHeightConstraint.constant = self.miniMediaControlsViewController.minHeight
                    self.view.bringSubviewToFront(self._miniMediaControlsContainerView)
            } else {
                self._miniMediaControlsHeightConstraint?.constant = 0
            }

            UIView.animate(withDuration: kCastControlBarsAnimationDuration, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })

            self.view.setNeedsLayout()
        }

        func installViewController(_ viewController: UIViewController?, inContainerView containerView: UIView) {
            if let viewController = viewController {
                self.addChild(viewController)
                viewController.view.frame = containerView.bounds
                containerView.addSubview(viewController.view)
                viewController.didMove(toParent: self)
            }
        }

        func uninstallViewController(_ viewController: UIViewController) {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "NavigationVCEmbedSegue" {
                self.navigationController = (segue.destination as? UINavigationController)
            }
        }

        func miniMediaControlsViewController(_ miniMediaControlsViewController: GCKUIMiniMediaControlsViewController,
                                             shouldAppear: Bool) {
            self.updateControlBarsVisibility()
        }


}

extension UIBarButtonItem {
    
    var isHidden: Bool {
        get {
            return tintColor == .clear
        }
        set {
            tintColor = newValue ? .clear : .white //or whatever color you want
            isEnabled = !newValue
            isAccessibilityElement = !newValue
        }
    }
    
}
