//
//  HUploadManager.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import Foundation
import Photos
import UIKit

// 照片上传接口需要修改只能支持单张照片上传
// 多张照片上传需要进行单张接口进行轮训然后
// 最后照片上传完成后需要发送一个put方法进行处理照片
protocol HUploadOperationDelegate {
    func uploadData(data: DisplayAsset,completedHandler: @escaping (HTTPURLResponse?,Data?,Error?) -> Void)
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
    
    private let dataSource: DisplayAsset
    
    private let delegate: HUploadOperationDelegate
    
    init(data: DisplayAsset,delegate: HUploadOperationDelegate) {
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
  
        self.delegate.uploadData(data: self.dataSource) {_,_,_ in
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
        let config = URLSessionConfiguration.default
//        config.identifier = "onelcat.github.io.upload.session"
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    // MARK: - URLSessionDataDelegate
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
//        debugPrint("sender",bytesSent,totalBytesSent,totalBytesExpectedToSend)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        self.uploadingReceiveData = data
        self.uploadingReceiveData?.append(data)
//        debugPrint(#function,String.init(data: data, encoding: .utf8))
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        debugPrint(#function)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        debugPrint(#function,error)
        guard let completedHandler = self.uploadingCompletedHandler,let item = self.uploadingAsset else {
            fatalError()
        }
        self.uploadDataSource.removeObject(forKey: item.identifier as NSString)
        completedHandler(task.response as? HTTPURLResponse, self.uploadingReceiveData, error)
        
        guard let response = task.response as? HTTPURLResponse else {
            fatalError()
            return
        }
//        let uptask = task as! URLSessionUploadTask
//        debugPrint(uptask,uptask.response,uptask.currentRequest ,uptask.response as? NSHTTPURLResponse)
//        debugPrint("task", )
//        task.response?.url
//        debugPrint(task.response)
//        debugPrint("update data Complete",self.uploadingAsset?.asset, self.uploadingTask)
        debugPrint("一张照片上传完成", String(data: self.uploadingReceiveData!,encoding: .utf8))
        
//        debugPrint(#function)
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
    
    private var uploadDataSource: NSCache<NSString,DisplayAsset> = NSCache<NSString,DisplayAsset>()
    
    private var dataSource: [DisplayAsset] = []
    
    // 上传中的数据处理
    private var uploadingAsset: DisplayAsset?
    
    private var uploadingTask: URLSessionUploadTask?
    
    private var uploadingCompletedHandler: ((HTTPURLResponse?,Data?,Error?) -> Void)?
    
    private var uploadingReceiveData: Data?
    
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
    
    func uploadData(data: DisplayAsset, completedHandler: @escaping (HTTPURLResponse?,Data?,Error?) -> Void) {
        self.uploadingReceiveData = nil
        self.uploadingReceiveData = Data()
        self.uploadingAsset = data
        self.uploadingCompletedHandler = completedHandler
        
        let uploadAsset = data
        
        func upload(_ metaData: [UploadMetaData]) {

            var bodyData = Data()

            for i in 0..<metaData.count {
                
                let data = metaData[i]
                bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
                bodyData.append("Content-Disposition: form-data; name=\"files\"; filename=\"\(data.filename)\"\r\n".data(using: .utf8)!)
                bodyData.append("Content-Type: \(data.contentType)\r\n\r\n".data(using: .utf8)!)
                bodyData.append(data.data)
                
                if i != metaData.count {
                    bodyData.append("\r\n".data(using: .utf8)!)
                }
            }
            
            // end data
            bodyData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
          
#if false
            // 不进行文件的保存 直接把数据上传
            do {
                try HFileManager.shared.fileManager.removeItem(at: self.tempPath)
            } catch _ {
//                assert(false,error.localizedDescription)
            }

            
            do {
                debugPrint("image data", bodyData.count)
                try bodyData.write(to: self.tempPath)
            } catch let error {
                assert(false,error.localizedDescription)
            }
#endif
            let url: URL = URL(string: "http://192.168.8.101:2342/api/v1/users/urpl5sn1qmoiucq9/upload/jeb1792")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue(Client.shared.v1!.token, forHTTPHeaderField: "X-Session-Id")
//            debugPrint(urlRequest.headers)
            
//            let updata = try! Data(contentsOf: tempPath)
            
            debugPrint("body data", bodyData.count)
            let uploadTask = urlSession.uploadTask(with: urlRequest, from: bodyData)
            uploadTask.resume()

            self.uploadingTask = uploadTask
        } //。func end
        
        guard let asset = uploadAsset.asset else {
            fatalError()
            return
        }
        // read resources
        let resources = PHAssetResource.assetResources(for: asset)
        uploadAsset.resources = resources.map{DisplayAssetResource.init(resource: $0)}
        
        var uploadData = Array<UploadMetaData>.init(repeating: UploadMetaData(name: "", filename: "", contentType: "", data: Data()), count: resources.count)
        
        var resultError: Error?
        
        let group = DispatchGroup()
        
        let requestAssetQueue = DispatchQueue(label: "onelcat.github.io.requestAssetData", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        // read cover data
        
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
                        debugPrint("image data", metaData)
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
                debugPrint("资源数据", uploadData)
                upload(uploadData)
            }
        }))
    }
    
    
    // 实现消息队列
  
    func append(_ newElements: [DisplayAsset]) {
        
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
