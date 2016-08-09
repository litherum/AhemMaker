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
let horizontalStripe: Path = [[Point(x: 0, y: 600), Point(x: 1000, y: 600), Point(x: 1000, y: 400), Point(x: 0, y: 400)]]
let verticalStripe: Path = [[Point(x: 200, y: 800), Point(x: 400, y: 800), Point(x: 400, y: -200), Point(x: 200, y: -200)]]
let emptyPath: Path = []

struct Glyph {
    // glyph name
    let advanceWidth: UInt16
    let leftSideBearing: Int16
    let path: Path
    var name: String = ""
}

let commonGlyph = Glyph(advanceWidth: 1000, leftSideBearing: 0, path: fullSquare, name: "")

var glyphs = [Glyph(advanceWidth: 1000, leftSideBearing: 125, path: emptySquare, name: ""),
    Glyph(advanceWidth: 0, leftSideBearing: 0, path: emptyPath, name: ""),
    Glyph(advanceWidth: 1000, leftSideBearing: 0, path: emptyPath, name: ""),
    Glyph(advanceWidth: 1000, leftSideBearing: 0, path: emptyPath, name: "")]
for _ in 4 ... 81 {
    glyphs.append(commonGlyph)
}
glyphs.append(Glyph(advanceWidth: 1000, leftSideBearing: 0, path: descenderSquare, name: ""))
for _ in 83 ... 99 {
    glyphs.append(commonGlyph)
}
glyphs.append(Glyph(advanceWidth: 1000, leftSideBearing: 0, path: ascenderSquare, name: ""))
for _ in 101 ... 152 {
    glyphs.append(commonGlyph)
}
glyphs.append(Glyph(advanceWidth: 1000, leftSideBearing: 0, path: emptyPath, name: ""))
for _ in 154 ... 244 {
    glyphs.append(commonGlyph)
}
glyphs.append(Glyph(advanceWidth: 0, leftSideBearing: 0, path: emptyPath, name: ""))
glyphs.append(Glyph(advanceWidth: 500, leftSideBearing: 0, path: emptyPath, name: ""))
glyphs.append(Glyph(advanceWidth: 1000, leftSideBearing: 0, path: emptyPath, name: ""))
glyphs.append(Glyph(advanceWidth: 333, leftSideBearing: 0, path: emptyPath, name: ""))
glyphs.append(Glyph(advanceWidth: 250, leftSideBearing: 0, path: emptyPath, name: ""))
glyphs.append(Glyph(advanceWidth: 167, leftSideBearing: 0, path: emptyPath, name: ""))
glyphs.append(Glyph(advanceWidth: 200, leftSideBearing: 0, path: emptyPath, name: ""))
glyphs.append(Glyph(advanceWidth: 100, leftSideBearing: 0, path: emptyPath, name: ""))
glyphs.append(Glyph(advanceWidth: 0, leftSideBearing: 0, path: emptyPath, name: ""))
glyphs.append(Glyph(advanceWidth: 1000, leftSideBearing: 0, path: emptyPath, name: ""))
glyphs.append(Glyph(advanceWidth: 0, leftSideBearing: 0, path: emptyPath, name: ""))
glyphs.append(Glyph(advanceWidth: 0, leftSideBearing: 0, path: emptyPath, name: ""))
for _ in 257 ... 273 {
    glyphs.append(commonGlyph)
}
glyphs.append(Glyph(advanceWidth: 1000, leftSideBearing: 0, path: horizontalStripe, name: ""))
glyphs.append(Glyph(advanceWidth: 1000, leftSideBearing: 0, path: horizontalStripe, name: ""))
glyphs.append(Glyph(advanceWidth: 1000, leftSideBearing: 200, path: verticalStripe, name: ""))
glyphs.append(Glyph(advanceWidth: 1000, leftSideBearing: 200, path: verticalStripe, name: ""))

assert(glyphs.count == glyphNames.count)
for i in 0 ..< glyphs.count {
    glyphs[i].name = glyphNames[i]
}

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

func overwrite(data: NSMutableData, location: Int, value: UInt16) {
    let a = UInt8(value >> 8)
    let b = UInt8(value & 0xFF)
    let bytes = UnsafeMutablePointer<UInt8>(data.mutableBytes)
    bytes[location] = a
    bytes[location + 1] = b
}

struct BinarySearchData {
    let searchRange: UInt16
    let entrySelector: UInt16
    let rangeShift: UInt16
}

func calculateBinarySearchData(value: Int, size: Int) -> BinarySearchData {
    var pot = 1
    var log = 0
    while pot <= value {
        log = log + 1
        pot = pot * 2
    }
    log = log - 1
    pot = pot / 2
    let searchRange = UInt16(pot * size)
    return BinarySearchData(searchRange: searchRange, entrySelector: UInt16(log), rangeShift: UInt16(value * size) - searchRange)
}

func os2Table() -> NSData {
    let result = NSMutableData()

    var firstChar = UInt16.max
    var lastChar = UInt16.min
    for charCode in characterMap.keys {
        firstChar = min(firstChar, UInt16(charCode))
        lastChar = max(lastChar, UInt16(charCode))
    }

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

    append(result, value: UInt32(2147483823)) // Supported unicode ranges
    append(result, value: UInt32(268443720))
    append(result, value: UInt32(0))
    append(result, value: UInt32(0))

    let fourCharacterTag = FourCharacterTag(string: "W3C ")
    append(result, value: fourCharacterTag.a)
    append(result, value: fourCharacterTag.b)
    append(result, value: fourCharacterTag.c)
    append(result, value: fourCharacterTag.d)

    append(result, value: UInt16(0x40)) // Regular style
    append(result, value: UInt16(firstChar))
    append(result, value: UInt16(lastChar))
    append(result, value: Int16(800)) // Typographic ascender
    append(result, value: Int16(-200)) // Typographic descender
    append(result, value: Int16(0)) // Typographic line gap
    append(result, value: UInt16(800)) // Windows ascent
    append(result, value: UInt16(200)) // Windows descent
    append(result, value: UInt32(0xFF10FC07)) // Bitmask for supported codepages (Part 1). Report all pages as supported.
    append(result, value: UInt32(0x0000FFFF)) // Bitmask for supported codepages (Part 2). Report all pages as supported.
    append(result, value: Int16(800)) // x height
    append(result, value: Int16(800)) // Capital letter height
    append(result, value: UInt16(0)) // Default character
    append(result, value: UInt16(32)) // Break character
    append(result, value: UInt16(0)) // Maximum context necessary
    return result
}

struct Segment {
    let startCode: UInt32
    let endCode: UInt32
    let idDelta: UInt16
    let idRangeOffset: UInt16
}

func generateSegments() -> [Segment] {
    assert(characterMap.count == glyphs.count)
    var result = [Segment]()
    var minCodePoint: Int?
    var minGlyph: Int?
    for codePoint in 1 ..< 0xFFFF {
        if let glyph = characterMap[codePoint] {
            if minCodePoint == nil {
                minCodePoint = codePoint
                minGlyph = glyph
            } else {
                let delta = minGlyph! - minCodePoint!
                let probe = delta + codePoint
                if probe != glyph {
                    result.append(Segment(startCode: UInt32(minCodePoint!), endCode: UInt32(codePoint) - 1, idDelta: cast16BitInt(Int16(delta)), idRangeOffset: 0))
                    minCodePoint = codePoint
                    minGlyph = glyph
                }
            }
        } else if minCodePoint != nil {
            let delta = UInt16(minGlyph!) &- UInt16(minCodePoint!)
            result.append(Segment(startCode: UInt32(minCodePoint!), endCode: UInt32(codePoint) - 1, idDelta: delta, idRangeOffset: 0))
            minCodePoint = nil
            minGlyph = nil
        }
    }

    // FIXME: handle the last few code points correctly
    assert(minCodePoint == nil)
    result.append(Segment(startCode: 0xFFFF, endCode: 0xFFFF, idDelta: 1, idRangeOffset: 0))
    return result
}

func cmapTable() -> NSData {
    let result = NSMutableData()

    let segments = generateSegments()
    let binarySearchData = calculateBinarySearchData(segments.count, size: 2)
    let subtableLocation = 20
    let subtableLength = 16 + 4 * 2 * segments.count

    append(result, value: UInt16(0)) // Version
    append(result, value: UInt16(2)) // Number of subtables

    append(result, value: UInt16(0)) // Unicode
    append(result, value: UInt16(3)) // Version 2.0 or later semantics (BMP only)
    append(result, value: UInt32(subtableLocation)) // Offset

    append(result, value: UInt16(3)) // Windows
    append(result, value: UInt16(1)) // Unicode BMP-only (UCS-2)
    append(result, value: UInt32(subtableLocation)) // Offset

    assert(result.length == subtableLocation)

    append(result, value: UInt16(4)) // Format
    append(result, value: UInt16(subtableLength)) // Length in bytes of the subtable
    append(result, value: UInt16(0)) // Language (Unused)
    append(result, value: UInt16(segments.count * 2))
    append(result, value: UInt16(binarySearchData.searchRange))
    append(result, value: UInt16(binarySearchData.entrySelector))
    append(result, value: UInt16(binarySearchData.rangeShift))
    for segment in segments {
        append(result, value: UInt16(segment.endCode))
    }
    append(result, value: UInt16(0))
    for segment in segments {
        append(result, value: UInt16(segment.startCode))
    }
    for segment in segments {
        append(result, value: UInt16(segment.idDelta))
    }
    for segment in segments {
        assert(segment.idRangeOffset == 0)
        append(result, value: UInt16(segment.idRangeOffset))
    }

    assert(result.length - subtableLocation == subtableLength)
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

func glyfTable() -> NSData {
    let result = NSMutableData()
    for specificGlyphData in glyphData {
        result.appendData(specificGlyphData)
        if result.length % 2 == 1 {
            append(result, value: UInt8(0))
        }
    }
    return result
}

func headTable() -> NSData {
    let result = NSMutableData()

    var xMin = Int16.max
    var xMax = Int16.min
    var yMin = Int16.max
    var yMax = Int16.min
    for glyph in glyphs {
        for contour in glyph.path {
            for point in contour {
                xMin = min(xMin, point.x)
                xMax = max(xMax, point.x)
                yMin = min(yMin, point.y)
                yMax = max(yMax, point.y)
            }
        }
    }

    append(result, value: UInt32(0x10000)) // Version
    append(result, value: UInt32(0x18000)) // Font revision
    append(result, value: UInt32(0)) // Checksum placeholder for entire file
    append(result, value: UInt8(0x5F)) // Magic number
    append(result, value: UInt8(0x0F)) // Magic number
    append(result, value: UInt8(0x3C)) // Magic number
    append(result, value: UInt8(0xF5)) // Magic number
    append(result, value: UInt16(0x9)) // y=0 is baseline, and use integer scaling
    append(result, value: UInt16(1000)) // Units per em
    append(result, value: UInt32(0)) // Created datetime 1
    append(result, value: UInt32(3010420569)) // Created datetime 2
    append(result, value: UInt32(0)) // Modified datetime 1
    append(result, value: UInt32(3302861604)) // Modified datetime 2
    append(result, value: Int16(xMin))
    append(result, value: Int16(yMin))
    append(result, value: Int16(xMax))
    append(result, value: Int16(yMax))
    append(result, value: UInt16(0)) // Style: normal
    append(result, value: UInt16(3)) // Smallest readable size
    append(result, value: Int16(0)) // Mixed directional glyphs
    append(result, value: Int16(0)) // 2-byte offsets in loca table
    append(result, value: Int16(0))
    return result
}

func hheaTable() -> NSData {
    let result = NSMutableData()

    var advanceWidthMax = UInt16.min
    var minLeftSideBearing = Int16.max
    var xMaxExtent = Int16.min
    for glyph in glyphs {
        advanceWidthMax = max(advanceWidthMax, glyph.advanceWidth)
        minLeftSideBearing = min(minLeftSideBearing, glyph.leftSideBearing)
        var xMin = Int16.max
        var xMax = Int16.min
        if glyph.path.isEmpty {
            xMin = 0
            xMax = 0
        } else {
            for contour in glyph.path {
                for point in contour {
                    xMin = min(xMin, point.x)
                    xMax = max(xMax, point.x)
                }
            }
        }
        xMaxExtent = max(xMaxExtent, glyph.leftSideBearing + (xMax - xMin))
    }

    append(result, value: UInt32(0x10000)) // Version
    append(result, value: Int16(800)) // Ascent
    append(result, value: Int16(-200)) // Descent
    append(result, value: Int16(0)) // Line Gap
    append(result, value: UInt16(advanceWidthMax))
    append(result, value: Int16(minLeftSideBearing))
    append(result, value: Int16(0)) // Minimum right side bearing
    append(result, value: Int16(xMaxExtent))
    append(result, value: Int16(1)) // Caret slope rise
    append(result, value: Int16(0)) // Caret slope run
    append(result, value: Int16(0)) // Caret offset
    append(result, value: UInt32(0)) // Reserved
    append(result, value: UInt32(0)) // Reserved
    append(result, value: Int16(0))
    append(result, value: UInt16(glyphs.count))
    return result
}

func hmtxTable() -> NSData {
    let result = NSMutableData()
    for glyph in glyphs {
        append(result, value: UInt16(glyph.advanceWidth))
        append(result, value: Int16(glyph.leftSideBearing))
    }
    return result
}

func locaTable() -> NSData {
    let result = NSMutableData()
    var offsets = [Int]()
    var offset = 0
    for individualGlyphData in glyphData {
        offsets.append(offset)
        offset = offset + individualGlyphData.length
        if offset % 2 == 1 {
            offset = offset + 1
        }
    }
    offsets.append(offset)
    assert(offset / 2 <= 0xFFFF)
    for offset in offsets {
        append(result, value: UInt16(offset) / 2)
    }
    return result
}

func maxpTable() -> NSData {
    let result = NSMutableData()

    var maxPoints = 0
    var maxContours = 0
    for glyph in glyphs {
        var currentPoints = 0
        for contour in glyph.path {
            currentPoints = currentPoints + contour.count
        }
        maxPoints = max(maxPoints, currentPoints)
        maxContours = max(maxContours, glyph.path.count)
    }

    append(result, value: UInt32(0x10000)) // Version
    append(result, value: UInt16(glyphs.count))
    append(result, value: UInt16(maxPoints))
    append(result, value: UInt16(maxContours))
    append(result, value: UInt16(0)) // Maximum points in compound glyph
    append(result, value: UInt16(0)) // Maximum contours in compound glyph
    append(result, value: UInt16(1)) // Maximum zones
    append(result, value: UInt16(0)) // Points used in twilight zone
    append(result, value: UInt16(0)) // Number of storage area locations
    append(result, value: UInt16(0)) // Number of function definitions
    append(result, value: UInt16(0)) // Number of instruction definitions
    append(result, value: UInt16(0)) // Maximum stack depth
    append(result, value: UInt16(0)) // Maximum size of instructions
    append(result, value: UInt16(0)) // Maximum component elements
    append(result, value: UInt16(0)) // Maximum component depth
    return result
}

func nameTable() -> NSData {
    let result = NSMutableData()

    let copyright = "The Ahem font belongs to the public domain. In jurisdictions that do not recognize public domain ownership of these files, the following Creative Commons Zero declaration applies: http://labs.creativecommons.org/licenses/zero-waive/1.0/us/legalcode"
    let family = "Ahem"
    let subfamily = "Regular"
    let uniqueSubfamily = "Version 1.50 Ahem"
    let fullName = "Ahem"
    let nameTableVersion = "Version 1.50"
    let postScriptName = "Ahem"
    let description = "The Ahem font was developed by Todd Fahrner to help test writers  develop predictable tests. The font's em square is exactly square. Its ascent and descent is exactly the size of the em square. This means that the font's extent is exactly the same as its line-height, meaning that it can be exactly aligned with padding, borders, margins, and so forth. Most characters are the solid em square, except \"É\" and \"p\", which show ascent/descent from the baseline."
    let vendorURL = "http://www.w3c.org"
    let licenseURL = "http://dev.w3.org/CSS/fonts/ahem/COPYING\n"
    let preferredFamily = "Ahem"
    let preferredSubfamily = "Regular"
    let compatibleFullName = "Ahem"

    let unicode = UInt16(0)
    let macintosh = UInt16(1)
    let windows = UInt16(3)

    let defaultSemantics = UInt16(0)
    let roman = UInt16(0)
    let unicodeBMP = UInt16(1)

    let english = UInt16(0)
    let enUS = UInt16(0x0409)

    let copyrightID = UInt16(0)
    let familyID = UInt16(1)
    let subfamilyID = UInt16(2)
    let uniqueSubfamilyID = UInt16(3)
    let fullNameID = UInt16(4)
    let nameTableVersionID = UInt16(5)
    let postScriptNameID = UInt16(6)
    let descriptionID = UInt16(10)
    let vendorURLID = UInt16(11)
    let licenseURLID = UInt16(14)
    let preferredFamilyID = UInt16(16)
    let preferredSubfamilyID = UInt16(17)
    let compatibleFullNameID = UInt16(18)

    let numberOfRecords = 36
    let offsetToStringData = 6 + 12 * numberOfRecords

    append(result, value: UInt16(0)) // Format
    append(result, value: UInt16(numberOfRecords))
    append(result, value: UInt16(offsetToStringData))

    let headerLocation = result.length
    for _ in 0 ..< numberOfRecords {
        append(result, value: UInt16(0))
        append(result, value: UInt16(0))
        append(result, value: UInt16(0))
        append(result, value: UInt16(0))
        append(result, value: UInt16(0))
        append(result, value: UInt16(0))
    }

    assert(result.length == offsetToStringData)

    var currentRecord = 0

    let appendString = { (platformID: UInt16, platformSpecificID: UInt16, languageID: UInt16, nameID: UInt16, string: String) in
        overwrite(result, location: headerLocation + currentRecord * 12 , value: platformID)
        overwrite(result, location: headerLocation + currentRecord * 12 + 2, value: platformSpecificID)
        overwrite(result, location: headerLocation + currentRecord * 12 + 4, value: languageID)
        overwrite(result, location: headerLocation + currentRecord * 12 + 6, value: nameID)

        var stringEncoding = NSUTF16BigEndianStringEncoding
        if platformID == unicode && platformSpecificID == defaultSemantics && languageID == 0 {
            stringEncoding = NSUTF16BigEndianStringEncoding
        } else if platformID == macintosh && platformSpecificID == roman && languageID == english {
            stringEncoding = NSMacOSRomanStringEncoding
        } else if platformID == windows && platformSpecificID == unicodeBMP && languageID == enUS {
            stringEncoding = NSUTF16BigEndianStringEncoding
        } else {
            fatalError()
        }
        let length = string.lengthOfBytesUsingEncoding(stringEncoding)
        var bytes = [UInt8](count: length, repeatedValue: 0)
        string.getBytes(&bytes, maxLength: length, usedLength: nil, encoding: stringEncoding, options: NSStringEncodingConversionOptions(), range: (string.characters.startIndex ..< string.characters.endIndex), remainingRange: nil)

        overwrite(result, location: headerLocation + currentRecord * 12 + 8, value: UInt16(length))
        overwrite(result, location: headerLocation + currentRecord * 12 + 10, value: UInt16(result.length - offsetToStringData))

        result.appendBytes(bytes, length: bytes.count)

        currentRecord = currentRecord + 1
    }

    appendString(unicode, defaultSemantics, 0, copyrightID, copyright)
    appendString(unicode, defaultSemantics, 0, familyID, family)
    appendString(unicode, defaultSemantics, 0, subfamilyID, subfamily)
    appendString(unicode, defaultSemantics, 0, uniqueSubfamilyID, uniqueSubfamily)
    appendString(unicode, defaultSemantics, 0, fullNameID, fullName)
    appendString(unicode, defaultSemantics, 0, nameTableVersionID, nameTableVersion)
    appendString(unicode, defaultSemantics, 0, postScriptNameID, postScriptName)
    appendString(unicode, defaultSemantics, 0, descriptionID, description)
    appendString(unicode, defaultSemantics, 0, vendorURLID, vendorURL)
    appendString(unicode, defaultSemantics, 0, licenseURLID, licenseURL)
    appendString(macintosh, roman, english, copyrightID, copyright)
    appendString(macintosh, roman, english, familyID, family)
    appendString(macintosh, roman, english, subfamilyID, subfamily)
    appendString(macintosh, roman, english, uniqueSubfamilyID, uniqueSubfamily)
    appendString(macintosh, roman, english, fullNameID, fullName)
    appendString(macintosh, roman, english, nameTableVersionID, nameTableVersion)
    appendString(macintosh, roman, english, postScriptNameID, postScriptName)
    appendString(macintosh, roman, english, descriptionID, description)
    appendString(macintosh, roman, english, vendorURLID, vendorURL)
    appendString(macintosh, roman, english, licenseURLID, licenseURL)
    appendString(macintosh, roman, english, preferredFamilyID, preferredFamily)
    appendString(macintosh, roman, english, preferredSubfamilyID, preferredSubfamily)
    appendString(macintosh, roman, english, compatibleFullNameID, compatibleFullName)
    appendString(windows, unicodeBMP, enUS, copyrightID, copyright)
    appendString(windows, unicodeBMP, enUS, familyID, family)
    appendString(windows, unicodeBMP, enUS, subfamilyID, subfamily)
    appendString(windows, unicodeBMP, enUS, uniqueSubfamilyID, uniqueSubfamily)
    appendString(windows, unicodeBMP, enUS, fullNameID, fullName)
    appendString(windows, unicodeBMP, enUS, nameTableVersionID, nameTableVersion)
    appendString(windows, unicodeBMP, enUS, postScriptNameID, postScriptName)
    appendString(windows, unicodeBMP, enUS, descriptionID, description)
    appendString(windows, unicodeBMP, enUS, vendorURLID, vendorURL)
    appendString(windows, unicodeBMP, enUS, licenseURLID, licenseURL)
    appendString(windows, unicodeBMP, enUS, preferredFamilyID, preferredFamily)
    appendString(windows, unicodeBMP, enUS, preferredSubfamilyID, preferredSubfamily)
    appendString(windows, unicodeBMP, enUS, compatibleFullNameID, compatibleFullName)

    assert(currentRecord == numberOfRecords)

    return result
}

func postTable() -> NSData {
    let result = NSMutableData()
    append(result, value: UInt32(0x20000)) // Format
    append(result, value: UInt32(0)) // Italic angle
    append(result, value: Int16(-133)) // Underline position
    append(result, value: Int16(20)) // Underline thickness
    append(result, value: UInt32(0)) // Not fixed-pitch
    append(result, value: UInt32(0)) // Minimum memory needed in a type 42 representation
    append(result, value: UInt32(0)) // Maximum memory needed in a type 42 representation
    append(result, value: UInt32(0)) // Minimum memory needed in a type 1 representation
    append(result, value: UInt32(0)) // Maximum memory needed in a type 1 representation
    append(result, value: UInt16(glyphs.count))

    var newGlyphNamesArray = [String]()
    var newGlyphNames = [String : Int]()
    for glyph in glyphs {
        if let glyphNameID = glyphMap[glyph.name] {
            append(result, value: UInt16(glyphNameID))
        } else if let newGlyphNameID = newGlyphNames[glyph.name] {
            append(result, value: UInt16(newGlyphNameID))
        } else {
            let newID = newGlyphNamesArray.count
            newGlyphNamesArray.append(glyph.name)
            newGlyphNames[glyph.name] = newID + 258
            append(result, value: UInt16(newID + 258))
        }
    }

    for name in newGlyphNamesArray {
        append(result, value: UInt8(name.utf8.count))
        for codeUnit in name.utf8 {
            append(result, value: UInt8(codeUnit))
        }
    }

    return result
}

func generateGlyphData() -> [NSData] {
    var result = [NSData]()
    for glyph in glyphs {
        let r = NSMutableData()

        if glyph.path.count == 0 || (glyph.path.count == 1 && glyph.path[0].count == 0) {
            result.append(r)
            continue
        }

        var xMin = Int16.max
        var yMin = Int16.max
        var xMax = Int16.min
        var yMax = Int16.min
        var endPtsOfContours = [UInt16]()
        var currentPointCount = 0
        if glyph.path.isEmpty {
            xMin = 0
            yMin = 0
            xMax = 0
            yMax = 0
        } else {
            for contour in glyph.path {
                currentPointCount = currentPointCount + contour.count
                endPtsOfContours.append(UInt16(currentPointCount - 1))
                for point in contour {
                    xMin = min(xMin, point.x)
                    yMin = min(yMin, point.y)
                    xMax = max(xMax, point.x)
                    yMax = max(yMax, point.y)
                }
            }
        }

        append(r, value: Int16(glyph.path.count))
        append(r, value: Int16(xMin))
        append(r, value: Int16(yMin))
        append(r, value: Int16(xMax))
        append(r, value: Int16(yMax))

        for endPoint in endPtsOfContours {
            append(r, value: UInt16(endPoint))
        }
        append(r, value: UInt16(0)) // length of instructions

        var flags = [UInt8]()
        let xCoordinates = NSMutableData()
        let yCoordinates = NSMutableData()

        let onCurve = UInt8(1)
        let xShort = UInt8(2)
        let yShort = UInt8(4)
        let repeatCount = UInt8(8)
        let xIsSame = UInt8(16)
        let yIsSame = UInt8(32)

        var previousX = Int16(0)
        var previousY = Int16(0)
        for contour in glyph.path {
            for point in contour {
                var flag = UInt8(0)
                if point.onCurve {
                    flag = flag | onCurve
                }
                if point.x == previousX {
                    flag = flag | xIsSame
                } else {
                    let delta = point.x - previousX
                    if abs(delta) < 256 {
                        flag = flag | xShort
                        append(xCoordinates, value: UInt8(abs(delta)))
                        if delta >= 0 {
                            flag = flag | xIsSame
                        }
                    } else {
                        append(xCoordinates, value: Int16(point.x - previousX))
                    }
                }
                if point.y == previousY {
                    flag = flag | yIsSame
                } else {
                    let delta = point.y - previousY
                    if abs(delta) < 256 {
                        flag = flag | yShort
                        append(yCoordinates, value: UInt8(abs(delta)))
                        if delta >= 0 {
                            flag = flag | yIsSame
                        }
                    } else {
                        append(yCoordinates, value: Int16(point.y - previousY))
                    }
                }
                flags.append(flag)
                previousX = point.x
                previousY = point.y
            }
        }

        let flagData = NSMutableData()
        var flagIndex = 0
        while flagIndex < flags.count {
            var flag = flags[flagIndex]
            var run = flagIndex + 1
            while run < flags.count && flags[run] == flag {
                run = run + 1
            }
            if run > flagIndex + 1 {
                flag = flag | repeatCount
                append(flagData, value: UInt8(flag))
                append(flagData, value: UInt8(flagIndex - 1))
            } else {
                append(flagData, value: UInt8(flag))
            }
            flagIndex = run
        }

        r.appendData(flagData)
        r.appendData(xCoordinates)
        r.appendData(yCoordinates)

        assert(flagData.length > 0)
        assert(xCoordinates.length > 0)
        assert(yCoordinates.length > 0)

        result.append(r)
    }
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

func ==(left: FourCharacterTag, right: FourCharacterTag) -> Bool {
    return left.a == right.a && left.b == right.b && left.c == right.c && left.d == right.d
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

let glyphData = generateGlyphData()

let tables = [os2Table(), cmapTable(), gaspTable(), glyfTable(), headTable(), hheaTable(), hmtxTable(), locaTable(), maxpTable(), nameTable(), postTable()]
let tableCodes = [FourCharacterTag(string: "OS/2"), FourCharacterTag(string: "cmap"), FourCharacterTag(string: "gasp"), FourCharacterTag(string: "glyf"), FourCharacterTag(string: "head"), FourCharacterTag(string: "hhea"), FourCharacterTag(string: "hmtx"), FourCharacterTag(string: "loca"), FourCharacterTag(string: "maxp"), FourCharacterTag(string: "name"), FourCharacterTag(string: "post")]
assert(tables.count == tableCodes.count)

let result = NSMutableData()
append(result, value: UInt32(1 << 16))
append(result, value: UInt16(tables.count))
let binarySearchData = calculateBinarySearchData(tables.count, size: 16)
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

var headTableLocation = -1
for i in 0 ..< tables.count {
    if tableCodes[i] == FourCharacterTag(string: "head") {
        headTableLocation = result.length
    }
    appendTable(result, table: tables[i], headerLocation: headerLocation + 4 * 4 * i, tag: tableCodes[i])
}

assert(headTableLocation != -1)
overwrite(result, location: headTableLocation + 8, value: 0xB1B0AFBA &- calculateChecksum(result, location: 0, endLocation: result.length))

do {
    try result.writeToFile("/Users/litherum/tmp/output.ttf", options: .DataWritingAtomic)
} catch {
    fatalError()
}

