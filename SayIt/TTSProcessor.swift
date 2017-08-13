import Foundation
import Cocoa
import LanguageDetector

class TTSProcessor: NSObject, NSSpeechSynthesizerDelegate {
    
    fileprivate let synth = NSSpeechSynthesizer()
    fileprivate var chunks: Array<String>?
    fileprivate var voices: [String: String] = [:]
    
    private override init() {
        super.init()
        
        voices["ar"] = "com.apple.speech.synthesis.voice.maged"
        voices["cs"] = "com.apple.speech.synthesis.voice.zuzana"
        voices["da"] = "com.apple.speech.synthesis.voice.sara"
        voices["de"] = "com.apple.speech.synthesis.voice.anna.premium"
        voices["el"] = "com.apple.speech.synthesis.voice.melina"
        voices["en"] = "com.apple.speech.synthesis.voice.Alex"
        voices["es"] = "com.apple.speech.synthesis.voice.jorge"
        voices["es"] = "com.apple.speech.synthesis.voice.juan"
        voices["fi"] = "com.apple.speech.synthesis.voice.satu"
        voices["fr"] = "com.apple.speech.synthesis.voice.thomas"
        voices["he"] = "com.apple.speech.synthesis.voice.carmit"
        voices["hi"] = "com.apple.speech.synthesis.voice.lekha"
        voices["hu"] = "com.apple.speech.synthesis.voice.mariska"
        voices["id"] = "com.apple.speech.synthesis.voice.damayanti"
        voices["it"] = "com.apple.speech.synthesis.voice.luca"
        voices["ja"] = "com.apple.speech.synthesis.voice.kyoko"
        voices["ko"] = "com.apple.speech.synthesis.voice.yuna"
        voices["nb"] = "com.apple.speech.synthesis.voice.nora"
        voices["nl"] = "com.apple.speech.synthesis.voice.xander"
        voices["pl"] = "com.apple.speech.synthesis.voice.zosia"
        voices["pt"] = "com.apple.speech.synthesis.voice.joana"
        voices["ro"] = "com.apple.speech.synthesis.voice.ioana"
        voices["ru"] = "com.apple.speech.synthesis.voice.yuri"
        voices["sk"] = "com.apple.speech.synthesis.voice.laura"
        voices["sv"] = "com.apple.speech.synthesis.voice.alva"
        voices["th"] = "com.apple.speech.synthesis.voice.kanya"
        voices["tr"] = "com.apple.speech.synthesis.voice.yelda"
        voices["zh"] = "com.apple.speech.synthesis.voice.mei-jia"
        voices["zh"] = "com.apple.speech.synthesis.voice.sin-ji"
    
        synth.delegate = self
    }
    
    static let sharedInstance = TTSProcessor()
    
    func say(_ chunks: Array<String>) {
        self.chunks = chunks
  
        if (synth.isSpeaking) {
            synth.stopSpeaking(at: NSSpeechBoundary.immediateBoundary)
        }
        
        self.start()
    }
    
    func start() {
        if (chunks?.count == 0) {
            return
        }
        if let text = chunks?.removeFirst() {
            if let lang = LanguageDetector.detect(text: text) {
                if let voice = voices[lang] {
                    synth.setVoice(voice)
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
