//
//  ActionViewController.swift
//  ShareAction
//
//  Created by SHAREit on 2022/1/21.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

let appGroups = "group.jingwei.FileProviderUI"

class ActionViewController: UIViewController {

    private lazy var fileManager = FileManager()
    
    lazy var lab = UILabel()
    var contentStr = "传输中。。。"

    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        lab.isUserInteractionEnabled = false
        lab.frame = self.view.bounds
        lab.numberOfLines = 0
        lab.textColor = .black
        view.addSubview(lab)
        
        getData()
    }
    
    func getData() {
        
        self.contentStr.append("\n  getData")
        self.lab.text = self.contentStr
        
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                
                self.contentStr.append("\n  provider: \(provider.registeredTypeIdentifiers)")
                self.lab.text = self.contentStr
                
                if let identifiers = provider.registeredTypeIdentifiers.first {
                    
                    self.contentStr.append("\n  provider: \(identifiers)")
                    self.lab.text = self.contentStr
                    
                    provider.loadItem(forTypeIdentifier: identifiers, options: nil) { [weak self] (url, error) in
                        
                        if let fileUrl = url as? URL {
                            
                            if let groupPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroups)?.path {
                                
                                if let fileName = fileUrl.path.split(separator: "/").last {
                                    
                                    
                                    let toUrl = groupPath + "/\(fileName)"
                                    
                                    self?.contentStr.append("\n  toUrl：\(toUrl)")
                                    self?.lab.text = self?.contentStr
                                    
                                    OperationQueue.main.addOperation {
                                        
                                        do {
                                            
                                            let data = try! Data(contentsOf: fileUrl)
                                            try data.write(to: URL(fileURLWithPath: toUrl))
                                            
                                            self?.contentStr.append("\n  成功：\(toUrl)")
                                            self?.lab.text = self?.contentStr
                                        } catch {
                                            self?.contentStr.append("\n  失败：\(toUrl)")
                                            self?.lab.text = self?.contentStr
                                        }
                                        
                                        self?.openMeApp(name: "\(fileName)")
                                        
                                    }
                                    
                                }
 
                                
                            }
                            
                        }
                    }
                    
                }

            }
        }
        
    }
    
    
    /// sharekaro 数据，文件类型 校验码
    func openMeApp(name: String) {
        let url = NSURL(string: "document://actionExtension/\(name)")
        let selectorOpenURL = sel_registerName("openURL:")
        let context = NSExtensionContext()
        context.open(url! as URL, completionHandler: nil)
        
        var responder = self as UIResponder?
        
        while (responder != nil){
            if responder?.responds(to: selectorOpenURL) == true{
                responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder!.next
        }
        
        self.contentStr.append("\n  openMeAp")
        self.lab.text = self.contentStr
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems) { state in}
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
