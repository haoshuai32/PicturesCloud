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
    func downloadData(data: DownloadAsset,completedHandler: @escaping (Bool,Error?) -> Void)
}


protocol DownloadManagerDelegate {
    
    // 下载进行
    func downloadItemDidComplete(index:(Int,Int) ,info: (Bool,Error?))
    
    
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
    
    private var downloadingCompletedHandler: ((Bool,Error?) -> Void)?
    
    private var downloadingReceiveData: Data?
    
    lazy var uploadOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    
    func downloadData(data: DownloadAsset,
                      completedHandler: @escaping (Bool,Error?) -> Void) {
        self.downloadingReceiveData = nil
        self.downloadingReceiveData = Data()
        self.downloadData = data
        self.downloadingCompletedHandler = completedHandler
        
        if data.PhotoType == .live {
            if data.Files.count == 2 {
                var imageFile: File!
                var movFile: File!
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
                
                downloadLivePhoto(imageFile: imageFile, movFile: movFile, completedHandler: completedHandler)

            } else {
                assert(false)
            }
            
        }
        
    }
    
    func downloadFile(_ file:File,resourceType: PHAssetResourceType,
                      completedHandler: @escaping (Bool,Error?) -> Void) {
        
        Client.shared.api.requestNormal(.downloadFile(file.Hash ?? "", Client.shared.v1?.downloadToken ?? ""), callbackQueue: nil, progress: nil) { result in
            
            switch result {
            case .success(let reponse):
                debugPrint("下载 file",resourceType,reponse.request ?? "")
                guard reponse.statusCode == 200 else {
                    return
                }
                
                PHPhotoLibrary.shared().performChanges({
                    
                    let options = PHAssetResourceCreationOptions()
                    let request = PHAssetCreationRequest.forAsset()
                    
                    request.addResource(with: resourceType, data: reponse.data, options: nil)
                    
                }) { result, error in
                    
                }
                
            case .failure(let error):
                assert(false,"error")
                
                break;
            }
        }
    }
    
    func downloadLivePhoto(imageFile:File, movFile: File,
                           completedHandler: @escaping (Bool,Error?) -> Void) {
        let group = DispatchGroup()
        
        let requestAssetQueue = DispatchQueue(label: "onelcat.github.io.download.asset", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        // 需要验证数据
        var imageData: Data?
        
        var movData: Data?
        
        var resultError: Error?
        
        group.enter()
        requestAssetQueue.async(group: group, execute: DispatchWorkItem.init(block: {
            
                Client.shared.api.requestNormal(.downloadFile(imageFile.Hash ?? "", Client.shared.v1?.downloadToken ?? ""), callbackQueue: nil, progress: nil) { result in
                    
                switch result {
                case .success(let reponse):
                    debugPrint("下载 image",reponse.request)
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
            
            Client.shared.api.requestNormal(.downloadFile(movFile.Hash ?? "",Client.shared.v1?.downloadToken ?? ""), callbackQueue: nil, progress: nil) { result in
                switch result {
                case .success(let reponse):
                    debugPrint("下载 video",reponse.request)
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
                    completedHandler(result,error)
                }
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
