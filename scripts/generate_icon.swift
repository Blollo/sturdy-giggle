// Run from the repository root: swift scripts/generate_icon.swift
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers
import Foundation

func render(_ size: Int, to path: String) throws {
    let context = CGContext(data: nil, width: size, height: size, bitsPerComponent: 8,
        bytesPerRow: size * 4, space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
    context.setFillColor(CGColor(red: 0.969, green: 0.961, blue: 0.937, alpha: 1))
    context.fill(CGRect(x: 0, y: 0, width: size, height: size))
    context.translateBy(x: 0, y: CGFloat(size))
    context.scaleBy(x: CGFloat(size) / 100, y: -CGFloat(size) / 100)
    context.setFillColor(CGColor(red: 0.141, green: 0.298, blue: 0.239, alpha: 1))
    let cat = CGMutablePath()
    cat.move(to: CGPoint(x: 25, y: 45))
    cat.addLine(to: CGPoint(x: 22, y: 20))
    cat.addQuadCurve(to: CGPoint(x: 42, y: 32), control: CGPoint(x: 34, y: 23))
    cat.addQuadCurve(to: CGPoint(x: 59, y: 32), control: CGPoint(x: 50, y: 29))
    cat.addLine(to: CGPoint(x: 78, y: 20))
    cat.addLine(to: CGPoint(x: 76, y: 46))
    cat.addCurve(to: CGPoint(x: 50, y: 80), control1: CGPoint(x: 90, y: 73), control2: CGPoint(x: 67, y: 80))
    cat.addCurve(to: CGPoint(x: 25, y: 45), control1: CGPoint(x: 29, y: 80), control2: CGPoint(x: 13, y: 67))
    cat.closeSubpath()
    context.addPath(cat); context.fillPath()
    context.setFillColor(CGColor(red: 0.969, green: 0.961, blue: 0.937, alpha: 1))
    context.fillEllipse(in: CGRect(x: 33, y: 49, width: 10, height: 5))
    context.fillEllipse(in: CGRect(x: 58, y: 49, width: 10, height: 5))
    context.setFillColor(CGColor(red: 0.72, green: 0.43, blue: 0.27, alpha: 1))
    context.fillEllipse(in: CGRect(x: 46.5, y: 61, width: 7, height: 5))
    let destination = CGImageDestinationCreateWithURL(URL(fileURLWithPath: path) as CFURL, UTType.png.identifier as CFString, 1, nil)!
    CGImageDestinationAddImage(destination, context.makeImage()!, nil)
    guard CGImageDestinationFinalize(destination) else { throw NSError(domain: "CatDexIcon", code: 1) }
}
let ios = "app/ios/Runner/Assets.xcassets/AppIcon.appiconset"
let json = try JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: "\(ios)/Contents.json"))) as! [String: Any]
for image in json["images"] as! [[String: String]] {
    guard let filename = image["filename"], let points = image["size"]?.split(separator: "x").first,
          let scale = image["scale"]?.dropLast(), let pt = Double(points), let factor = Double(scale) else { continue }
    try render(Int(pt * factor), to: "\(ios)/\(filename)")
}
for (density, size) in [("mdpi",48), ("hdpi",72), ("xhdpi",96), ("xxhdpi",144), ("xxxhdpi",192)] {
    try render(size, to: "app/android/app/src/main/res/mipmap-\(density)/ic_launcher.png")
}
print("Generated Cat-dex icons for iOS and Android.")
