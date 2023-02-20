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

public class DownloadManager: NSObject, DownloadOperationDelegate  {
//    URLSessionDownloadDelegate
    var downloadDelegate: DownloadManagerDelegate?
  
//    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//
//    }
//
//
//    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//
//    }
//
//
//    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
//
//    }
//
//    // MARK: - URLSession
//    private lazy var urlSession: URLSession = { [unowned self] in
//        let config = URLSessionConfiguration.default
//        config.isDiscretionary = true
//        config.sessionSendsLaunchEvents = true
//        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
//    }()
//
//    // MARK: - URLSessionDataDelegate
//    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
//
//    }
//
////    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
////
////        self.downloadingReceiveData?.append(data)
////
////    }
//
//    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
//        debugPrint(#function)
//    }
//
//    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//
//    }
//
//    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
//
//        DispatchQueue.main.async {
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
//                let backgroundCompletionHandler =
//                appDelegate.backgroundCompletionHandler else {
//                    return
//            }
//            backgroundCompletionHandler()
//        }
//    }
    
    static let shared = DownloadManager()
    
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
    
    
    func downloadData(data: DownloadAsset,
                      completedHandler: @escaping (HTTPURLResponse?,Data?,Error?) -> Void) {
        self.downloadingReceiveData = nil
        self.downloadingReceiveData = Data()
        self.downloadData = data
        self.downloadingCompletedHandler = completedHandler
        
//        var resultError: Error?
        let group = DispatchGroup()
        
        let requestAssetQueue = DispatchQueue(label: "onelcat.github.io.download.asset", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        // 判断资源类型
        
        // 然后在更具类型进行判断需要下载多少数据 live（2）
        
        // 对数据下载的时候 需要进行判断
        
        if data.PhotoType == .live {
            if data.Files.count == 2 {
                // 需要验证数据
                var imageFile: File!
                var imageData: Data?
                
                var movFile: File!
                var movData: Data?
                
                var resultError: Error?
                
                if data.Files[0].FileType == .jpg {
                    imageFile = data.Files[0]
                }
                else if data.Files[0].FileType == .mov {
                    movFile = data.Files[0]
                } else {
                    assert(false)
                }
                
                if data.Files[1].FileType == .jpg {
                    imageFile = data.Files[1]
                }
                else if data.Files[1].FileType == .mov {
                    movFile = data.Files[1]
                } else {
                    assert(false)
                }
                
                group.enter()
                requestAssetQueue.async(group: group, execute: DispatchWorkItem.init(block: {
                    
                        Client.shared.api.requestNormal(.getPhotoDownload(imageFile.PhotoUID ?? "", Client.shared.v1?.downloadToken ?? ""), callbackQueue: nil, progress: nil) { result in
                            
                            
                            
                        switch result {
                        case .success(let reponse):
                            debugPrint(reponse.request)
                            guard reponse.statusCode == 200 else {
                                group.leave()
                                return
                            }
                            
                            imageData = reponse.data
                            group.leave()
                        case .failure(let error):
                            assert(false,"error")
                            resultError = error
                            group.leave()
                            break;
                        }
                        
                    }
                }))
                
                group.enter()
                requestAssetQueue.async(group: group, execute: DispatchWorkItem.init(block: {
                    
                    Client.shared.api.requestNormal(.getPhotoDownload(movFile.PhotoUID ?? "", Client.shared.v1?.downloadToken ?? ""), callbackQueue: nil, progress: nil) { result in
                        switch result {
                        case .success(let reponse):
                            debugPrint(reponse.request)
                            guard reponse.statusCode == 200 else {
                                group.leave()
                                return
                            }
                            movData = reponse.data
                            group.leave()
                        case .failure(let error):
                            assert(false,"error")
                            resultError = error
                            group.leave()
                            break;
                        }
                    }
                }))
                
                group.notify(queue: requestAssetQueue, work: .init(block: {
                    // 返回数据
                    if let error = resultError {
//                        assert(false,)
                        fatalError(error.localizedDescription)
                    } else {
                        // 写入数据
                        debugPrint("开始写入数据", imageData?.count , movData?.count)
                        LocalPhotoManager.writeLivePhoto2Album(imageData!, liveData: movData!) { result, error in
                            debugPrint("写入照片结果", result,error)
                        }
        //
                    }
                }))
            } else {
                assert(false)
            }
            
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
    
    func writeGIF(data: Data,completionHandler: @escaping ((Bool, Error?) -> Void)) {
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCreationRequest()
            request.addResource(with: PHAssetResourceType.photo, data: data, options: nil)
        },completionHandler: completionHandler)
        
//        PHPhotoLibrary.shared().performChanges {
//            let request = PHAssetCreationRequest()
//            request.addResource(with: PHAssetResourceType.photo, data: data, options: nil)
//        } completionHandler: { result, error in
//            completionHandl(result,error)
//        }
//        PHPhotoLibrary.shared().performChanges {
//            let request = PHAssetCreationRequest()
//            request.addResource(with: PHAssetResourceType.photo, data: data, options: nil)
//
//        }completionHandler: { result, error in
//
//        }
    }
    
    func writeLivePhoto(_ photo: Data, liveData: Data, completionHandler: @escaping ((Bool, Error?) -> Void)) {
        
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCreationRequest()
            request.addResource(with: PHAssetResourceType.photo, data: photo, options: nil)
            request.addResource(with: PHAssetResourceType.pairedVideo, data: liveData, options: nil)
        },completionHandler: completionHandler)
        
        
//        PHPhotoLibrary.shared().performChanges {
//            let request = PHAssetCreationRequest()
//            request.addResource(with: PHAssetResourceType.photo, data: Data(), options: nil)
//            request.addResource(with: PHAssetResourceType.pairedVideo, data: Data(), options: nil)
//        }completionHandler: { result, error in
//
//        }
        
//        PHLivePhoto.request(withResourceFileURLs: [], placeholderImage: mil, targetSize: CGSize.zero, contentMode: PHImageContentMode.aspectFill) { lievePhoto, info in
//
//        }
    }
}
