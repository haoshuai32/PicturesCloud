//
//  HDownloadManager.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import Foundation
import Photos
import UIKit

typealias DownloadAsset = Photo

protocol DownloadOperationDelegate {
    func downloadData(data: DownloadAsset,completedHandler: @escaping (HTTPURLResponse?,Data?,Error?) -> Void)
}


protocol DownloadManagerDelegate {
    
    // 下载进行
    func downloadItemDidComplete(index:(Int,Int) ,info: (HTTPURLResponse,Data?,Error?))
    
    
    // 下载完成 （上传成功多少 上传失败多少）
    func downloadDidComplete(success:[DownloadAsset], failure: [DownloadAsset])
}
class DownloadOperation: Operation {
    
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
    // uid token
    let token: (String,String)
//    private let d ataSource: DisplayAsset
    
    private let delegate: DownloadOperationDelegate
    
    init(data: (String,String),delegate: DownloadOperationDelegate) {
        self.token = data
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
  
//        self.delegate
//        self.delegate.uploadData(data: self.dataSource) {_,_,_ in
//            completed()
//        }
        
    } // override func start()
    
    open func done() {
        self.isFinished = true
        self.isExecuting = false
        reset()
    }
    
    open func reset() {
        
    }
}

public class DownloadManager: NSObject, DownloadOperationDelegate, URLSessionDownloadDelegate {
    
    var downloadDelegate: DownloadManagerDelegate?
  
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }

    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
    }

    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
    
    // MARK: - URLSession
    private lazy var urlSession: URLSession = { [unowned self] in
        let config = URLSessionConfiguration.default
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    // MARK: - URLSessionDataDelegate
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {

    }
    
//    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//
//        self.downloadingReceiveData?.append(data)
//
//    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        debugPrint(#function)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

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
    
    static let shared = HUploadManager()
    
    private var downloadDataSource: NSCache<NSString,DisplayAsset> = NSCache<NSString,DisplayAsset>()
    
    private var downloadSuccess: [DisplayAsset] = []
    private var downloadFailure: [DisplayAsset] = []
    private var downloadToken: String = ""
    private var downloadCount = 0
    private var downloadIndex = 0
    
    func beginConfig() {
        downloadSuccess.removeAll()
        downloadFailure.removeAll()
        downloadToken = String.randomString(length: 7)
        downloadCount = 0
        downloadIndex = 0
        
    }
    
    func doneConfig() {
        downloadSuccess.removeAll()
        downloadFailure.removeAll()
        downloadToken = ""
        downloadCount = 0
        downloadIndex = 0
        
    }
    
    private var downloadData: Photo?
    
    private var downloadingTask: URLSessionUploadTask?
    
    private var downloadingCompletedHandler: ((HTTPURLResponse?,Data?,Error?) -> Void)?
    
    private var downloadingReceiveData: Data?
    
    lazy var uploadOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    
    func downloadData(data: DownloadAsset, completedHandler: @escaping (HTTPURLResponse?,Data?,Error?) -> Void) {
        self.downloadingReceiveData = nil
        self.downloadingReceiveData = Data()
        self.downloadData = data
        self.downloadingCompletedHandler = completedHandler
        
        var resultError: Error?
        let group = DispatchGroup()
        
        let requestAssetQueue = DispatchQueue(label: "onelcat.github.io.download.asset", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        // 需要验证数据
        for item in data.Files {
            group.enter()
            requestAssetQueue.async(group: group, execute: DispatchWorkItem.init(block: {
                
                Client.shared.api.requestNormal(.getPhotoDownload(item.FileUID ?? "", Client.shared.v1?.downloadToken ?? ""), callbackQueue: nil, progress: nil) { result in
                    switch result {
                    case .success(let reponse):
                        guard reponse.statusCode == 200 else {
                            group.leave()
                            return
                        }
    //                    reponse.data
    //
                    case .failure(let error):
                        assert(false,"error")
                        break;
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
                // 写入数据
//                upload(uploadData)
                //
//                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: <#T##URL#>)
                // Add the asset to the photo library.
//                PHPhotoLibrary.shared().performChanges({
//                    let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
//                    if let assetCollection = self.assetCollection {
//                        let addAssetRequest = PHAssetCollectionChangeRequest(for: assetCollection)
//                        addAssetRequest?.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
//                    }
//                }, completionHandler: {success, error in
//                    if !success { print("Error creating the asset: \(String(describing: error))") }
//                })
//                
//                
//                
            }
        }))
        
        
    }
    
    
    // 实现消息队列
  
//    func append(_ newElements: [DisplayAsset]) {
//
//        self.dataSource.append(contentsOf: newElements)
//    }
    
    func remove(identifiers: [String]) {
        
    }
    
    // 开始
    func start(data: [DisplayAsset]) {
        // Wi-Fi模式
        // 流量模式
        // 最多上传100张
        // 总共最多不能超过 一万张
        
//
//        self.beginConfig()
//        self.uploadCount = data.count
        
        
//        self.dataSource.append(contentsOf: newElements)
//        let data = self.dataSource
//        self.dataSource.removeAll()
//        for item in data {
//            let operation = HUploadOperation(data: item, delegate: self)
//
//            self.uploadDataSource.setObject(item, forKey: item.identifier as NSString)
//            uploadOperationQueue.addOperation(operation)
//        }
//        let uploadToken = self.uploadToken
//        uploadOperationQueue.addBarrierBlock { [weak self] in
//            debugPrint("照片上传完成")
//            Client.shared.api.requestNormal(.uploadUserFilesP(Client.shared.userID!, uploadToken), callbackQueue: nil, progress: nil) { result in
//                switch result {
//                case .success(let reponse):
//
//                    debugPrint("reponse", String.init(data: reponse.data, encoding: String.Encoding.utf8))
//                    debugPrint("照片处理完成")
//                    self?.doneConfig()
//                case let .failure(error):
//                    debugPrint("错误 error",error)
//                }
//            }
//
//            // 执行到最后
//        }
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
