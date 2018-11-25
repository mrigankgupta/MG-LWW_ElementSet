//
//  LWWElementSetTests.swift
//  LWWElementSetTests
//
//  Created by Gupta, Mrigank on 25/11/18.
//  Copyright © 2018 Gupta, Mrigank. All rights reserved.
//

import XCTest
@testable import LWWElementSet

class LWWElementSetTests: XCTestCase {
    var elementSet: ElementSet<String>!
    var associativeSet: ElementSet<String>!
    var commutativeSet: ElementSet<String>!
    var idempotenceSet: ElementSet<String>!
    var operations: [(Int , Double)]!

    override func setUp() {
        elementSet = ElementSet<String>()
        associativeSet = ElementSet<String>()
        commutativeSet = ElementSet<String>()
        idempotenceSet = ElementSet<String>()
        operations = [(0,1), (1,2), (1,3), (0,0), (1,1), (1,2), (0,2), (0,1), (1,2), (1,3), (0,1)]
    }

    override func tearDown() {
        elementSet = nil
    }

    func testAddWhenAlreadyAdded() {
        //when
        elementSet.add(timeStamp: 1, value: "a")
        //then
        elementSet.add(timeStamp: 0, value: "a")
        XCTAssertEqual(elementSet.addSet["a"], 1)
        XCTAssertEqual(elementSet.removeSet.count, 0)
        elementSet.add(timeStamp: 1, value: "a")
        XCTAssertEqual(elementSet.addSet["a"], 1)
        XCTAssertEqual(elementSet.removeSet.count, 0)
        elementSet.add(timeStamp: 2, value: "a")
        XCTAssertEqual(elementSet.addSet["a"], 2)
        XCTAssertEqual(elementSet.removeSet.count, 0)
    }

    func testRemoveWhenAlreadyAdded() {
        //when
        elementSet.add(timeStamp: 1, value: "a")
        //then
        elementSet.remove(timeStamp: 0, value: "a")
        XCTAssertEqual(elementSet.addSet["a"], 1)
        XCTAssertEqual(elementSet.removeSet.count, 0)
        elementSet.remove(timeStamp: 1, value: "a")
        XCTAssertEqual(elementSet.addSet["a"], 1)
        XCTAssertEqual(elementSet.removeSet.count, 0)
        elementSet.remove(timeStamp: 2, value: "a")
        XCTAssertEqual(elementSet.addSet.count, 0)
        XCTAssertEqual(elementSet.removeSet["a"], 2)
    }

    func testAddWhenAlreadyRemoved() {
        //when
        elementSet.remove(timeStamp: 1, value: "a")
        //then
        elementSet.add(timeStamp: 0, value: "a")
        XCTAssertEqual(elementSet.removeSet["a"], 1)
        XCTAssertEqual(elementSet.addSet.count, 0)
        elementSet.add(timeStamp: 1, value: "a")
        XCTAssertEqual(elementSet.removeSet["a"], 1)
        XCTAssertEqual(elementSet.addSet.count, 0)
        elementSet.add(timeStamp: 2, value: "a")
        XCTAssertEqual(elementSet.addSet["a"], 2)
        XCTAssertEqual(elementSet.removeSet.count, 0)
    }

    func testRemoveWhenAlreadyRemoved() {
        //when
        elementSet.remove(timeStamp: 1, value: "a")
        //then
        elementSet.remove(timeStamp: 0, value: "a")
        XCTAssertEqual(elementSet.removeSet["a"], 1)
        XCTAssertEqual(elementSet.addSet.count, 0)
        elementSet.remove(timeStamp: 1, value: "a")
        XCTAssertEqual(elementSet.removeSet["a"], 1)
        XCTAssertEqual(elementSet.addSet.count, 0)
        elementSet.remove(timeStamp: 2, value: "a")
        XCTAssertEqual(elementSet.removeSet["a"], 2)
        XCTAssertEqual(elementSet.addSet.count, 0)
    }

    func testAssociativeCommutativeIdempotence() {
        for (op, time) in operations {
            if op == 0 {
                elementSet.add(timeStamp: time, value: "a")
            }else{
                elementSet.remove(timeStamp: time, value: "a")
            }
        }
        //Associative
        for (op, time) in operations.reversed() {
            if op == 0 {
                associativeSet.add(timeStamp: time, value: "a")
            }else{
                associativeSet.remove(timeStamp: time, value: "a")
            }
        }
        XCTAssertEqual(associativeSet.addSet["a"], elementSet.addSet["a"])
        XCTAssertEqual(associativeSet.removeSet["a"], elementSet.removeSet["a"])

        //Commutative
        //random jumbled
        for _ in 0..<operations.count {
            let fst = Int(arc4random())%(operations.count-1)
            let sec = Int(arc4random())%(operations.count-1)
            operations.swapAt(fst, sec)
        }

        for (op, time) in operations {
            if op == 0 {
                commutativeSet.add(timeStamp: time, value: "a")
            }else{
                commutativeSet.remove(timeStamp: time, value: "a")
            }
        }
        XCTAssertEqual(commutativeSet.addSet["a"], elementSet.addSet["a"])
        XCTAssertEqual(commutativeSet.removeSet["a"], elementSet.removeSet["a"])

        //Idempotence
        for (op, time) in operations {
            if op == 0 {
                idempotenceSet.add(timeStamp: time, value: "a")
            }else{
                idempotenceSet.remove(timeStamp: time, value: "a")
            }
        }
        let random = Int(arc4random())%(operations.count-1)
        let randomRepeatOp = operations[random]
        if randomRepeatOp.0 == 0 {
            idempotenceSet.add(timeStamp: randomRepeatOp.1, value: "a")
        }else {
            idempotenceSet.remove(timeStamp: randomRepeatOp.1, value: "a")
        }
        XCTAssertEqual(idempotenceSet.addSet["a"], elementSet.addSet["a"])
        XCTAssertEqual(idempotenceSet.removeSet["a"], elementSet.removeSet["a"])
    }
}
