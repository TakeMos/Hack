import AgoraRtcKit


class AgoraManager: NSObject, ObservableObject {
    @Published var isInChannel = false
    @Published var remoteUserJoined = false
    var agoraKit: AgoraRtcEngineKit?
    
    override init() {
        super.init()
        // Initialize the AgoraRtcEngineKit instance
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "85346947a1ea4fb28109d090d3e1ec50", delegate: self)
    }
    
    func joinChannel(channelName: String) {
        let options = AgoraRtcChannelMediaOptions()
        options.channelProfile = .communication
        options.clientRoleType = .broadcaster
        options.publishMicrophoneTrack = true
        options.autoSubscribeAudio = true
        
        // Join the channel
        agoraKit?.joinChannel(byToken: "007eJxTYJA7WrL54qrbr3TWrfA8wLlDljklwi8098qVhLKfVrsW93srMFiYGpuYWZqYJxqmJpqkJRlZGBpYphhYGqQYpxqmJpsaZAecTGsIZGT4stSbhZEBAkF8Fob0/PwUBgYAhXsgLw==", channelId: channelName, uid: 0, mediaOptions: options) { _, uid, _ in
            print("Joined channel with uid: \(uid)")
            self.isInChannel = true
        }
    }
    
    func leaveChannel() {
        agoraKit?.leaveChannel(nil)
        isInChannel = false
        remoteUserJoined = false
    }
    
    deinit {
        AgoraRtcEngineKit.destroy()
    }
}

extension AgoraManager: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        DispatchQueue.main.async {
            self.remoteUserJoined = true
        }
        print("User \(uid) joined after \(elapsed) milliseconds")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        DispatchQueue.main.async {
            self.remoteUserJoined = false
        }
        print("User \(uid) left")
    }
}
