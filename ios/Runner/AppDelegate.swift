import UIKit
import Flutter
import Firebase
import AVFoundation

class SpeechStatusStreamHandler: NSObject, FlutterStreamHandler {
    
    var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, AVSpeechSynthesizerDelegate {

    var synthesizer = AVSpeechSynthesizer()
    let speechStatusStreamHandler = SpeechStatusStreamHandler()

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseApp.configure()

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let textToSpeechChannel = FlutterMethodChannel(name: "text_to_speech", binaryMessenger: controller.binaryMessenger)
        textToSpeechChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) in
    switch call.method {
    case "speakText":
        guard let args = call.arguments else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments provided.", details: nil))
            return
        }

        if let myArgs = args as? [String: Any], let text = myArgs["text"] as? String {
            let utterance = AVSpeechUtterance(string: text)
            if let aaronVoice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.compact.en-US.Samantha") {
                utterance.voice = aaronVoice
            }

            self.synthesizer.delegate = self
            self.synthesizer.speak(utterance)
            result(nil) // Bu satırı ekleyin. Method çağrısının tamamlandığını belirtir.
        } else {
            result(FlutterError(code: "INVALID_TEXT", message: "No text provided.", details: nil))
        }
    case "stopText":
        self.synthesizer.stopSpeaking(at: .immediate)
        result(nil)  // Method çağrısının tamamlandığını belirtir.
    default:
        result(FlutterMethodNotImplemented)
    }
})


        let speechStatusChannel = FlutterEventChannel(name: "speech_status", binaryMessenger: controller.binaryMessenger)
        speechStatusChannel.setStreamHandler(speechStatusStreamHandler)

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("Seslendirme başladı.")
        speechStatusStreamHandler.eventSink?("started")
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("Seslendirme bitti.")
        speechStatusStreamHandler.eventSink?("finished")
    }
}
