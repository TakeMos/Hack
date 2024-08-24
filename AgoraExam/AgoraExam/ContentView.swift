import SwiftUI

struct ContentView: View {
    @StateObject private var micPermission = MicrophonePermissionManager()
    @StateObject private var agoraManager = AgoraManager()
    @State private var channelName = ""

    var body: some View {
        VStack {
            if micPermission.permissionGranted {
                if agoraManager.isInChannel {
                    Text("In Channel")
                    if agoraManager.remoteUserJoined {
                        Text("Remote User Joined")
                    }
                    Button("Leave Channel") {
                        agoraManager.leaveChannel()
                    }
                } else {
                    TextField("채널 이름을 입력해주세요", text: $channelName)
                    Button("Join Channel") {
                        agoraManager.joinChannel(channelName: channelName)
                    }
                }
            } else {
                Text("Microphone access is required for VoIP calls")
                Button("Request Microphone Permission") {
                    micPermission.requestPermission()
                }
            }
        }
        .padding()
        .onAppear {
            micPermission.checkPermission()
        }
    }
}

#Preview {
    ContentView()
}
