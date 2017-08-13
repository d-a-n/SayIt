import Foundation
import Cocoa
import LanguageDetector


class TTSProcessor: NSObject, NSSpeechSynthesizerDelegate {
    
    fileprivate let synth = NSSpeechSynthesizer()
    fileprivate var chunks: Array<String>?
    
    private override init() {
        super.init()
        synth.delegate = self
    }
    
    static let sharedInstance = TTSProcessor()
    
    func say(_ chunks: Array<String>) {
        self.chunks = chunks
  
        if (synth.isSpeaking) {
            synth.stopSpeaking(at: NSSpeechBoundary.wordBoundary)
        }
        
        start()
    }
    
    func start() {
        if (chunks?.count == 0) {
            return
        }
        if let text = chunks?.removeFirst() {
            if let lang = LanguageDetector.detect(text: text) {
                if (lang.contains("de")) {
                    synth.setVoice("com.apple.speech.synthesis.voice.anna.premium")
                } else if (lang.contains("en")) {
                    synth.setVoice("com.apple.speech.synthesis.voice.Alex")
                }
                
                synth.rate = 230.0
            }
            synth.startSpeaking(text)
        }
    }
    
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool){
        start()
    }
}
