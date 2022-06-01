//
//  HUploadManager.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import Foundation
import Photos
import UIKit

protocol HUploadOperationDelegate {
    func uploadData(data: LocalPictureModel,completedHandler: @escaping () -> Void)
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
  
        self.delegate.uploadData(data: self.dataSource) {
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

// TODO: 后续实现 - 查看上传进度

public class HUploadManager: NSObject, HUploadOperationDelegate, URLSessionDataDelegate {
    
    struct UploadMetaData {
        let name: String
        let filename: String
        let contentType: String
        let data: Data
    }
    
    // MARK: - URLSession
    private lazy var urlSession: URLSession = { [unowned self] in
        let config = URLSessionConfiguration.background(withIdentifier: "onelcat.github.io.upload.session")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    // MARK: - URLSessionDataDelegate
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
//        debugPrint("sender",bytesSent,totalBytesSent,totalBytesExpectedToSend)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.uploadReceiveData = data
        debugPrint(#function,String.init(data: data, encoding: .utf8))
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        debugPrint(#function)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let completedHandler = self.uploadCompletedHandler,let item = self.uploadAsset else {
            fatalError()
        }
        debugPrint("update data Complete",self.uploadAsset?.asset, self.uploadTask)
        completedHandler()
        self.uploadDataSource.removeObject(forKey: item.identifier as NSString)
        debugPrint(#function)
    }
    
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let backgroundCompletionHandler =
                appDelegate.backgroundCompletionHandler else {
                    return
            }
            backgroundCompletionHandler()
        }
    }
    
    private lazy var boundary: String = {
        return Self.randomBoundary()
    }()
    
    static let shared = HUploadManager()
    
    private let tempPath = HFileManager.shared.uploadTemp
    
    private var uploadDataSource: NSCache<NSString,LocalPictureModel> = NSCache<NSString,LocalPictureModel>()
    
    private var dataSource: [LocalPictureModel] = []
    
    private var uploadAsset: LocalPictureModel?
    
    private var uploadTask: URLSessionUploadTask?
    
    private var uploadCompletedHandler: (() -> Void)?
    
    private var uploadReceiveData: Data?
    
    lazy var uploadOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    static func randomBoundary() -> String {
        let first = UInt32.random(in: UInt32.min...UInt32.max)
        let second = UInt32.random(in: UInt32.min...UInt32.max)
        return String(format: "onelcat.github.io.boundary.%08x%08x", first, second)
    }
    
    func uploadData(data: LocalPictureModel, completedHandler: @escaping () -> Void) {
        
        self.uploadAsset = data
        self.uploadCompletedHandler = completedHandler
        
        let uploadAsset = data
        
        func upload(_ metaData: [UploadMetaData]) {

            var bodyData = Data()

            for i in 0..<metaData.count {
                
                let data = metaData[i]
                bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
                bodyData.append("Content-Disposition: form-data; name=\"\(data.name)\"; filename=\"\(data.filename)\"\r\n".data(using: .utf8)!)
                bodyData.append("Content-Type: \(data.contentType)\r\n\r\n".data(using: .utf8)!)
                bodyData.append(data.data)
                
                if i != metaData.count {
                    bodyData.append("\r\n".data(using: .utf8)!)
                }
            }
            
            // end data
            bodyData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
          
            
            do {
                try HFileManager.shared.fileManager.removeItem(at: self.tempPath)
            } catch _ {
//                assert(false,error.localizedDescription)
            }
            
            do {
                try bodyData.write(to: self.tempPath)
            } catch let error {
                assert(false,error.localizedDescription)
            }
            
            let url: URL = URL(string: "http://192.168.1.5:8888/upload")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let uploadTask = urlSession.uploadTask(with: urlRequest, fromFile: tempPath)
            uploadTask.resume()
            debugPrint("update data",data.asset, uploadTask)
            self.uploadTask = uploadTask
        } //。func end
        
        let asset = uploadAsset.asset
        // read resources
        let resources = PHAssetResource.assetResources(for: asset)
        uploadAsset.assetResource = resources
        
        var uploadData = Array<UploadMetaData>.init(repeating: UploadMetaData(name: "", filename: "", contentType: "", data: Data()), count: resources.count)
        
        var resultError: Error?
        
        let group = DispatchGroup()
        
        let requestAssetQueue = DispatchQueue(label: "onelcat.github.io.requestAssetData", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        // read data
        for i in 0..<resources.count {
            
            group.enter()
            requestAssetQueue.async(group: group, execute: DispatchWorkItem.init(block: {
                let index = i
                let resource = resources[i]
                var itemData = Data()
                PHAssetResourceManager.default().requestData(for: resource, options: nil) { data in
                    itemData.append(data)
                } completionHandler: { error in
                    resultError = error
                    if let error = error {
                        assert(false,error.localizedDescription)
                    } else {
                        var nameEx:[String] = resource.originalFilename.split(separator: ".").map{String($0)}
//                        assert(nameEx.count == 2,"name error")
                        nameEx[0] = resource.assetLocalIdentifier.replacingOccurrences(of: "/", with: "_")
                        let filename = nameEx.joined(separator: ".")
                        
                        let metaData = UploadMetaData(name: "original", filename: filename, contentType: resource.uniformTypeIdentifier, data: itemData)
                        
//                        debugPrint("original size", itemData.count, resource)
                        
                        uploadData[index] = metaData
                    }
                    group.leave()
                }
            }))
        }
    
        group.notify(queue: requestAssetQueue, work: .init(block: {
            // 返回数据
            if let error = resultError {
                fatalError(error.localizedDescription)
            } else {
                upload(uploadData)
            }
        }))
    }
    
    
    // 实现消息队列
  
    func append(_ newElements: [LocalPictureModel]) {
        
        self.dataSource.append(contentsOf: newElements)
    }
    
    func remove(identifiers: [String]) {
        
    }
    
    func start() {
        let data = self.dataSource
        self.dataSource.removeAll()
        for item in data {
            let operation = HUploadOperation(data: item, delegate: self)
            
            self.uploadDataSource.setObject(item, forKey: item.identifier as NSString)
            uploadOperationQueue.addOperation(operation)
        }
    }
    
    func suspend() {
        
    }
    
    func stop() {
        
    }
    
    
}
