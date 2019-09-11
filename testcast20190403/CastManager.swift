//
//  CastManager.swift
//  testcast20190403
//
//  Created by Maximus Peters on 4/3/19.
//

import Foundation
import Foundation
import GoogleCast

enum CastSessionStatus {
    case started
    case resumed
    case ended
    case failedToStart
    case alreadyConnected
}

class CastManager: NSObject, GCKLoggerDelegate {

    // static instance
    public static let shared = CastManager()

    private let kReceiverAppID = kGCKDefaultMediaReceiverApplicationID // ?? "7A0CFA14"
    private var sessionManager: GCKSessionManager!

    // '?????????????'
    // What is the meaning of void -> (void) in Swift? https://stackoverflow.com/questions/38968276/what-is-the-meaning-of-void-void-in-swift
    private var sessionStatusListener: ((CastSessionStatus) -> Void)?
    private var sessionStatus: CastSessionStatus! {
        didSet {
            sessionStatusListener?(sessionStatus)
        }
    }

    func addSessionStatusListener(listener: @escaping (CastSessionStatus) -> Void) {
        self.sessionStatusListener = listener
    }

    // A class for controlling media playback on a Cast receiver.
    var remoteMediaClient: GCKRemoteMediaClient? {
        return self.sessionManager.currentCastSession?.remoteMediaClient
    }

    // state of the remoteMediaClient
    var playerState: GCKMediaPlayerState {
        return self.remoteMediaClient?.mediaStatus?.playerState ?? GCKMediaPlayerState.unknown
    }

    var currentCastSession: GCKCastSession? {
        return self.sessionManager.currentCastSession
    }

    var hasConnectionEstablished: Bool {
        let castSession = self.currentCastSession
        if castSession != nil {
            return true
        } else {
            return false
        }
    }

    public func initialise() {
        initialiseContext()
        createSessionManager()
    }

    //creates the GCKSessionManager
    private func createSessionManager() {
        self.sessionManager = GCKCastContext.sharedInstance().sessionManager
    }

    // initialises the GCKCastContext
    private func initialiseContext() {
        //application Id from the registered application
        let discoveryCriteria = GCKDiscoveryCriteria(applicationID: kReceiverAppID)
        let castOptions = GCKCastOptions(discoveryCriteria: discoveryCriteria)
        GCKCastContext.setSharedInstanceWith(castOptions)
        
        // see: https://developers.google.com/cast/docs/ios_sender/integrate#add_expanded_controller
        GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = false

        // register logger for debugger
        GCKLogger.sharedInstance().delegate = self
    }

    // logger function
    func logMessage(_ message: String, at level: GCKLoggerLevel, fromFunction function: String, location: String) {
        print("Message from Chromecast: \(message),\(location)")
    }

    deinit {
        print("\ndeinit")
    }

}



// MARK: - GCKSessionManagerListener

extension CastManager: GCKSessionManagerListener {
    public func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {
        sessionStatus = .started
        print("\n.started\n")
    }

    public func sessionManager(_ sessionManager: GCKSessionManager, didResumeSession session: GCKSession) {
        sessionStatus = .resumed
        print("\n.resumed\n")
    }

    public func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        sessionStatus = .ended
        print("\n.ended\n")
    }

    public func sessionManager(_ sessionManager: GCKSessionManager, didFailToStart session: GCKSession, withError error: Error) {
        sessionStatus = .failedToStart
        print("\n.failedToStart\n")
    }

    public func sessionManager(_ sessionManager: GCKSessionManager, didSuspend session: GCKSession, with reason: GCKConnectionSuspendReason) {
        sessionStatus = .ended
        print("\n.ended\n")
    }
}
