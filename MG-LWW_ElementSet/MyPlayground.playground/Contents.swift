import Foundation
import LWWElementSet

var elementSet = ElementSet<String>()
elementSet.add(timeStamp: 1, value: "a")
//1
print(1,elementSet)
elementSet.add(timeStamp: 0, value: "a")
print(elementSet)
elementSet.add(timeStamp: 1, value: "a")
print(elementSet)
elementSet.add(timeStamp: 2, value: "a")
print(elementSet)

elementSet = ElementSet<String>()
elementSet.add(timeStamp: 1, value: "a")
//2
print(2,elementSet)
elementSet.remove(timeStamp: 0, value: "a")
print(elementSet)
elementSet.remove(timeStamp: 1, value: "a")
print(elementSet)
elementSet.remove(timeStamp: 2, value: "a")
print(elementSet)

elementSet = ElementSet<String>()
elementSet.remove(timeStamp: 1, value: "a")
//3
print(3,elementSet)
elementSet.add(timeStamp: 0, value: "a")
print(elementSet)
elementSet.add(timeStamp: 1, value: "a")
print(elementSet)
elementSet.add(timeStamp: 2, value: "a")
print(elementSet)

elementSet = ElementSet<String>()
elementSet.remove(timeStamp: 1, value: "a")
//4
print(4,elementSet)
elementSet.remove(timeStamp: 0, value: "a")
print(elementSet)
elementSet.remove(timeStamp: 1, value: "a")
print(elementSet)
elementSet.remove(timeStamp: 2, value: "a")
print(elementSet)
