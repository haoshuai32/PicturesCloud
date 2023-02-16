//
//  HUploadManager.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import Foundation
import Photos
import UIKit

typealias UploadAsset = PhotoAsset

// 照片上传接口需要修改只能支持单张照片上传
// 多张照片上传需要进行单张接口进行轮训然后
// 最后照片上传完成后需要发送一个put方法进行处理照片
// 上传队列 需要在最后进行数据汇总进行UI显示
// 上传需要显示进度条
protocol HUploadOperationDelegate {
    func uploadData(data: UploadAsset,completedHandler: @escaping (HTTPURLResponse?,Data?,Error?) -> Void)
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
    
    private let dataSource: UploadAsset
    
    private let delegate: HUploadOperationDelegate
    
    init(data: UploadAsset,delegate: HUploadOperationDelegate) {
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

protocol HUploadManagerDelegate {
    
    // 上传进度 当前上传到多少了
    func uploadItemDidComplete(index:(Int,Int),data: UploadAsset ,info: (HTTPURLResponse,Data?,Error?))
    // 单条上传进度错误
    
    // 上传完成 （上传成功多少 上传失败多少）
    func uploadDidComplete(success:[UploadAsset], failure: [UploadAsset])
}

// TODO: 后续实现 - 查看上传进度

public class HUploadManager: NSObject, HUploadOperationDelegate, URLSessionDataDelegate {
    var uploadDelegate: HUploadManagerDelegate?
    
    struct UploadMetaData {
        // 只能是固定制
        let name: String = "files"
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
//        debugPrint("sender",bytesSent,tota\0lBytesSent,totalBytesExpectedToSend)
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
        guard let response = task.response as? HTTPURLResponse else {
            fatalError()
        }
        // 移除已经上传成功的数据
//        let updata = self.uploadDataSource.object(forKey: item.identifier as NSString)
        self.uploadDataSource.removeObject(forKey: item.identifier as NSString)
        completedHandler(task.response as? HTTPURLResponse, self.uploadingReceiveData, error)
        self.uploadIndex += 1
        
        if response.statusCode == 200 {
            self.uploadSuccess.append(item)
        } else {
            self.uploadFailure.append(item)
        }
        
        uploadDelegate?.uploadItemDidComplete(index: (self.uploadIndex, self.uploadCount),data:item, info: (response, self.uploadingReceiveData, error))
        debugPrint("一张照片上传完成",task.response as! HTTPURLResponse)
        
        
//        debugPrint("一张照片上传完成",task.response, String(data: self.uploadingReceiveData!,encoding: .utf8),error)
//        guard let response = task.response as? HTTPURLResponse else {
//            fatalError()
//            return
//        }
//        let uptask = task as! URLSessionUploadTask
//        debugPrint(uptask,uptask.response,uptask.currentRequest ,uptask.response as? NSHTTPURLResponse)
//        debugPrint("task", )
//        task.response?.url
//        debugPrint(task.response)
//        debugPrint("update data Complete",self.uploadingAsset?.asset, self.uploadingTask)
//        debugPrint("一张照片上传完成", String(data: self.uploadingReceiveData!,encoding: .utf8))
        
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
    
    private var uploadDataSource: NSCache<NSString,UploadAsset> = NSCache<NSString,UploadAsset>()
    
    private var uploadSuccess: [UploadAsset] = []
    private var uploadFailure: [UploadAsset] = []
    private var uploadToken: String = ""
    private var uploadCount = 0
    private var uploadIndex = 0
    
    func beginConfig() {
        uploadSuccess.removeAll()
        uploadFailure.removeAll()
        uploadToken = String.randomString(length: 7)
        uploadIndex = 0
        uploadCount = 0
        
    }
    
    func doneConfig() {
        uploadSuccess.removeAll()
        uploadFailure.removeAll()
        uploadSuccess.removeAll()
        uploadFailure.removeAll()
        uploadToken = ""
        uploadIndex = 0
        uploadCount = 0
        
    }
    
//    private var dataSource: [DisplayAsset] = []
    
    // 上传中的数据处理
    private var uploadingAsset: UploadAsset?
    
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
    
    func uploadData(data: UploadAsset, completedHandler: @escaping (HTTPURLResponse?,Data?,Error?) -> Void) {
        self.uploadingReceiveData = nil
        self.uploadingReceiveData = Data()
        self.uploadingAsset = data
        self.uploadingCompletedHandler = completedHandler
        
        let uploadAsset = data
        
        // 比如livephoto 存在2个资源
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
            let url: URL = URL(string: "http://127.0.0.1:2342/api/v1/users/\(Client.shared.userID!)/upload/\(self.uploadToken)")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue(Client.shared.v1!.token, forHTTPHeaderField: "X-Session-Id")

            
            
//            debugPrint(urlRequest.headers)
//            let updata = try! Data(contentsOf: tempPath)
            
//            debugPrint("body data", bodyData.count)
            let uploadTask = urlSession.uploadTask(with: urlRequest, from: bodyData)
            uploadTask.resume()

            self.uploadingTask = uploadTask
        } //。func end
        
        switch uploadAsset.dataSource {
        case .local(let asset):
            readAsset(asset)
            break
        case .cloud(_):
            fatalError()
        }
        
//        guard let asset = uploadAsset.asset else {
//            fatalError()
//        }
        // read resources
        
        func readAsset(_ asset: PHAsset) {
            let resources = PHAssetResource.assetResources(for: asset)
            
//            uploadAsset.resources = resources.map{DisplayAssetResource.init(resource: $0)}
            
            var uploadData = Array<UploadMetaData>.init(repeating: UploadMetaData(filename: "", contentType: "", data: Data()), count: resources.count)
            
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
                            
                            let metaData = UploadMetaData(filename: filename, contentType: resource.uniformTypeIdentifier, data: itemData)
    //                        debugPrint("image data", metaData)
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
    //                debugPrint("资源数据", uploadData)
                    upload(uploadData)
                }
            }))
        }
        
    }
    
    
    // 实现消息队列
  
//    func append(_ newElements: [DisplayAsset]) {
//
//        self.dataSource.append(contentsOf: newElements)
//    }
    
    func remove(identifiers: [String]) {
        
    }
    
    // 开始
    func start(data: [UploadAsset]) {
        // Wi-Fi模式
        // 流量模式
        // 最多上传100张
        // 总共最多不能超过 一万张
        
        
        self.beginConfig()
        self.uploadCount = data.count
        
        
        for item in data {
            let operation = HUploadOperation(data: item, delegate: self)
            
            self.uploadDataSource.setObject(item, forKey: item.identifier as NSString)
            uploadOperationQueue.addOperation(operation)
        }
        let uploadToken = self.uploadToken
        uploadOperationQueue.addBarrierBlock { [weak self] in
            debugPrint("照片上传完成")
            Client.shared.api.requestNormal(.uploadUserFilesP(Client.shared.userID!, uploadToken), callbackQueue: nil, progress: nil) { result in
                switch result {
                case .success(let reponse):

                    debugPrint("reponse", String.init(data: reponse.data, encoding: String.Encoding.utf8))
                    debugPrint("照片处理完成")
                    self?.doneConfig()
                case let .failure(error):
                    debugPrint("错误 error",error)
                }
            }
            
            // 执行到最后
        }
    }
    
    // 暂停
    func suspend() {
        
    }
    
    // 取消
    func cancel() {
        uploadOperationQueue.cancelAllOperations()
        self.doneConfig()
    }
    
    
}
