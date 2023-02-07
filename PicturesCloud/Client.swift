//
//  API.swift
//  PicturesCloud
//
//  Created by haoshuai on 2023/2/1.
//

import Foundation
import Moya
import Photos
import RxSwift
import Alamofire
import ObjectMapper

public struct AlbumOptions:Mappable {
    
    var paramType: String = "album"
    var q: String = ""
    var count: Int = 24
    var offset: Int = 0
    var category: String = ""
    
    public init?(map: ObjectMapper.Map) {
        
    }
    
    public mutating func mapping(map: ObjectMapper.Map) {
        paramType <- map["paramType"]
        q <- map["q"]
        count <- map["count"]
        offset <- map["offset"]
        category <- map["category"]
    }
    
  
}

public struct PhotoOptions:Mappable {
    
    public init() {}
    
    public init?(map: ObjectMapper.Map) {
        
    }
    
    public mutating func mapping(map: ObjectMapper.Map) {
        count <- map["count"]
        offset <- map["offset"]
        albumUID <- map["albumUID"]
        filter <- map["filter"]
        merged <- map["merged"]
        country <- map["country"]
        camera <- map["camera"]
        order <- map["order"]
        q <- map["q"]
    }
    
    var count: Int = 60
    var offset: Int = 0
    var albumUID: String = ""
    var filter: String = ""
    var merged: Bool = true
    var country: String = ""
    var camera: Int = 0
    var order: String = "oldest"
    var q: String = ""
}

typealias PhotoID = Int

//protocol V1Client {
//    var downloadToken: String { get }
//    var token: String { get }
//}
//
//protocol Client {
//    var v1client: V1Client { get }
//    var contentType: String { get }
//    var connectionString: String { get }
//    func loginV1()
//}




public enum PhotoPrismAPI {
//
//    var v1: V1Client {
//        return V1Client()
//    }
//
    case login(String,String)
    
    
    case getConfig
    case getAlbums(AlbumOptions)
    case getAlbum(String)
    case createAlbum(Album)
    case updateAlbum(Album)
    case deleteAlbums([String])
    case likeAlbum(String)
    case dislikeAlbum(String)
    case cloneAlbum(Album)
    case addPhotosToAlbum(String,[String])
    case deletePhotosFromAlbum(String,[String])
    case getAlbumDownload(String,String)
    
    case _import
    
    case index
    case cancelIndex
    
    case getPhoto(String)
    case getPhotos(PhotoOptions)
    case updatePhoto(Photo)
    case getPhotoDownload(String,String)
    case getPhotoYaml(String)
    case approvePhoto(String)
    case likePhoto(String)
    case dislikePhoto(String)
    case photoPrimary(String,String)
    //POST /users/:uid/upload/:token
    case uploadUserFiles(Data,String,String)
    case uploadUserFilesP(String,String)
}


var down_token = ""
let API_ROOT = "http://127.0.0.1:2342"
//https://demo-zh.photoprism.app/api/v1/users/urpi8tzdfqwlfsgf/upload/xli9k9
extension PhotoPrismAPI: TargetType {
    public var baseURL: URL {
        
        guard let url = URL(string: API_ROOT) else {
            fatalError("root url error")
            return URL(string: "")!
        }
        
        
        return url
    }
    
    public var path: String {
        
        switch self {
        
        case .login(_, _):
            return "/api/v1/session"
        
        case .getConfig:
            return "/api/v1/config"
        
        case let .getAlbums(options):
//            let path = String(format:"/api/v1/albums?count=%d&offset=%d&q=%s&category=%s&type=%s", options.count, options.offset, options.q, options.category, options.paramType)
            return "/api/v1/albums"
        
        case let .getAlbum(uuid):
            return "/api/v1/albums/\(uuid)"
        
        case .createAlbum(_):
            return "/api/v1/albums"
        
        case let .updateAlbum(album):
            return "/api/v1/albums/\(album.AlbumUID)"
        
        case .deleteAlbums(_):
            return "/api/v1/batch/albums/delete"
        
        case .likeAlbum(let uuid):
            return "/api/v1/albums/\(uuid)/like"
        
        case .dislikeAlbum(let uuid):
            return "/api/v1/albums/\(uuid)/like"
        
        case .cloneAlbum(let album):
            return "/api/v1/albums/\(album.AlbumUID)/clone"
        
        case .addPhotosToAlbum(let albumUUID, _):
            return "/api/v1/albums/\(albumUUID)/photos"
        
        case .deletePhotosFromAlbum(let albumUUID, _):
            return "/api/v1/albums/\(albumUUID)/photos"
        
        case .getAlbumDownload(let uuid, _):
//            return "/api/v1/albums/\(uuid)/dl?t=/\(downloadToken)"
            return "/api/v1/albums/\(uuid)/dl"
        
        case ._import:
            return "/api/v1/import"
        
        case .index:
            return "/api/v1/index"
        
        case .cancelIndex:
            return "/api/v1/index"
        
        case .getPhoto(let uuid):
            return "/api/v1/photos/\(uuid)"
        
        case .getPhotos(let options):
            return  "/api/v1/photos"
        
        case .updatePhoto(let photo):
            return "/api/v1/photos/\(photo.UID)"
        
        case .getPhotoDownload(let uuid,let downloadToken):
//            return String(format: "/api/v1/photos/%s/dl?t=%s", uuid, downloadToken)
            return "/api/v1/photos/\(uuid)/dl"
        
        case .getPhotoYaml(let uuid):
            return "/api/v1/photos/\(uuid)/yaml"
        
        case .approvePhoto(let uuid):
            return "/api/v1/photos/\(uuid)/approve"
        
        case .likePhoto(let uuid):
            return "/api/v1/photos/\(uuid)/like"
        
        case .dislikePhoto(let uuid):
            return "/api/v1/photos/\(uuid)/approve"
            
        case let .photoPrimary(uuid, fileuuid):
            return "/api/v1/photos/\(uuid)/files/\(fileuuid)/primary"
//            return String(format: "/api/v1/photos/%s/files/%s/primary", uuid, fileuuid)

            //        http://127.0.0.1:2342/api/v1/users/urpl5sn1qmoiucq9/upload/u4lcl
//        http://127.0.0.1:2342/api/v1/users/urpl5sn1qmoiucq9/upload/u4lcl
        case let .uploadUserFiles(_, uuid, token):
            return "/api/v1/users/\(uuid)/upload/\(token)"
            
        case let .uploadUserFilesP(uuid, token):
            return "/api/v1/users/\(uuid)/upload/\(token)"
            
        }
        return "root"
    }
    
    public var method: Moya.Method {
        switch self {
        case .login(_, _):
            return .post
            
        case .getConfig:
            return .get
        case .getAlbums(_):
            return .get
        case .getAlbum(_):
            return .get
        case .createAlbum(_):
            return .post
        case .updateAlbum(_):
            return .put
        case .deleteAlbums(_):
            return .post
        case .likeAlbum(_):
            return .post
        case .dislikeAlbum(_):
            return .delete
        case .cloneAlbum(_):
            return .post
        case .addPhotosToAlbum(_, _), .deletePhotosFromAlbum(_, _):
            return .delete
        case .getAlbumDownload(_,_):
            return .get
        
        case ._import:
            return .post
        
        case .index:
            return .post
        case .cancelIndex:
            return .delete
            
        case .getPhoto(_):
            return .get
        case .getPhotos(_):
            return .get
        case .updatePhoto(_):
            return .put
        case .getPhotoDownload(_,_):
            return .get
        case .getPhotoYaml(_):
            return .get
        case .approvePhoto(_):
            return .post
        case .likePhoto(_):
            return .post
        case .dislikePhoto(_):
            return .delete
        case .photoPrimary(_, _):
            return .post
            
        
        case .uploadUserFiles(_, _, _):
            return .post
            
        case .uploadUserFilesP(_, _):
            return .put
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case let .login(username, password):
            let parameters = [
                "username": username,
                "password": password
            ]
            return .requestParameters(parameters: parameters, encoding:JSONEncoding())
            
        case let .getAlbums(options):
            let dis = options.toJSON()
            return .requestParameters(parameters: dis, encoding: URLEncoding.default)
        
        case .getAlbumDownload(_, let downloadToken):
            return .requestParameters(parameters: ["t":downloadToken], encoding: URLEncoding.default)
            
        case .getPhotoDownload(_,let downloadToken):
            return .requestParameters(parameters: ["t":downloadToken], encoding: URLEncoding.default)
            
        case .uploadUserFiles(let data, _, _):
            debugPrint("测试接口")
//            let testData = "hello my body text".data(using: .utf8)!
                
            let i = MultipartFormData.init(provider: MultipartFormData.FormDataProvider.data(data), name: "files",fileName: "pimage.jpeg", mimeType: "jpeg")
            let item = [i]
            debugPrint("上传数据", item)
            return .uploadMultipart(item)
//            let url = URL.init(fileURLWithPath: "/Users/haoshuai/Desktop/8C13A368-9FE6-4F3D-B379-CBAE5E662019_1_105_c.jpeg")
//            return .uploadFile(url)
        case .uploadUserFilesP(_, _):
            let parameters = [
                "albums": []
            ]
            return .requestParameters(parameters: parameters, encoding:JSONEncoding())
        case let .getPhotos(options):
            // 这里根据请求的方法 判断数据在哪里个位置
            let dis = options.toJSON()
            return .requestParameters(parameters: dis, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
        
    }
        
    public var headers: [String : String]? {
        switch self {
        case .login(_, _):
            return [
                "accept": "application/json, text/plain, */*",
                "content-type":"application/json; charset=utf-8"
            ]
        case .uploadUserFiles(_, _, _):
            return [
                "Accept": "application/json, text/plain, */*",
                "X-Session-Id": Client.shared.v1!.token,
            ]
        default:
            return [
                "Accept": "application/json, text/plain, */*",
                "Content-Type":"application/json; charset=utf-8",
                "X-Session-Id": Client.shared.v1!.token
            ]
        }
        
    }
    
    
}



class Client {
    
    struct V1Client {
        let downloadToken: String
        let token: String
    }
    
    static let shared = Client()
    
    var api = MoyaProvider<PhotoPrismAPI>()
    
    var v1: V1Client?
    var userID: String?
    var previewToken : String?
    init() {}
    
    static func rxLogin(username: String, password: String) ->Single<String> {
        
//        switch result {
//        case let .success(response):
//            single(.success(response))
//        case let .failure(error):
//            single(.failure(error))
//        }
        
        return Single.create { single in
            
            Client.shared.api.requestNormal(.login(username, password), callbackQueue: nil, progress: nil) { result in
                switch result {
                case .success(let reponse):

                    guard let jsonStr = String(data: reponse.data, encoding: String.Encoding.utf8),
                          let headers = reponse.response?.headers,reponse.statusCode == 200
                    else {
                        let msg = String(data: reponse.data, encoding: String.Encoding.utf8)
                        let error = NSError(domain: msg ?? "未知错误", code: reponse.statusCode)
                        single(.failure(error))
                        return
                    }

                    let config = Mapper<Config>().map(JSONString: jsonStr)
                    
                    guard let downloadToken = config?.config?.downloadToken,
                          let token = headers["X-Session-Id"]
                    else {
                        let error = NSError(domain: "获取token失败", code: 10001)
                        single(.failure(error))
                        return
                    }
                    Client.shared.previewToken = config?.config?.previewToken
                    
                    Client.shared.userID = config?.userID
                    Client.shared.v1 = V1Client(downloadToken: downloadToken, token: token)
                    single(.success("登录成功"))
                    debugPrint("登录成功", Client.shared.userID,downloadToken,token,Client.shared.previewToken)
                case .failure(let error):
                    single(.failure(error))
                    assert(false,String())
    //                assert(false,error)
                    
                    debugPrint(error)
                }
                
            }
            return Disposables.create { }

            
        }
        
    }
    
    static func login(username: String, password: String) {
    
        Client.shared.api.requestNormal(.login(username, password), callbackQueue: nil, progress: nil) { result in
            switch result {
            case .success(let reponse):

                guard let jsonStr = String(data: reponse.data, encoding: String.Encoding.utf8),
                      let headers = reponse.response?.headers,reponse.statusCode == 200
                else {
                    
                    return
                }

                let config = Mapper<Config>().map(JSONString: jsonStr)
                
                guard let downloadToken = config?.config?.downloadToken,
                      let token = headers["X-Session-Id"]
                else {
                    return
                }
                Client.shared.userID = config?.userID
                Client.shared.previewToken = config?.config?.previewToken
                Client.shared.v1 = V1Client(downloadToken: downloadToken, token: token)
                debugPrint("登录成功", Client.shared.userID,downloadToken,token)
            case .failure(let error):
                assert(false,String())
//                assert(false,error)
                debugPrint(error)
            }
        }
    }
    
}

// TODO: 登录

// TODO: 获取相册

// TODO: 上传照片

// TODO: 下载照片


// 数据管理协议

protocol PhotoAsset {
    var identifier: String {get}
    var mediaType: PHAssetMediaType {get}
    var mediaSubtypes: PHAssetMediaSubtype {get}
    var pixelWidth: Int {get}
    var pixelHeight: Int {get}
    var creationDate: Date? {get}
    var location: CLLocation?{get}
    var duration: Double {get}
}

//class CPhotoAsset:PhotoAsset {
//    // 传入json 对象进行数据解析
//}

class LPhotoAsset:PhotoAsset {
    
    let asset: PHAsset
  
    var identifier: String {
        return asset.localIdentifier
    }

    var mediaType: PHAssetMediaType {
        return asset.mediaType
    }
    
    var mediaSubtypes: PHAssetMediaSubtype {
        return asset.mediaSubtypes
    }

    var pixelWidth: Int {
        return asset.pixelWidth
    }

    var pixelHeight: Int {
        return asset.pixelHeight
    }

    var creationDate: Date? {
        return asset.creationDate
    }

    var location: CLLocation? {
        return asset.location
    }

    var duration: Double {
        return asset.duration
    }
    
    // Resource
    var assetResource:[PHAssetResource] = []
    
    init(asset: PHAsset) {
        self.asset = asset
    }
    
    // 读取本地封面
    
    // 读取所有的资源数据
    
    // 上传数据
    
}
