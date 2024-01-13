extension Comparable {
    func isBetween(_ a: Self, and b: Self) -> Bool {
        return self >= a && self <= b
    }
}

extension String {
    var isNotEmpty: Bool {
        self.isEmpty == false
    }
}

extension Set {
    mutating func toggle(_ element: Element) {
        if contains(element) {
            remove(element)
        } else {
            insert(element)
        }
    }
}
