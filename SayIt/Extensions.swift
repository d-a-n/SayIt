import Foundation

extension String {
    func splitByParagraph() -> Array<String> {
        return self.components(separatedBy: "\n")
    }
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
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
