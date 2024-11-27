import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class ScanQRCodeScreen extends StatefulWidget {
  const ScanQRCodeScreen({super.key});

  @override
  ScanQRCodeScreenState createState() => ScanQRCodeScreenState();
}

class ScanQRCodeScreenState extends State<ScanQRCodeScreen> {
  bool audioMuted = true;
  bool videoMuted = true;
  bool screenShareOn = false;
  List<String> participants = [];
  final _jitsiMeetPlugin = JitsiMeet();

  // Função para iniciar a reunião Jitsi
  joinMeeting() async {
    var options = JitsiMeetConferenceOptions(
      room: "testroom", // Aqui você pode passar a sala que deseja
      configOverrides: {
        "startWithAudioMuted": true,
        "startWithVideoMuted": true,
      },
      featureFlags: {
        FeatureFlags.addPeopleEnabled: true,
        FeatureFlags.welcomePageEnabled: true,
        FeatureFlags.preJoinPageEnabled: true,
        FeatureFlags.unsafeRoomWarningEnabled: true,
        FeatureFlags.resolution: FeatureFlagVideoResolutions.resolution720p,
        FeatureFlags.audioFocusDisabled: true,
        FeatureFlags.audioMuteButtonEnabled: true,
        FeatureFlags.audioOnlyButtonEnabled: true,
        FeatureFlags.calenderEnabled: true,
        FeatureFlags.callIntegrationEnabled: true,
        FeatureFlags.carModeEnabled: true,
        FeatureFlags.closeCaptionsEnabled: true,
        FeatureFlags.conferenceTimerEnabled: true,
        FeatureFlags.chatEnabled: true,
        FeatureFlags.filmstripEnabled: true,
        FeatureFlags.fullScreenEnabled: true,
        FeatureFlags.helpButtonEnabled: true,
        FeatureFlags.inviteEnabled: true,
        FeatureFlags.androidScreenSharingEnabled: true,
        FeatureFlags.speakerStatsEnabled: true,
        FeatureFlags.kickOutEnabled: true,
        FeatureFlags.liveStreamingEnabled: true,
        FeatureFlags.lobbyModeEnabled: true,
        FeatureFlags.meetingNameEnabled: true,
        FeatureFlags.meetingPasswordEnabled: true,
        FeatureFlags.notificationEnabled: true,
        FeatureFlags.overflowMenuEnabled: true,
        FeatureFlags.pipEnabled: true,
        FeatureFlags.pipWhileScreenSharingEnabled: true,
        FeatureFlags.preJoinPageHideDisplayName: true,
        FeatureFlags.raiseHandEnabled: true,
        FeatureFlags.reactionsEnabled: true,
        FeatureFlags.recordingEnabled: true,
        FeatureFlags.replaceParticipant: true,
        FeatureFlags.securityOptionEnabled: true,
        FeatureFlags.serverUrlChangeEnabled: true,
        FeatureFlags.settingsEnabled: true,
        FeatureFlags.tileViewEnabled: true,
        FeatureFlags.videoMuteEnabled: true,
        FeatureFlags.videoShareEnabled: true,
        FeatureFlags.toolboxEnabled: true,
        FeatureFlags.iosRecordingEnabled: true,
        FeatureFlags.iosScreenSharingEnabled: true,
        FeatureFlags.toolboxAlwaysVisible: true,
      },
      userInfo: JitsiMeetUserInfo(
          displayName: "Gabi",
          email: "gabi.borlea.1@gmail.com",
          avatar:
              "https://avatars.githubusercontent.com/u/57035818?s=400&u=02572f10fe61bca6fc20426548f3920d53f79693&v=4"),
    );

    var listener = JitsiMeetEventListener(
      conferenceJoined: (url) {
        debugPrint("conferenceJoined: url: $url");
      },
      conferenceTerminated: (url, error) {
        debugPrint("conferenceTerminated: url: $url, error: $error");
      },
      conferenceWillJoin: (url) {
        debugPrint("conferenceWillJoin: url: $url");
      },
      participantJoined: (email, name, role, participantId) {
        debugPrint(
            "participantJoined: email: $email, name: $name, role: $role, participantId: $participantId");
        participants.add(participantId!);
      },
      participantLeft: (participantId) {
        debugPrint("participantLeft: participantId: $participantId");
      },
      audioMutedChanged: (muted) {
        debugPrint("audioMutedChanged: isMuted: $muted");
      },
      videoMutedChanged: (muted) {
        debugPrint("videoMutedChanged: isMuted: $muted");
      },
      screenShareToggled: (participantId, sharing) {
        debugPrint(
            "screenShareToggled: participantId: $participantId, isSharing: $sharing");
      },
      chatMessageReceived: (senderId, message, isPrivate, timestamp) {
        debugPrint(
            "chatMessageReceived: senderId: $senderId, message: $message, isPrivate: $isPrivate, timestamp: $timestamp");
      },
      chatToggled: (isOpen) => debugPrint("chatToggled: isOpen: $isOpen"),
      participantsInfoRetrieved: (participantsInfo) {
        debugPrint(
            "participantsInfoRetrieved: participantsInfo: $participantsInfo");
      },
      readyToClose: () {
        debugPrint("readyToClose");
      },
    );

    await _jitsiMeetPlugin.join(options, listener);
  }

  // Função para terminar a reunião
  hangUp() async {
    await _jitsiMeetPlugin.hangUp();
  }

  // Função para alternar áudio
  setAudioMuted(bool? muted) async {
    var result = await _jitsiMeetPlugin.setAudioMuted(muted!);
    debugPrint("$result");
    setState(() {
      audioMuted = muted;
    });
  }

  // Função para alternar vídeo
  setVideoMuted(bool? muted) async {
    var result = await _jitsiMeetPlugin.setVideoMuted(muted!);
    debugPrint("$result");
    setState(() {
      videoMuted = muted;
    });
  }

  // Função para enviar mensagem de texto
  sendEndpointTextMessage() async {
    var result = await _jitsiMeetPlugin.sendEndpointTextMessage(message: "HEY");
    debugPrint("$result");

    for (var p in participants) {
      var result =
          await _jitsiMeetPlugin.sendEndpointTextMessage(to: p, message: "HEY");
      debugPrint("$result");
    }
  }

  // Função para alternar o compartilhamento de tela
  toggleScreenShare(bool? enabled) async {
    await _jitsiMeetPlugin.toggleScreenShare(enabled!);

    setState(() {
      screenShareOn = enabled;
    });
  }

  // Função para abrir chat
  openChat() async {
    await _jitsiMeetPlugin.openChat();
  }

  // Função para enviar mensagem no chat
  sendChatMessage() async {
    var result = await _jitsiMeetPlugin.sendChatMessage(message: "HEY1");
    debugPrint("$result");

    for (var p in participants) {
      result = await _jitsiMeetPlugin.sendChatMessage(to: p, message: "HEY2");
      debugPrint("$result");
    }
  }

  // Função para fechar chat
  closeChat() async {
    await _jitsiMeetPlugin.closeChat();
  }

  // Função para recuperar informações dos participantes
  retrieveParticipantsInfo() async {
    var result = await _jitsiMeetPlugin.retrieveParticipantsInfo();
    debugPrint("$result");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jitsi Meet Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: joinMeeting,
              child: const Text("Join Meeting"),
            ),
            TextButton(
              onPressed: hangUp,
              child: const Text("Hang Up"),
            ),
            Row(
              children: [
                const Text("Set Audio Muted"),
                Checkbox(
                  value: audioMuted,
                  onChanged: setAudioMuted,
                ),
              ],
            ),
            Row(
              children: [
                const Text("Set Video Muted"),
                Checkbox(
                  value: videoMuted,
                  onChanged: setVideoMuted,
                ),
              ],
            ),
            TextButton(
              onPressed: sendEndpointTextMessage,
              child: const Text("Send Text Message To All"),
            ),
            Row(
              children: [
                const Text("Toggle Screen Share"),
                Checkbox(
                  value: screenShareOn,
                  onChanged: toggleScreenShare,
                ),
              ],
            ),
            TextButton(
              onPressed: openChat,
              child: const Text("Open Chat"),
            ),
            TextButton(
              onPressed: sendChatMessage,
              child: const Text("Send Chat Message to All"),
            ),
            TextButton(
              onPressed: closeChat,
              child: const Text("Close Chat"),
            ),
            TextButton(
              onPressed: retrieveParticipantsInfo,
              child: const Text("Retrieve Participants Info"),
            ),
          ],
        ),
      ),
    );
  }
}
