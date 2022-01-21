//
//  AppDelegate.swift
//  FileProviderUI
//
//  Created by SHAREit on 2022/1/20.
//

import UIKit

fileprivate let appGroups = "group.jingwei.FileProviderUI"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white;
        window!.rootViewController = ViewController()
        window!.makeKeyAndVisible()
        
        debugPrint("\(NSHomeDirectory())")
        return true
    }
    
    // Report Push Notification attribution data for re-engagements
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        /// 已经保存好了
        debugPrint("application open url:  \(url)")
        
        /// Action Extension 打开
        if url.absoluteString.contains("actionExtension") == true {
            if let filePath = self.saveActionExtensionFileToDocumentFile(url: url) {
                debugPrint("分享文件地址：\(filePath)")
            }
        }
        /// 外部App打开我们的App 苹果已经为我们保存在 Documents/Inbox里面了
        /// 可以直接把链接给他们分享
        else if url.absoluteString.contains("file:///private") == true {
            debugPrint("分享文件地址：\(url.path)")
        }
        
        return true
    }
    
    func saveActionExtensionFileToDocumentFile(url: URL) -> String? {
        let fileManager = FileManager()
        
        if let groupPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroups)?.path {
            
            if let fileName = url.path.split(separator: "/").last {
                
                /// 得到完整的文件路径
                let filePath = groupPath + "/\(fileName)"
                let fileURL = URL(fileURLWithPath: filePath)
                
                /// 保存在Document中
                if fileManager.fileExists(atPath: filePath) {
                    
                    let toFilePath = NSHomeDirectory() + "/Documents/\(fileName)"

//                    let toFilePath = NSTemporaryDirectory() + "/\(fileName)"
                    debugPrint("NSHomeDirectorys \(NSHomeDirectory())")
                    debugPrint("NSTemporaryDirectory \(NSTemporaryDirectory())")

                    do {
                        let data = try! Data(contentsOf: fileURL)
                        try data.write(to: URL(fileURLWithPath: toFilePath))
                        
                        debugPrint("保存在Temp中 success \(toFilePath)")
                        return toFilePath

                    } catch {
                        debugPrint("保存在Temp中 fail \(toFilePath)")
                    }
                    
                } else {
                    debugPrint("文件不存在 在AppGroup 中")
                }
                                
            } else {
                debugPrint("文件名 错误")
            }
            
        } else {
            debugPrint("AppGroup 不存在")
        }
        
        return nil
    }
    
    /// 使用其他应用打开
    /// file:///private/var/mobile/Containers/Data/Application/6FB75208-5D88-4318-9988-D0358581355F/Documents/Inbox/shareKaro-3.txt"
    
    /// 使用files App 打开
    /// file:///private/var/mobile/Containers/Data/Application/6FB75208-5D88-4318-9988-D0358581355F/Documents/Inbox/IMG_4455.HEIC"
}

