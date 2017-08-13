import Foundation
import Carbon

class HotKeyCenter: NSObject
{
    fileprivate var hotKey: HotKey?
    
    private override init() {
        super.init()
        hotKey = HotKey(keyCode: kVK_ANSI_G, modifiers: controlKey, block: {
            NotificationCenter.default.post(name: Notification.Name("HotKeyPressed"), object: nil)
        })
    }

    static let sharedInstance = HotKeyCenter()
}
