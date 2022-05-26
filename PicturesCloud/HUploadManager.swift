//
//  HUploadManager.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import Foundation
import Photos

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

// TODO: 后续实现 - 查看上传进度

public class HUploadManager:HUploadOperationDelegate {
    
    private let queue = DispatchQueue(label: "onelcat.github.io.upload.queue")
    
//    private let boundary = "----WebKitFormBoundaryT4baV8VlU7B1wMXq"
    private
    lazy var boundary: String = {
        return Self.randomBoundary()
    }()
    
    static let shared = HUploadManager()
    
    private var dataSource: [LocalPictureModel] = []
    
    private var uploadingIndex: Int?
    
    static func randomBoundary() -> String {
        let first = UInt32.random(in: UInt32.min...UInt32.max)
        let second = UInt32.random(in: UInt32.min...UInt32.max)

        return String(format: "onelcat.github.io.boundary.%08x%08x", first, second)
    }
    
    lazy var sessionConfigure: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
//        config.httpAdditionalHeaders = ["Content-Type": "multipart/form-data; boundary=\(boundary)"]
        config.timeoutIntervalForRequest = 120
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        return config
    }()
    
    lazy var session: URLSession = {
        return URLSession(configuration: sessionConfigure, delegate: nil, delegateQueue: nil)
    }()
    
    // 表单上传数据 // 多文件上传数据
    private func uploadPicture(picture:LocalPictureModel) {
        
    }
    
    // 读取数据
    private func readPicture(picture:LocalPictureModel) {
        
    }
    
    func uploadData(data: LocalPictureModel,resultHandler: @escaping (_ result: Result<[AnyHashable : Any],Error>) -> Void) {
        
        let uploadAsset = data
        
        
        func upload(fileData: Data,fileName: String,type: String,uti:String) {
            
            let crlf = "\r\n"
            let initial = "\(boundary)\(crlf)"
            let final = "\(crlf)\(boundary)--\(crlf)"
            var bodyData = Data()
            let contentDisposition: String
            contentDisposition = "Content-Disposition: form-data; name=\"myFile\"; filename=\"\(fileName)\"\(crlf)Content-Type: image/gif\(crlf)\(crlf)"
            
            guard let initialData = initial.data(using: .utf8),
                let finalData = final.data(using: .utf8),
                let contentDispositionData = contentDisposition.data(using: .utf8) else {
                fatalError()
                return
            }
            
            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition: form-data; name=\"myFile\"; filename=\"\(fileName)\"; uti=\"com.compuserve.gif\"\r\n".data(using: .utf8)!)
            bodyData.append("Content-Type: image/gif\r\n\r\n".data(using: .utf8)!)
            bodyData.append(fileData)
            
            bodyData.append("\r\n".data(using: .utf8)!)

            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition: form-data; name=\"myFile\"; filename=\"IMG_3143.GIF\"\r\n".data(using: .utf8)!)
            bodyData.append("Content-Type: image/gif\r\n\r\n".data(using: .utf8)!)
            bodyData.append(fileData)
            
            // end data
            bodyData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
          
            let url: URL = URL(string: "http://192.168.1.5:8888/upload")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let task = session.uploadTask(with: urlRequest, from: bodyData) { (data, response, error) in
                if let error = error {
                    fatalError()
                    return
                }
                guard let data = data else {
                    fatalError()
                    return
                }
                let responseString = String.init(data: data, encoding: .utf8)
                print("上传完成", responseString)
            }
        
            task.resume()
        }
        
        func readData() {
            let asset = uploadAsset.asset
            
            let resources = PHAssetResource.assetResources(for: asset)
            uploadAsset.assetResource = resources
            
            var resultData = Array<Data>.init(repeating: Data(), count: resources.count)
            
            let queue = DispatchQueue(label: "onelcat.github.io.requestAssetData", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
            
            let group = DispatchGroup()
            var resultError: Error?
            for i in 0..<resources.count {
                debugPrint("resouce \(i) \(resources[i])")
                group.enter()
                queue.async(group: group, execute: DispatchWorkItem.init(block: {
                    let index = i
                    let resource = resources[i]
                    var itemData = Data()
                    PHAssetResourceManager.default().requestData(for: resource, options: nil) { data in
                        itemData.append(data)
                    } completionHandler: { error in
                        if let error = error {
                            resultError = error
                            debugPrint("PHAssetResourceManager requestData error:",error)
                        } else {
                            resultData[index] = itemData
                        }
                        group.leave()
                    }
                }))
            }
        
            group.notify(queue: queue, work: .init(block: {
                // 返回数据
                if let error = resultError {
//                    resultHandler(.failure(error))
                    fatalError()
                } else {
                    var type = ""
                    switch resources[0].type {
                        
                    case .photo:
                        type = "photo"
                    case .video:
                        type = "video"
                    case .audio:
                        type = "audio"
                    case .alternatePhoto:
                        type = "alternatePhoto"
                    case .fullSizePhoto:
                        type = "fullSizePhoto"
                    case .fullSizeVideo:
                        type = "fullSizeVideo"
                    case .adjustmentData:
                        type = "adjustmentData"
                    case .adjustmentBasePhoto:
                        type = "adjustmentBasePhoto"
                    case .pairedVideo:
                        type = "pairedVideo"
                    case .fullSizePairedVideo:
                        type = "fullSizePairedVideo"
                    case .adjustmentBasePairedVideo:
                        type = "adjustmentBasePairedVideo"
                    case .adjustmentBaseVideo:
                        type = "adjustmentBaseVideo"
                    @unknown default:
                        type = "photo"
                    }
                    print(type,resources[0].uniformTypeIdentifier)
                    upload(fileData: resultData[0], fileName: resources[0].originalFilename,type: type,uti: resources[0].uniformTypeIdentifier)
                }
                
            }))
            
//            return true
        }
        readData()
        
        
        
        // 读取数据
        
        // 表单上传数据
    }
    
    
    // 实现消息队列
        
    
}
