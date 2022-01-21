//
//  FileProviderExtension.swift
//  FileUITest
//
//  Created by SHAREit on 2022/1/20.
//

import FileProvider

let appGroups = "group.jingwei.FileProviderUI"

class FileProviderExtension: NSFileProviderExtension {
    
    private lazy var fileManager = FileManager()
    private let groupPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroups)?.path

    
    override func item(for identifier: NSFileProviderItemIdentifier) throws -> NSFileProviderItem {
        guard let reference = FileItemReference(itemIdentifier: identifier) else {
            throw NSError.fileProviderErrorForNonExistentItem(withIdentifier: identifier)
        }
        return FileProviderItem(reference: reference)
    }
    
    
    override func urlForItem(withPersistentIdentifier identifier: NSFileProviderItemIdentifier) -> URL? {
        guard let item = try? item(for: identifier) else {
            return nil
        }
        
        let url = NSFileProviderManager.default.documentStorageURL
            .appendingPathComponent(identifier.rawValue, isDirectory: true)
            .appendingPathComponent(item.filename)
        
        return url
    }
    
    
    
    override func persistentIdentifierForItem(at url: URL) -> NSFileProviderItemIdentifier? {
        let identifier = url.deletingLastPathComponent().lastPathComponent
        return NSFileProviderItemIdentifier(identifier)
    }
    
    
    
    override func providePlaceholder(at url: URL, completionHandler: @escaping (Error?) -> Void) {
        do {
            try providePlaceholder(at: url)
            completionHandler(nil)
        } catch {
            completionHandler(error)
        }
    }
    
    // MARK: - Enumeration 伪造数据 可以嘛
    // MARK: - 获取沙河数据
    override func enumerator(for containerItemIdentifier: NSFileProviderItemIdentifier) throws -> NSFileProviderEnumerator {
        
        if containerItemIdentifier == .rootContainer {
            return FileProviderEnumerator(path: "/")
        }
        
        guard
            let ref = FileItemReference(itemIdentifier: containerItemIdentifier),
            ref.isDirectory
        else {
            throw FileProviderError.notAContainer
        }
        return FileProviderEnumerator(path: ref.path)
    }
    
    
    // MARK: - Providing Items
    override func startProvidingItem(at url: URL, completionHandler: @escaping ((_ error: Error?) -> Void)) {
        guard !fileManager.fileExists(atPath: url.path) else {
            debugPrint("开始传输 文件存在 \(url.path)")
            completionHandler(nil)
            return
        }
        guard
          let identifier = persistentIdentifierForItem(at: url),
          let reference = FileItemReference(itemIdentifier: identifier)
          else {
            completionHandler(FileProviderError.unableToFindMetadataForItem)
            return
        }
        let name = reference.filename
        let path = reference.containingDirectory
        do {
            if let path = groupPath {
                try self.fileManager.moveItem(at: URL(fileURLWithPath: path + "/\(name)"), to: url)
            }
            debugPrint("开始传输 成功 ")
            completionHandler(nil)
        } catch {
            debugPrint("开始传输 失败 ")
            completionHandler(error)
        }
    }
    
    override func stopProvidingItem(at url: URL) {
        try? fileManager.removeItem(at: url)
        try? providePlaceholder(at: url)
    }
    
    private func providePlaceholder(at url: URL) throws {
        guard
            let identifier = persistentIdentifierForItem(at: url),
            let reference = FileItemReference(itemIdentifier: identifier)
        else {
            throw FileProviderError.unableToFindMetadataForPlaceholder
        }
        
        try fileManager.createDirectory(
            at: url.deletingLastPathComponent(),
            withIntermediateDirectories: true,
            attributes: nil
        )
        
        let placeholderURL = NSFileProviderManager.placeholderURL(for: url)
        let item = FileProviderItem(reference: reference)
        
        try NSFileProviderManager.writePlaceholder(
            at: placeholderURL,
            withMetadata: item
        )
    }
    
    
    override init() {
        super.init()
        debugPrint("AppGroup 的路径 \(groupPath ?? "null")")

//        saveWithFile()
    }
    func saveWithFile() {
        /// AppGroup 的路径
        if let documentsDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroups)?.path {
            let filePath = documentsDirectory + "/data.txt";
            let dataSource = NSMutableArray();
            dataSource.add("衣带渐宽终不悔");
            dataSource.add("为伊消得人憔悴");
            dataSource.add("故国不堪回首明月中");
            dataSource.add("人生若只如初见");
            dataSource.add("暮然回首，那人却在灯火阑珊处");
            // 4、将数据写入文件中
            dataSource.write(toFile: filePath, atomically: true);
        }
    }
}
