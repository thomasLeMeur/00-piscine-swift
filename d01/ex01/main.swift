let card1 = Card(c: Color.Spade, v: Value.Ace)
let card2 = Card(c: Color.Spade, v: Value.Ace)
let card3 = Card(c: Color.Diamond, v: Value.Two)
let other = 12
print("card1 : \(card1)")
print("card2 : \(card2)")
print("card3 : \(card3)")
print("other : \(other)")

print("card1 == card2 : \(card1 == card2)")
print("card1 == card3 : \(card1 == card3)")
print("card1 == other : \(card1 == other)")

print("card1.isEqual(to: card2) : \(card1.isEqual(to: card2))")
print("card1.isEqual(to: card3) : \(card1.isEqual(to: card3))")
print("card1.isEqual(to: other) : \(card1.isEqual(to: other))")
