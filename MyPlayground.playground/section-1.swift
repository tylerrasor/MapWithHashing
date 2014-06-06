// Playground - noun: a place where people can play

import UIKit

//Class for testing map with classes
class Person: NSObject {
    var name: String?
    var number: Int
    override var hashValue: Int { return number }
    
    init(number: Int) {
        self.number = number
    }
    
    init(name: String, number:Int) {
        self.name = name
        self.number = number
    }
    
    override func isEqual(object: AnyObject!) -> Bool {
        return object.number == number
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

struct MapWithHashing<T: Hashable, U where T: Equatable> {
    let numberOfBuckets: Int
    var keys: Array<Array<T>> = []
    var values: Array<Array<U>> = []
    var internalSize = 0
    
    init() {
        numberOfBuckets = 5
        for i in 0..numberOfBuckets {
            keys.append([])
            values.append([])
        }
        for i in 0..numberOfBuckets {
            for j in 0..numberOfBuckets{
                keys[i] = []
                values[i] = []
            }
        }
    }
    
    init(numBuckets: Int) {
        numberOfBuckets = numBuckets
        for i in 0..numberOfBuckets {
            keys.append([])
            values.append([])
        }
        for i in 0..numberOfBuckets {
            for j in 0..numberOfBuckets{
                keys[i] = []
                values[i] = []
            }
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
        let index = mod(key.hashValue, b: numberOfBuckets)
        keys[index].append(key)
        values[index].append(value)
        ++internalSize
    }
    
    mutating func remove(key:T) -> (T?, U?) {
        let index = mod(key.hashValue, b:numberOfBuckets)
        var value: U
        --internalSize
        for i in 0..keys[index].count {
            let currentKey: T = keys[index].removeAtIndex(i)
            if key == currentKey {
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
    
    func hasKey(key: T) -> Bool {
        let index = mod(key.hashValue, b: numberOfBuckets)
        for i in 0..keys[index].count{
            if key == keys[index][i] {
                return true
            }
        }
        return false
    }
    
    func size() -> Int {
        return internalSize
    }
}

var jenny = Person(name: "Jenny", number: 8675309)
var map = MapWithHashing<Person, String>()
map.add(jenny, value: "I got your number")
var justNumber = Person(number: 8675309)
map.hasKey(justNumber)

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

let 😊 = { (input: String) -> () in println("\(input) makes me happy") }
😊("This")
