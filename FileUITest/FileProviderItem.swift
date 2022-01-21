//
//  FileProviderItem.swift
//  FileUITest
//
//  Created by SHAREit on 2022/1/20.
//

import FileProvider
import UniformTypeIdentifiers

final class FileProviderItem: NSObject {
  let reference: FileItemReference

  init(reference: FileItemReference) {
    self.reference = reference
    super.init()
  }
}

// MARK: - NSFileProviderItem

extension FileProviderItem: NSFileProviderItem {
  var itemIdentifier: NSFileProviderItemIdentifier {
    return reference.itemIdentifier
  }
  
  var parentItemIdentifier: NSFileProviderItemIdentifier {
    return reference.parentReference?.itemIdentifier ?? itemIdentifier
  }
  
  var filename: String {
    return reference.filename
  }
  
  var typeIdentifier: String {
    return reference.typeIdentifier
  }

  var capabilities: NSFileProviderItemCapabilities {
    if reference.isDirectory {
      return [.allowsReading, .allowsContentEnumerating]
    } else {
      return [.allowsReading, .allowsWriting]
    }
  }

  var documentSize: NSNumber? {
    return nil
  }
}
