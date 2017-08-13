import Cocoa
import Carbon
import LanguageDetector

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSSpeechSynthesizerDelegate {
    
    fileprivate let hotKeyCenter = HotKeyCenter.sharedInstance
    fileprivate let ttsProcessor = TTSProcessor.sharedInstance
    fileprivate let textGrabber = TextGrabber.sharedInstance
    
    func hotKeyPressed() {
        textGrabber.saveSelectedTextToClipboard()
        let timeout = DispatchTime.now() + 0.25
        DispatchQueue.main.asyncAfter(deadline: timeout) {
            let text = self.textGrabber
                .getText()
                .removeBrackets()
            let textChunks = text
                .splitByParagraph()
                .trimItems()
                .filterNotEmpty()
            self.ttsProcessor.say(textChunks)
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.hotKeyPressed),
            name: Notification.Name("HotKeyPressed"),
            object: nil
        )
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

