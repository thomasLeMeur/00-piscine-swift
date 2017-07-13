import Foundation

extension Array {
	mutating func randomize() {
		var tmp = Array()
		while self.count > 0 {
			let id = Int(arc4random_uniform(UInt32(self.count)))
			tmp.append(self[id])
			self.remove(at: id)
		}
		self = tmp
	}
}

class Deck : NSObject {
	static let allSpades: [Card] = Value.allValues.map( { Card(c: Color.Spade, v: $0) } )
	static let allDiamonds: [Card] = Value.allValues.map( { Card(c: Color.Diamond, v: $0) } )
	static let allHearts: [Card] = Value.allValues.map( { Card(c: Color.Heart, v: $0) } )
	static let allClubs: [Card] = Value.allValues.map( { Card(c: Color.Club, v: $0) } )

	static let allCards: [Card] = allSpades + allDiamonds + allHearts + allClubs
}
