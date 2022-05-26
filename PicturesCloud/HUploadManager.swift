//
//  HUploadManager.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import Foundation

protocol HUploadOperationDelegate {
    func uploadData(data: LocalPictureModel,resultHandler: @escaping (_ result: Result<[AnyHashable : Any],Error>) -> Void)
}

class HUploadOperation: Operation {
    
    fileprivate var _executing : Bool = false
    override open var isExecuting: Bool {
        get { return _executing }
        set {
            if newValue != _executing {
                willChangeValue(forKey: "isExecuting")
                _executing = newValue
                didChangeValue(forKey: "isExecuting")
            }
        }
    }
    
    fileprivate var _finished : Bool = false
    override open var isFinished: Bool {
        get { return _finished }
        set {
            if newValue != _finished {
                willChangeValue(forKey: "isFinished")
                _finished = newValue
                didChangeValue(forKey: "isFinished")
            }
        }
    }
    
    override open var isAsynchronous: Bool {
        get {
            return true
        }
    }
    
    private let dataSource: LocalPictureModel
    
    private let delegate: HUploadOperationDelegate
    
    init(data: LocalPictureModel,delegate: HUploadOperationDelegate) {
        self.dataSource = data
        self.delegate = delegate
        super.init()
        
        self.isExecuting = false
        self.isFinished = false
    }
    
    override open func start() {
        isExecuting = true
        isFinished = false
        
       func completed() {
           DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(0.1)), execute: {
               self.done()
           })
       }
        
        self.delegate.uploadData(data: self.dataSource) { result in
            completed()
        }
    } // override func start()
    
    open func done() {
        self.isFinished = true
        self.isExecuting = false
        reset()
    }
    
    open func reset() {
        
    }
}

public struct HUploadManager:HUploadOperationDelegate {
    
    private let queue = DispatchQueue(label: "onelcat.github.io.HUploadManager.queue")
    
    static let shared = HUploadManager()
    
    // 表单上传数据 // 多文件上传数据
    private func uploadPicture(picture:LocalPictureModel) {
        
    }
    
    // 读取数据
    private func readPicture(picture:LocalPictureModel) {
        
    }
    
    func uploadData(data: LocalPictureModel,resultHandler: @escaping (_ result: Result<[AnyHashable : Any],Error>) -> Void) {
        // 读取数据
        
        // 表单上传数据
    }
    
    
    // 实现消息队列
        
    
}
