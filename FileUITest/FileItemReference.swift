//
//  FileProviderEnumerator.swift
//  FileUITest
//
//  Created by SHAREit on 2022/1/20.
//

import FileProvider
import MobileCoreServices

struct FileItemReference {
  private let urlRepresentation: URL
  
  private var isRoot: Bool {
    return urlRepresentation.path == "/"
  }
  
  private init(urlRepresentation: URL) {
    self.urlRepresentation = urlRepresentation
  }
  
  init(path: String, filename: String) {
    let isDirectory = filename.components(separatedBy: ".").count == 1
    let pathComponents = path.components(separatedBy: "/").filter {
      !$0.isEmpty
    } + [filename]
    
    var absolutePath = "/" + pathComponents.joined(separator: "/")
    if isDirectory {
      absolutePath.append("/")
    }
    absolutePath = absolutePath.addingPercentEncoding(
      withAllowedCharacters: .urlPathAllowed
    ) ?? absolutePath
    
    self.init(urlRepresentation: URL(string: "itemReference://\(absolutePath)")!)
  }
  
  init?(itemIdentifier: NSFileProviderItemIdentifier) {
    guard itemIdentifier != .rootContainer else {
      self.init(urlRepresentation: URL(string: "itemReference:///")!)
      return
    }
    
    guard let data = Data(base64Encoded: itemIdentifier.rawValue),
      let url = URL(dataRepresentation: data, relativeTo: nil) else {
        return nil
    }
    
    self.init(urlRepresentation: url)
  }

  var itemIdentifier: NSFileProviderItemIdentifier {
    if isRoot {
      return .rootContainer
    } else {
      return NSFileProviderItemIdentifier(
        rawValue: urlRepresentation.dataRepresentation.base64EncodedString()
      )
    }
  }

  var isDirectory: Bool {
    return urlRepresentation.hasDirectoryPath
  }

  var path: String {
    return urlRepresentation.path
  }

  var containingDirectory: String {
    return urlRepresentation.deletingLastPathComponent().path
  }

  var filename: String {
    return urlRepresentation.lastPathComponent
  }

  var typeIdentifier: String {
    guard !isDirectory else {
      return kUTTypeFolder as String
    }
    
    let pathExtension = urlRepresentation.pathExtension
    let unmanaged = UTTypeCreatePreferredIdentifierForTag(
      kUTTagClassFilenameExtension,
      pathExtension as CFString,
      nil
    )
    let retained = unmanaged?.takeRetainedValue()
    
    return (retained as String?) ?? ""
  }

  var parentReference: FileItemReference? {
    guard !isRoot else {
      return nil
    }
    return FileItemReference(
      urlRepresentation: urlRepresentation.deletingLastPathComponent()
    )
  }
}
