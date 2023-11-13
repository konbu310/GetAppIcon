import AppKit
import Commander
import Quartz

struct CLI {
  final class StandardErrorTextStream: TextOutputStream {
    func write(_ string: String) {
      FileHandle.standardError.write(string.data(using: .utf8)!)
    }
  }

  static let stdout = FileHandle.standardOutput
  static let stderr = FileHandle.standardError

  private static var _stderr = StandardErrorTextStream()
  static func printErr<T>(_ item: T) {
    Swift.print(item, to: &_stderr)
  }
}

extension NSBitmapImageRep {
  func png() -> Data? {
    return representation(using: .png, properties: [:])
  }
}

extension Data {
  var bitmap: NSBitmapImageRep? {
    return NSBitmapImageRep(data: self)
  }
}

extension NSImage {
  func png() -> Data? {
    return tiffRepresentation?.bitmap?.png()
  }

  func resized(to size: Int) -> NSImage {
    let newSize = CGSize(width: size, height: size)

    let image = NSImage(size: newSize)
    image.lockFocus()
    NSGraphicsContext.current?.imageInterpolation = .high

    draw(
      in: CGRect(origin: .zero, size: newSize),
      from: .zero,
      operation: .copy,
      fraction: 1
    )

    image.unlockFocus()
    return image
  }
}

func getIcon(appPath: String, size: Int) -> Data? {
  let workspace = NSWorkspace.shared
  if let appUrl = URL(string: appPath) {
    return workspace.icon(forFile: appUrl.path).resized(to: size).png()
  }
  return nil
}

func stringify(data: Data) -> String {
  return "data:image/png;base64,\(data.base64EncodedString())"
}

command(
  Argument<String>("appPath", description: "Path of the app"),
  Option("size", default: 32, description: "Size of the output icon"),
  Option("encoding", default: "base64", description: "Encoding of output icon")
) { appPath, size, encoding in
  guard let icon = getIcon(appPath: appPath, size: size) else {
    CLI.printErr("Could not find app with path \(appPath)")
    exit(1)
  }

  if encoding == "buffer" {
    CLI.stdout.write(icon)
  } else {
    print(stringify(data: icon))
  }
}.run()
