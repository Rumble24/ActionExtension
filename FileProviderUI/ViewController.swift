//
//  ViewController.swift
//  FileProviderUI
//
//  Created by SHAREit on 2022/1/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }

//    <Application_Home>/AppName.app：存放应用程序自身
    
//    <Application_Home>/Documents/：存放用户文档和应用数据文件
    
//    <Application_Home>/Library/：应用程序规范的顶级目录，下面有一些规范定义的的子目录，当然也可以自定义子目录，
//    用于存放应用的文件，但是不宜存放用户数据文件，和document一样会被itunes同步，但不包括caches子目录
    
//    <Application_Home>/Library/Preferences，这里存放程序规范要求的首选项文件
    
//    <Application_Home>/Library/Caches，保存应用的持久化数据，用于应用升级或者应用关闭后的数据保存，
//    不会被itunes同步，所以为了减少同步的时间，可以考虑将一些比较大的文件而又不需要备份的文件放到这个目录下
    
//    <Application_Home>/tmp/，保存应用数据，但不需要持久化的，在应用关闭后，该目录下的数据将删除，也可能系统在程序不运行的时候做清楚 ，官方文档摘抄：

}

