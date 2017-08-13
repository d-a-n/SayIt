import Foundation
import Cocoa
import Carbon

class TextGrabber: NSObject {
    
    fileprivate let pasteboard = NSPasteboard.general()
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance = TextGrabber()
    
    func saveSelectedTextToClipboard() {
        pasteboard.clearContents()
        
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        let cmdu = CGEvent(keyboardEventSource: src, virtualKey: 0x37, keyDown: false)
        
        let c_down = CGEvent(keyboardEventSource: src, virtualKey: 0x08, keyDown: true)
        let c_up = CGEvent(keyboardEventSource: src, virtualKey: 0x08, keyDown: false)
        
        c_down?.flags = CGEventFlags.maskCommand
        c_up?.flags = CGEventFlags.maskCommand
        
        let loc = CGEventTapLocation.cghidEventTap

        c_down?.post(tap: loc)
        c_up?.post(tap: loc)
        cmdu?.post(tap: loc)
    }
    
    
    func getText() -> String {
        if let pasteboardItems = pasteboard.pasteboardItems {
            if let firtPasteboardItem = pasteboardItems.first {
                if let firtPasteboardItemString = firtPasteboardItem.string(forType: "public.utf8-plain-text") {
                    return firtPasteboardItemString
                }
            }
        }
        return ""
    }
}
