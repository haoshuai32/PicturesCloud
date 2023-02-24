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
//    let token: (String,String)
    private let dataSource: DownloadAsset
    
    
    private let delegate: DownloadOperationDelegate
    
    init(data: DownloadAsset,delegate: DownloadOperationDelegate) {
//        self.token = data
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

        self.delegate.downloadData(data: self.dataSource) { result, error in
            debugPrint("下载完成", result,error)
            completed()
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
    let session = URLSession(configuration: URLSessionConfiguration.default)
    static let shared = DownloadManager()
    
    private var downloadDataSource: NSCache<NSString,DownloadAsset> = NSCache<NSString,DownloadAsset>()
    
    private var downloadSuccess: [DownloadAsset] = []
    private var downloadFailure: [DownloadAsset] = []
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
    
    private var downloadingDataSource: DownloadAsset?

    private var downloadingCompletedHandler: ((Bool,Error?) -> Void)?
    
    lazy var uploadOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    
    func downloadData(data: DownloadAsset,
                      completedHandler: @escaping (Bool,Error?) -> Void) {
        self.downloadingDataSource = data

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
                
                downloadLivePhoto(imageFile: imageFile,
                                  movFile: movFile,
                                  completedHandler: completedHandler)

            } else {
                assert(false)
            }
            
        }
        
        else if data.PhotoType == .video {
            var file: File!
            for item in data.Files {
                if item.MediaType == .video {
                    file = item
                }
            }
            downloadFile(file, resourceType: .video, completedHandler: completedHandler)
            
        }
        else if data.PhotoType == .gif {
            var file: File!
            for item in data.Files {
                if item.FileType == .gif {
                    file = item
                }
            }
            downloadFile(file, resourceType: .fullSizePhoto, completedHandler: completedHandler)
        } else if data.PhotoType == .image {
            var file: File!
            for item in data.Files {
                if item.FileType == .jpg {
                    file = item
                }
            }
            downloadFile(file, resourceType: .photo, completedHandler: completedHandler)
        }
        
    }
    
    func downloadFile(_ file:File,resourceType: PHAssetResourceType,
                      completedHandler: @escaping (Bool,Error?) -> Void) {
        
        
        let url = "http://127.0.0.1:2342/api/v1/dl/\(file.Hash!)?t=\(Client.shared.v1!.downloadToken)"
        
        debugPrint("下载文件",url,resourceType)
        
        let request = try! URLRequest(url: URL(string: url)!, method: .get)
        let downloadTask = self.session.downloadTask(with: request) { tempURL, reponse, error in
            
            if let tURL = tempURL,
               let rs = reponse as? HTTPURLResponse,
               rs.statusCode == 200,
               let cd = rs.headers.value(for: "Content-Disposition") {
                
                var filename = cd.split(separator: " ")[1].split(separator: "=")[1]
                filename.removeFirst()
                filename.removeLast()

                let tmpURL =  HFileManager.shared.downloadDirectory.appendingPathComponent(String(filename))
                
                if(FileManager.default.fileExists(atPath: tmpURL.path)) {
                    try! FileManager.default.removeItem(at: tmpURL)
                }
                
                try! FileManager.default.moveItem(at: tURL, to: tmpURL)
                debugPrint("缓存文件",tURL,tmpURL);
                LocalAssetManager.writeFile(type: resourceType, file: tmpURL, completionHandler: completedHandler)
            } else if let error = error {
                completedHandler(false,error)
            } else {
                assert(false)
            }
        }
        downloadTask.resume()
    }
    
    func downloadLivePhoto(imageFile:File, movFile: File,
                           completedHandler: @escaping (Bool,Error?) -> Void) {
        
        var tmpImgURL: URL?
        var tmpMovURL: URL?
        let group = DispatchGroup()
        
        let requestAssetQueue = DispatchQueue(label: "onelcat.github.io.download.asset", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        // 需要验证数据
        var imageData: Data?
        
        var movData: Data?
        
        var resultError: Error?
        
        group.enter()
        requestAssetQueue.async(group: group, execute: DispatchWorkItem.init(block: {
            
            let url = "http://127.0.0.1:2342/api/v1/dl/\(imageFile.Hash!)?t=\(Client.shared.v1!.downloadToken)"
            let request = try! URLRequest(url: URL(string: url)!, method: .get)
            let downloadTask = self.session.downloadTask(with: request) { tmpURL, reponse, error in
                
                if let tURL = tmpURL,
                   let rs = reponse as? HTTPURLResponse,
                   rs.statusCode == 200,
                   let cd = rs.headers.value(for: "Content-Disposition") {
                    
                    var filename = cd.split(separator: " ")[1].split(separator: "=")[1]
                    filename.removeFirst()
                    filename.removeLast()

                    tmpImgURL =  HFileManager.shared.downloadDirectory.appendingPathComponent(String(filename))
                    
                    if(FileManager.default.fileExists(atPath: tmpImgURL!.path)) {
                        try! FileManager.default.removeItem(at: tmpImgURL!)
                    }
                    
                    try! FileManager.default.moveItem(at: tURL, to: tmpImgURL!)
                    
                }
                resultError = error
                group.leave()
            }
            downloadTask.resume()

        }))
        
        group.enter()
        requestAssetQueue.async(group: group, execute: DispatchWorkItem.init(block: {
            
            
            let url = "http://127.0.0.1:2342/api/v1/dl/\(movFile.Hash!)?t=\(Client.shared.v1!.downloadToken)"
            let request = try! URLRequest(url: URL(string: url)!, method: .get)
            let downloadTask = self.session.downloadTask(with: request) { tmpURL, reponse, error in
                if let tURL = tmpURL,
                   let rs = reponse as? HTTPURLResponse,
                   rs.statusCode == 200,
                   let cd = rs.headers.value(for: "Content-Disposition") {
                    
                    var filename = cd.split(separator: " ")[1].split(separator: "=")[1]
                    filename.removeFirst()
                    filename.removeLast()
                    
                    tmpMovURL =  HFileManager.shared.downloadDirectory.appendingPathComponent(String(filename))
                    
                    if(FileManager.default.fileExists(atPath: tmpMovURL!.path)) {
                        try! FileManager.default.removeItem(at: tmpMovURL!)
                    }
                    
                    try! FileManager.default.moveItem(at: tURL, to: tmpMovURL!)
                    
                }
                resultError = error
                group.leave()
            }
            downloadTask.resume()

        }))
        
        group.notify(queue: requestAssetQueue, work: .init(block: {
            // 返回数据
            if let error = resultError {
//                        assert(false,)
                fatalError(error.localizedDescription)
            } else {
                // 写入数据
                                
//                debugPrint("开始写入数据", HFileManager.shared.tempImg)
                LocalAssetManager.writePhotoLive(
                    lievPhoto: (imgPath: tmpImgURL!,
                                movPath: tmpMovURL!),
                    completionHandler: completedHandler)

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
    func start(data: [DownloadAsset]) {
        self.beginConfig()
        for item in data {
            let operation = DownloadOperation(data: item, delegate: self)
            self.downloadDataSource.setObject(item, forKey: item.UID! as NSString)
            uploadOperationQueue.addOperation(operation)
        }
        uploadOperationQueue.addBarrierBlock { [weak self] in
            debugPrint("照片下载完成")
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
