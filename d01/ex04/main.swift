var d: Deck? = nil
if CommandLine.arguments.count < 2 {
	print("Sorted deck :")
	d = Deck(toSort: true)
} else {
	print("Random deck :")
	d = Deck(toSort: false)
}

var a = d!
print(a)
print("")

print("Draw and fold the ten first cards :")
for i in 0..<10 {
	if let card = a.draw() {
		a.fold(c: card)
	}
}

print("Current cards :")
print(a)
print("")

print("Current discards :")
print(a.discards)
print("")

print("Current outs :")
print(a.outs)
print("")

print("Draw the first card and fold a bad one :")
let t = a.draw()
a.fold(c: a.cards[0])

print("Current cards :")
print(a)
print("")

print("Current discards :")
print(a.discards)
print("")

print("Current outs :")
print(a.outs)
print("")
