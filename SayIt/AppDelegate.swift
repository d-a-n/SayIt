//
//  AppDelegate.swift
//  SayIt
//
//  Created by dan on 8/13/17.
//  Copyright © 2017 dan. All rights reserved.
//

import Cocoa
import Carbon
import LanguageDetector

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSSpeechSynthesizerDelegate {
    
    fileprivate var hotKey: HotKey?
    fileprivate let pasteboard = NSPasteboard.general()
    fileprivate var textChunks:[String]?
    fileprivate let synth = NSSpeechSynthesizer()
    
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool){
        print("finished speaking=\(finishedSpeaking)")
        say()
    }
    
    func say() {
        if (textChunks?.count == 0) {
            return
        }
        if let text = textChunks?.removeFirst() {
            
            print("--###--> \(text)")
        
            if let lang = LanguageDetector.detect(text: text) {
                print("lang: \(lang)")
                if (lang.contains("de")) {
                    synth.setVoice("com.apple.speech.synthesis.voice.anna.premium")
                } else if (lang.contains("en")) {
                    synth.setVoice("com.apple.speech.synthesis.voice.Alex")
                }
                
                synth.rate = 230.0
            }
            
            synth.startSpeaking(text)
            print("---> \(text)")
            
        }
    }
    
    func copyText() {
        // Clear pasteboard
        pasteboard.clearContents()
        
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        
        //let cmdd = CGEventCreateKeyboardEvent(src, 0x37, true)
        let cmdu = CGEvent(keyboardEventSource: src, virtualKey: 0x37, keyDown: false)
        
        let c_down = CGEvent(keyboardEventSource: src, virtualKey: 0x08, keyDown: true)
        let c_up = CGEvent(keyboardEventSource: src, virtualKey: 0x08, keyDown: false)
        
        // Set Flags
        c_down?.flags = CGEventFlags.maskCommand
        c_up?.flags = CGEventFlags.maskCommand
        
        let loc = CGEventTapLocation.cghidEventTap
        
        //CGEventPost(loc, cmdd)
        c_down?.post(tap: loc)
        c_up?.post(tap: loc)
        cmdu?.post(tap: loc)
    }
    
    
    func paste() -> String {
        if let pasteboardItems = pasteboard.pasteboardItems {
            if let firtPasteboardItem = pasteboardItems.first {
                if let firtPasteboardItemString = firtPasteboardItem.string(forType: "public.utf8-plain-text") {
                    return firtPasteboardItemString
                }
            }
        }
        return ""
    }
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        synth.delegate = self
        
        // Insert code here to initialize your application
        hotKey = HotKey(keyCode: kVK_ANSI_G, modifiers: controlKey, block: {
            print("---> tpes")
            self.copyText()
            
            if (self.synth.isSpeaking) {
                self.synth.pauseSpeaking(at: NSSpeechBoundary.wordBoundary)
                return
            }
        
            let deadlineTime = DispatchTime.now() + 0.25
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                let text = self.paste()
                
                print("input text: \(text)")
                
                self.textChunks = text.components(separatedBy: "\n")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter() {
                        if let chunk = $0 as String? {
                            print("---> \(chunk)")
                            return chunk.characters.count > 0
                        } else {
                            return false
                        }
                    }
                
                print("self.textChunks: \(self.textChunks!)")
                
                self.say()
                
    /*
                
                
                if let lang = LanguageDetector.detect(text: text) {
                    print("lang: \(lang)")
                    if (lang.contains("de")) {
                        synth.setVoice("com.apple.speech.synthesis.voice.anna.premium")
                    } else if (lang.contains("en")) {
                        synth.setVoice("com.apple.speech.synthesis.voice.Alex")
                    }
                    
                    synth.rate = 230.0
                }
                
                synth.startSpeaking(text)
                print("---> \(text)")
 
 */

            }
            
        })

        

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

