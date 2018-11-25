import Foundation
/*
 LWW-Element-Set (Last-Write-Wins-Element-Set)
 LWW-Element-Set is similar to 2P-Set in that it consists of an "add set" and a "remove set", with a timestamp for each element. Elements are added to an LWW-Element-Set by inserting the element into the add set, with a timestamp. Elements are removed from the LWW-Element-Set by being added to the remove set, again with a timestamp. An element is a member of the LWW-Element-Set if it is in the add set, and either not in the remove set, or in the remove set but with an earlier timestamp than the latest timestamp in the add set. Merging two replicas of the LWW-Element-Set consists of taking the union of the add sets and the union of the remove sets. When timestamps are equal, the "bias" of the LWW-Element-Set comes into play. A LWW-Element-Set can be biased towards adds or removals. The advantage of LWW-Element-Set over 2P-Set is that, unlike 2P-Set, LWW-Element-Set allows an element to be reinserted after having been removed.[2]
 */
protocol LWWElementSet {
    associatedtype T : Hashable
    mutating func add(timeStamp: TimeInterval, value: T)
    mutating func remove(timeStamp: TimeInterval, value: T)
    func exist(_ value: T) -> Bool
    func merge() -> [T]
}

struct ElementSet <H: Hashable> {
    var addSet = [H: TimeInterval]()
    var removeSet = [H: TimeInterval]()
}

extension ElementSet: LWWElementSet {
    typealias T = H

    mutating func add(timeStamp: TimeInterval, value: H) {


        let lastRemoved = removeSet[value]
        if lastRemoved != nil {
            if timeStamp > lastRemoved! {
                removeSet.removeValue(forKey: value)
                addSet[value] = timeStamp
            }
        }else {
            let lastAdded = addSet[value]
            if lastAdded == nil || timeStamp > lastAdded! {
                addSet[value] = timeStamp
            }
        }

    }

    mutating func remove(timeStamp: TimeInterval, value: H) {
        let lastAdded = addSet[value]
        if lastAdded != nil {
            if timeStamp > lastAdded! {
                addSet.removeValue(forKey: value)
                removeSet[value] = timeStamp
            }
        }else {
            let lastRemoved = removeSet[value]
            if lastRemoved == nil || timeStamp > lastRemoved! {
                removeSet[value] = timeStamp
            }
        }
    }

    func exist(_ value: H) -> Bool {
        if let _ = addSet[value] {
            return false
        }
        return true
    }

    func merge() -> [H] {
        let keys = Array(addSet.keys)
        return keys
    }
}

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
