import Foundation

class Card : NSObject {
	var color: Color
	var value: Value

	init (c: Color, v: Value) {
		self.color = c
		self.value = v
	}

	override var description: String {
		return "(\(self.value.rawValue), \(self.color.rawValue))"
	}

	override func isEqual(to object: Any?) -> Bool {
		let other = object as? Card
		if (self.color == other?.color && self.value == other?.value) {
			return true
		} else {
			return false
		}
	}

	static func ==(lhs: Card, rhs: Any?) -> Bool {
		return lhs.isEqual(to: rhs)
	}
}
