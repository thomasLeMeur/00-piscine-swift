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

	var cards: [Card] = [Card]()
	var discards: [Card] = [Card]()
	var outs: [Card] = [Card]()

	init (toSort: Bool) {
		cards = Deck.allCards
		if toSort {
			cards.sort {
				if ($0.value.rawValue != $1.value.rawValue) {
					return $0.value.rawValue < $1.value.rawValue
				} else if ($0.color.rawValue != $1.color.rawValue) {
					return $0.color.rawValue < $1.color.rawValue
				} else {
					return true
				}
			}
		} else {
			self.cards.randomize()
		}
	}

	override var description : String {
		var s = ""
		for card in self.cards {
			if s != "" {
				s += "\n"
			}
			s += "\(card)"
		}
		return s
	}

	func draw() -> Card? {
		let tmp: Card? = cards.first
		if let card = tmp {
			outs.append(card)
			cards.remove(at: 0)
		}
		return tmp
	}

	func fold(c: Card) {
		if let id = outs.index(of: c) {
			discards.append(outs[id])
			outs.remove(at: id)
		}
	}
}
