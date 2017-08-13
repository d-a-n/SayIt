import Foundation

extension String {
    func splitByParagraph() -> Array<String> {
        return self.components(separatedBy: "\n")
    }
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func replace(pattern: String, replacement: String = "") -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return regex.stringByReplacingMatches(in: self, options: [], range: NSRange(0..<self.utf16.count), withTemplate: replacement)
    }
    func removeBrackets() -> String {
        return self.replace(pattern: "\\[[^]]*\\]")
    }
}

extension Sequence where Iterator.Element == String {
    func trimItems() -> Array<String> {
        return self.map { $0.trim() }
    }
    func filterNotEmpty() -> Array<String> {
        return self.filter() { $0.characters.count > 0 }
    }
}
