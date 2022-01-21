//
//  FileProviderEnumerator.swift
//  FileUITest
//
//  Created by SHAREit on 2022/1/20.
//

import FileProvider


class FileProviderEnumerator: NSObject, NSFileProviderEnumerator {
  
  private let path: String

  init(path: String) {
    self.path = path
    super.init()
  }
  
  func invalidate() {

  }
  
  /// 是否能获取到
  func enumerateItems(for observer: NSFileProviderEnumerationObserver, startingAt page: NSFileProviderPage) {
    /// AppGroup 的路径
    let documentsDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroups)?.path
    /// 能否获取原App的路径
    
    var items: [FileProviderItem] = []
    
    if let path = documentsDirectory, let arr = FileManager.default.subpaths(atPath: path + self.path) {
      for str in arr {
        let ref = FileItemReference(path: self.path, filename: str)
        items.append(FileProviderItem(reference: ref))
        
        debugPrint("原始文件 \(path + "/" + str)")
      }
    } else {
        debugPrint("原始文件 AppGroup 的路径: \(documentsDirectory ?? "null")")
    }
    
    observer.didEnumerate(items)
    observer.finishEnumerating(upTo: nil)
  }
}
