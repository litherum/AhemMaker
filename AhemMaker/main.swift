//
//  main.swift
//  AhemMaker
//
//  Created by Litherum on 7/31/16.
//  Copyright © 2016 Litherum. All rights reserved.
//

import Foundation

func append(data: NSMutableData, value: UInt8) {
    let a = [value]
    data.appendBytes(a, length: a.count)
}

func append(data: NSMutableData, value: Int8) {
    append(data, value: cast8BitInt(value))
}

func append(data: NSMutableData, value: UInt16) {
    let a = UInt8(value >> 8)
    let b = UInt8(value & 0xFF)
    append(data, value: a)
    append(data, value: b)
}

func append(data: NSMutableData, value: Int16) {
    append(data, value: cast16BitInt(value))
}

func append(data: NSMutableData, value: UInt32) {
    let a = UInt8(value >> 24)
    let b = UInt8((value >> 16) & 0xFF)
    let c = UInt8((value >> 8) & 0xFF)
    let d = UInt8(value & 0xFF)
    append(data, value: a)
    append(data, value: b)
    append(data, value: c)
    append(data, value: d)
}

func append(data: NSMutableData, value: Int32) {
    append(data, value: cast32BitInt(value))
}

func overwrite(data: NSMutableData, location: Int, value: UInt32) {
    let a = UInt8(value >> 24)
    let b = UInt8((value >> 16) & 0xFF)
    let c = UInt8((value >> 8) & 0xFF)
    let d = UInt8(value & 0xFF)
    let bytes = UnsafeMutablePointer<UInt8>(data.mutableBytes)
    bytes[location] = a
    bytes[location + 1] = b
    bytes[location + 2] = c
    bytes[location + 3] = d
}

struct BinarySearchData {
    let searchRange: UInt16
    let entrySelector: UInt16
    let rangeShift: UInt16
}

func calculateBinarySearchData(value: Int) -> BinarySearchData{
    var pot = 1
    var log = 0
    while pot <= tables.count {
        log = log + 1
        pot = pot * 2
    }
    log = log - 1
    pot = pot / 2
    let searchRange = UInt16(pot * 16)
    return BinarySearchData(searchRange: searchRange, entrySelector: UInt16(log), rangeShift: UInt16(value) * 16 - searchRange)
}

func os2Table() -> NSData {
    let result = NSMutableData()
    append(result, value: UInt8(128))
    append(result, value: Int8(-7))
    append(result, value: UInt16(128))
    append(result, value: Int16(-7))
    append(result, value: UInt32(128))
    append(result, value: Int32(-7))
    return result
}

struct FourCharacterTag {
    let a: UInt8
    let b: UInt8
    let c: UInt8
    let d: UInt8

    init(string: String) {
        assert(string.characters.count == 4)
        assert(string.utf8.count == 4)
        var i = string.utf8.startIndex
        a = string.utf8[i]
        i = i.successor()
        b = string.utf8[i]
        i = i.successor()
        c = string.utf8[i]
        i = i.successor()
        d = string.utf8[i]
    }
}

func calculateChecksum(data: NSData, location: Int, endLocation: Int) -> UInt32 {
    assert(location % 4 == 0)
    assert(endLocation % 4 == 0)
    var result = UInt32(0)
    let bytes = UnsafePointer<UInt8>(data.bytes)
    for i in (location ..< endLocation) where i % 4 == 0 {
        let value = (UInt32(bytes[i]) << 24) | (UInt32(bytes[i + 1]) << 16) | (UInt32(bytes[i + 2]) << 8) | UInt32(bytes[i + 3])
        result = result &+ value
    }
    return result
}

func appendTable(result: NSMutableData, table: NSData, headerLocation: Int, tag: FourCharacterTag) {
    let currentSize = result.length
    result.appendData(table)
    let newSize = result.length
    while result.length % 4 != 0 {
        let zero = [UInt8(0)]
        result.appendBytes(zero, length: 1)
    }
    let bytes = UnsafeMutablePointer<UInt8>(result.mutableBytes)
    bytes[headerLocation] = tag.a
    bytes[headerLocation + 1] = tag.b
    bytes[headerLocation + 2] = tag.c
    bytes[headerLocation + 3] = tag.d
    overwrite(result, location: headerLocation + 4, value: calculateChecksum(result, location: currentSize, endLocation: result.length))
    overwrite(result, location: headerLocation + 8, value: UInt32(currentSize))
    overwrite(result, location: headerLocation + 12, value: UInt32(newSize - currentSize))
}

let tables = [os2Table()]
let tableCodes = [FourCharacterTag(string: "OS/2")]
assert(tables.count == tableCodes.count)

let result = NSMutableData()
append(result, value: UInt32(1 << 16))
append(result, value: UInt16(tables.count))
let binarySearchData = calculateBinarySearchData(tables.count)
append(result, value: UInt16(binarySearchData.searchRange))
append(result, value: UInt16(binarySearchData.entrySelector))
append(result, value: UInt16(binarySearchData.rangeShift))

let headerLocation = result.length
for _ in tables {
    append(result, value: UInt32(0))
    append(result, value: UInt32(0))
    append(result, value: UInt32(0))
    append(result, value: UInt32(0))
}

for i in 0 ..< tables.count {
    appendTable(result, table: tables[i], headerLocation: headerLocation + 4 * 4 * i, tag: tableCodes[i])
}

do {
    try result.writeToFile("/Users/litherum/tmp/output.ttf", options: .DataWritingAtomic)
} catch {
    fatalError()
}

