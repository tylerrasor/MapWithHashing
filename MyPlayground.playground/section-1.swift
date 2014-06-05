// Playground - noun: a place where people can play

import UIKit

//Class for testing map with classes
class Person {
    var name: String
    var number: Int
    
    init(name: String, number:Int) {
        self.name = name
        self.number = number
    }
}

/* We recently were tasked with making a Map component using an Array of Maps,
 * and a hash table.  I recreated this using two Arrays (key and value) of Arrays.
 *
 * This struct is built on generic types, so there's a little bit of trickery
 * involved in computing hashes => I switched on type, so it'll only currently
 * work for the types that are hard coded.  Likewise, testing equality is hard
 * coded by type.
 */

struct MapWithHashing<T,U> {
    let numberOfBuckets: Int?
    var keys: Array<Array<T>> = []
    var values: Array<Array<U>> = []
    var internalSize = 0
    
    init() {
        numberOfBuckets = 5
        for i in 0..numberOfBuckets! {
            keys.append([])
            values.append([])
        }
        for i in 0..numberOfBuckets! {
            for j in 0..numberOfBuckets!{
                keys[i] = []
                values[i] = []
            }
        }
    }
    
    init(numBuckets: Int) {
        numberOfBuckets = numBuckets
        for i in 0..numberOfBuckets! {
            keys.append([])
            values.append([])
        }
        for i in 0..numberOfBuckets! {
            for j in 0..numberOfBuckets!{
                keys[i] = []
                values[i] = []
            }
        }
    }
    
    func hash(input:T) -> Int {
        switch input {
        case let num as Int:
            return num
        case let str as String:
            let value = str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            return value
        case let doub as Double:
            let value = doub.hashValue
            return value
        default:
            return 0
        }
    }
    
    func mod(a:Int, b:Int) -> Int {
        var bucketIndex = a % b
        if bucketIndex < 0 {
            bucketIndex += b
        }
        return bucketIndex
    }
    
    mutating func add(key:T, value:U) {
        let index = mod(hash(key), b: numberOfBuckets!)
        keys[index].append(key)
        values[index].append(value)
        ++internalSize
    }
    
    mutating func remove(key:T) -> (T?, U?) {
        let index = mod(hash(key), b:numberOfBuckets!)
        var value: U
        --internalSize
        for i in 0..keys[index].count {
            let currentKey: T = keys[index].removeAtIndex(i)
            if equals(key, second: currentKey) {
                return (key, values[index].removeAtIndex(i))
            } else {
                keys[index].insert(currentKey, atIndex: i)
            }
        }
        
        return (nil, nil)
    }
    
    mutating func removeAny() -> (T?, U?) {
        for i in 0..keys.count {
            for j in 0..keys[i].count {
                if !keys[i].isEmpty {
                    var pair: (T?, U?) = (keys[i].removeAtIndex(j), values[i].removeAtIndex(j))
                    return pair
                }
            }
        }
        
        return (nil, nil)
    }
    
    func equals(first: T, second: T) -> Bool {
        switch first {
        case let num as Int:
            return num == second as Int
        case let str as String:
            return str == second as String
        case let doub as Double:
            return doub == second as Double
        case let person as Person:
            return person.name == (second as Person).name
        default:
            return false
        }
    }
    
    func hasKey(key: T) -> Bool {
        let index = mod(hash(key), b: numberOfBuckets!)
        for i in 0..keys[index].count{
            if equals(key, second:keys[index][i]) {
                return true
            }
        }
        return false
    }
    
    func size() -> Int {
        return internalSize
    }
}

var map = MapWithHashing<Person, String>()
var jenny = Person(name: "jenny", number: 8675309)
map.add(jenny, value: "I got your number")

if map.hasKey(jenny) {
    var whoCanITurnTo = map.remove(jenny)
    println("\(whoCanITurnTo.0!.name), \(whoCanITurnTo.1)")
}

var map2 = MapWithHashing<String, Int>()
map2.add("one", value: 1)
map2.add("two", value: 2)
map2.add("three", value: 3)
map2.hasKey("three")
map2.hasKey("one")
map2.remove("one")
map2.hasKey("one")

var removed = map2.removeAny()
map2.hasKey(removed.0!)