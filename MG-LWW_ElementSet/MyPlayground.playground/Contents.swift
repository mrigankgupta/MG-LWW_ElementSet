import Foundation
/*
 LWW-Element-Set (Last-Write-Wins-Element-Set)
 LWW-Element-Set is similar to 2P-Set in that it consists of an "add set" and a "remove set", with a timestamp for each element. Elements are added to an LWW-Element-Set by inserting the element into the add set, with a timestamp. Elements are removed from the LWW-Element-Set by being added to the remove set, again with a timestamp. An element is a member of the LWW-Element-Set if it is in the add set, and either not in the remove set, or in the remove set but with an earlier timestamp than the latest timestamp in the add set. Merging two replicas of the LWW-Element-Set consists of taking the union of the add sets and the union of the remove sets. When timestamps are equal, the "bias" of the LWW-Element-Set comes into play. A LWW-Element-Set can be biased towards adds or removals. The advantage of LWW-Element-Set over 2P-Set is that, unlike 2P-Set, LWW-Element-Set allows an element to be reinserted after having been removed.[2]
 */
protocol LWWElementSet {
    associatedtype T : Hashable
    func add(timestamp: TimeInterval, value: T)
    func remove(timestamp: TimeInterval, value: T)
    func exist(_ value: T)
    func merge()
}

struct ElementSet < H: Hashable> {

}

extension ElementSet: LWWElementSet {
    typealias T = H

    func add(timestamp: TimeInterval, value: H) {

    }

    func remove(timestamp: TimeInterval, value: H) {

    }

    func exist(_ value: H) {

    }

    func merge() {

    }
}
