# LWW_ElementSet (Last-Write-Wins-Element-Set)
This is an implementation of the LWW element set in Swift. 

From wikipedia, "LWW-Element-Set is similar to 2P-Set in that it consists of an "add set" and a "remove set", with a timestamp for each element. 
Elements are added to an LWW-Element-Set by inserting the element into the add set, with a timestamp. Elements are removed from the LWW-Element-Set 
by being added to the remove set, again with a timestamp. An element is a member of the LWW-Element-Set if it is in the add set, and either not in 
the remove set, or in the remove set but with an earlier timestamp than the latest timestamp in the add set. Merging two replicas of the 
LWW-Element-Set consists of taking the union of the add sets and the union of the remove sets. When timestamps are equal, the "bias" of the 
LWW-Element-Set comes into play. A LWW-Element-Set can be biased towards adds or removals. The advantage of LWW-Element-Set over 2P-Set is that, 
unlike 2P-Set, LWW-Element-Set allows an element to be reinserted after having been removed."

At a high level, it provides the following APIs:

- `func add(timeStamp: TimeInterval, value: T)`
- `func remove(timeStamp: TimeInterval, value: T)`
- `func exist(_ value: T) -> Bool`
- `func merge() -> [T]`

Below are all possible combinations of add and remove operations. addSet(elements,...) is the state of the add set. removeSet(elements...) is 
the state of the remove set. An element is added/removed with (value, timestamp). add(element) and remove(element) are the operations.

Original state              | Operation   | Resulting state
----------------------------|-------------|-----------------
addSet(a,1) removeSet()     | add(a,0)    | addSet(a,1) removeSet()
addSet(a,1) removeSet()     | add(a,1)    | addSet(a,1) removeSet()
addSet(a,1) removeSet()     | add(a,2)    | addSet(a,2) removeSet()
addSet(a,1) removeSet()     | remove(a,0) | addSet(a,1) removeSet()
addSet(a,1) removeSet()     | remove(a,1) | addSet(a,1) removeSet()
addSet(a,1) removeSet()     | remove(a,2) | addSet() removeSet(a,2)
addSet() removeSet(a,1)     | add(a,0)    | addSet() removeSet(a,1)
addSet() removeSet(a,1)     | add(a,1)    | addSet() removeSet(a,1)
addSet() removeSet(a,1)     | add(a,2)    | addSet(a,2) removeSet()
addSet() removeSet(a,1)     | remove(a,0) | addSet() removeSet(a,1)
addSet() removeSet(a,1)     | remove(a,1) | addSet() removeSet(a,1)
addSet() removeSet(a,1)     | remove(a,2) | addSet() removeSet(a,2)

The table above is taken from [Roshi](https://github.com/soundcloud/roshi).

## Reference
- [LWW-Element-Set](https://en.wikipedia.org/wiki/Conflict-free_replicated_data_type#LWW-Element-Set_(Last-Write-Wins-Element-Set)) section of the Conflict-free replicated data type Wikipedia page
- [CRDT notes by Paul Frazee](https://github.com/pfrazee/crdt_notes)
- [Roshi](https://github.com/soundcloud/roshi) from SoundCloud
