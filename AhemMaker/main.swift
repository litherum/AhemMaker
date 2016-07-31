//
//  main.swift
//  AhemMaker
//
//  Created by Litherum on 7/31/16.
//  Copyright © 2016 Litherum. All rights reserved.
//

import Foundation

struct Point {
    let x: Int16
    let y: Int16
    let onCurve = true
}

typealias Contour = [Point]

typealias Path = [Contour]

let emptySquare: Path = [[Point(x: 125, y: 0), Point(x: 125, y: 800), Point(x: 875, y: 800), Point(x: 875, y: 0)], [Point(x: 250, y: 125), Point(x: 750, y: 125), Point(x: 750, y: 675), Point(x: 250, y: 675)]]
let fullSquare: Path = [[Point(x: 0, y: 800), Point(x: 1000, y: 800), Point(x: 1000, y: -200), Point(x: 0, y: -200)]]
let ascenderSquare: Path = [[Point(x: 0, y: 800), Point(x: 1000, y: 800), Point(x: 1000, y: 0), Point(x: 0, y: 0)]]
let descenderSquare: Path = [[Point(x: 0, y: 0), Point(x: 1000, y: 0), Point(x: 1000, y: -200), Point(x: 0, y: -200)]]
let emptyPath: Path = [[]]

struct Glyph {
    // glyph name
    let advanceWidth: UInt16
    let leftSideBearing: Int16
    let path: Path
}

let commonGlyph = Glyph(advanceWidth: 1000, leftSideBearing: 0, path: fullSquare)

var glyphs = [Glyph(advanceWidth: 1000, leftSideBearing: 125, path: emptySquare),
    Glyph(advanceWidth: 0, leftSideBearing: 0, path: fullSquare)]
for _ in 2 ... 81 {
    glyphs.append(Glyph(advanceWidth: 1000, leftSideBearing: 0, path: fullSquare))
}
glyphs.append(Glyph(advanceWidth: 1000, leftSideBearing: 0, path: descenderSquare))
for _ in 83 ... 99 {
    glyphs.append(Glyph(advanceWidth: 1000, leftSideBearing: 0, path: fullSquare))
}
glyphs.append(Glyph(advanceWidth: 1000, leftSideBearing: 0, path: ascenderSquare))
for _ in 101 ... 244 {
    glyphs.append(Glyph(advanceWidth: 1000, leftSideBearing: 0, path: fullSquare))
}
glyphs.append(Glyph(advanceWidth: 0, leftSideBearing: 0, path: emptyPath))
glyphs.append(Glyph(advanceWidth: 500, leftSideBearing: 0, path: emptyPath))
glyphs.append(Glyph(advanceWidth: 1000, leftSideBearing: 0, path: emptyPath))
glyphs.append(Glyph(advanceWidth: 333, leftSideBearing: 0, path: emptyPath))
glyphs.append(Glyph(advanceWidth: 250, leftSideBearing: 0, path: emptyPath))
glyphs.append(Glyph(advanceWidth: 167, leftSideBearing: 0, path: emptyPath))
glyphs.append(Glyph(advanceWidth: 200, leftSideBearing: 0, path: emptyPath))
glyphs.append(Glyph(advanceWidth: 100, leftSideBearing: 0, path: emptyPath))
glyphs.append(Glyph(advanceWidth: 0, leftSideBearing: 0, path: emptyPath))
glyphs.append(Glyph(advanceWidth: 1000, leftSideBearing: 0, path: emptyPath))
glyphs.append(Glyph(advanceWidth: 0, leftSideBearing: 0, path: emptyPath))
glyphs.append(Glyph(advanceWidth: 0, leftSideBearing: 0, path: emptyPath))

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
    append(result, value: UInt16(3)) // Version
    append(result, value: Int16(982)) // Average character width
    append(result, value: UInt16(400)) // Weight
    append(result, value: UInt16(5)) // Width
    append(result, value: Int16(0)) // fsType
    append(result, value: Int16(700)) // Subscript horizontal size
    append(result, value: Int16(650)) // Subscript vertical size
    append(result, value: Int16(0)) // Subscript horizontal offset
    append(result, value: Int16(143)) // Subscript vertical offset
    append(result, value: Int16(700)) // Superscript horizontal size
    append(result, value: Int16(650)) // Superscript vertical size
    append(result, value: Int16(0)) // Superscript horizontal offset
    append(result, value: Int16(453)) // Superscrpt vertical offset
    append(result, value: Int16(50)) // Strikeout stroke width
    append(result, value: Int16(259)) // Strikeout stroke position
    append(result, value: Int16(0)) // Family class

    // Panose
    append(result, value: UInt8(2))
    append(result, value: UInt8(0))
    append(result, value: UInt8(4))
    append(result, value: UInt8(0))
    append(result, value: UInt8(0))
    append(result, value: UInt8(0))
    append(result, value: UInt8(0))
    append(result, value: UInt8(0))
    append(result, value: UInt8(0))
    append(result, value: UInt8(0))

    append(result, value: UInt32(2147483823)) // FIXME: Update these
    append(result, value: UInt32(268443720))
    append(result, value: UInt32(0))
    append(result, value: UInt32(0))

    let fourCharacterTag = FourCharacterTag(string: "W3C ")
    append(result, value: fourCharacterTag.a)
    append(result, value: fourCharacterTag.b)
    append(result, value: fourCharacterTag.c)
    append(result, value: fourCharacterTag.d)

    append(result, value: UInt16(0x40)) // Regular style
    append(result, value: UInt16(0x20)) // FIXME: Update this
    append(result, value: UInt16(0xfeff)) // FIXME: Update this
    append(result, value: Int16(800)) // Typographic ascender
    append(result, value: Int16(-200)) // Typographic descender
    append(result, value: Int16(0)) // Typographic line gap
    append(result, value: UInt16(800)) // Windows ascent
    append(result, value: UInt16(200)) // Windows descent
    append(result, value: UInt32(1)) // FIXME: Update this
    append(result, value: UInt32(0)) // FIXME: Update this
    append(result, value: Int16(800)) // x height
    append(result, value: Int16(800)) // Capital letter height
    append(result, value: UInt16(0)) // Default character
    append(result, value: UInt16(32)) // Break character
    append(result, value: UInt16(0)) // Maximum context necessary
    return result
}

func gaspTable() -> NSData {
    let result = NSMutableData()
    append(result, value: UInt16(0)) // Version
    append(result, value: UInt16(3)) // Number of records below

    append(result, value: UInt16(8)) // Upper size limit
    append(result, value: UInt16(2)) // Greyscale

    append(result, value: UInt16(16)) // Upper size limit
    append(result, value: UInt16(1)) // Gridfit

    append(result, value: UInt16(0xFFFF)) // Upper size limit
    append(result, value: UInt16(3)) // Gridfit and greyscale
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

let tables = [os2Table(), gaspTable()]
let tableCodes = [FourCharacterTag(string: "OS/2"), FourCharacterTag(string: "gasp")]
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

