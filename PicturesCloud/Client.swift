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
public struct AlbumOptions {
    var paramType: String = "album"
    var q: String = ""
    var count: Int = 24
    var offset: Int = 0
    var category: String = ""
}

public struct PhotoOptions{
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
}


var down_token = ""
//https://demo-zh.photoprism.app/api/v1/users/urpi8tzdfqwlfsgf/upload/xli9k9
extension PhotoPrismAPI: TargetType {
    public var baseURL: URL {
        
        guard let url = URL(string: "http://127.0.0.1:2342") else {
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
            let path = String(format:"/api/v1/albums?count=%d&offset=%d&q=%s&category=%s&type=%s", options.count, options.offset, options.q, options.category, options.paramType)
            return path
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
        case .getAlbumDownload(let uuid, let downloadToken):
            return "/api/v1/albums/\(uuid)/dl?t=/\(downloadToken)"
        case ._import:
            return "/api/v1/import"
        case .index:
            return "/api/v1/index"
        case .cancelIndex:
            return "/api/v1/index"
        case .getPhoto(let uuid):
            return "/api/v1/photos/\(uuid)"
        case .getPhotos(let options):
//            return ""
       // https://demo-zh.photoprism.app/api/v1/albums?count=24&offset=0&q=&category=&order=favorites&year=&type=album
            return  "/api/v1/albums?count=24&offset=0&q=&category=&order=favorites&year=&type=album"
            return  "/api/v1/photos?count=60&offset=0"
            return String(format: "api/v1/photos?count=%d&offset=%d&album=%s&filter=%s&merged=%t&country=%s&camera=%d&order=%s&q=%s",
                          options.count, options.offset, options.albumUID, options.filter, options.merged, options.country, options.camera, options.order, options.q)
        case .updatePhoto(let photo):
            return "/api/v1/photos/\(photo.PhotoUID)"
        case .getPhotoDownload(let uuid,let downloadToken):
            return String(format: "/api/v1/photos/%s/dl?t=%s", uuid, downloadToken)
        case .getPhotoYaml(let uuid):
            return "/api/v1/photos/\(uuid)/yaml"
        case .approvePhoto(let uuid):
            return "/api/v1/photos/\(uuid)/approve"
        case .likePhoto(let uuid):
            return "/api/v1/photos/\(uuid)/like"
        case .dislikePhoto(let uuid):
            return "/api/v1/photos/\(uuid)/approve"
        case let .photoPrimary(uuid, fileuuid):
            return String(format: "/api/v1/photos/%s/files/%s/primary", uuid, fileuuid)
            
        case let .uploadUserFiles(_, uuid, token):
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
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case let .login(username, password):
            let parameters = [
                "username":username,
                "password":password
            ]
            return .requestParameters(parameters: parameters, encoding:JSONEncoding())
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
        default:
            return [
                "accept": "application/json, text/plain, */*",
                "content-type":"application/json; charset=utf-8",
                "x-session-id": "234200000000000000000000000000000000000000000000"
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
    
    init() {}
    
    static func login(username: String, password: String) {
    
        Client.shared.api.requestNormal(.login(username, password), callbackQueue: nil, progress: nil) { result in
            switch result {
            case .success(let reponse):

                guard let jsonStr = String(data: reponse.data, encoding: String.Encoding.utf8),
                      let headers = reponse.response?.headers,reponse.statusCode == 200
                      
                else {
                    return
                }

//                let token = headers["X-Session-Id"]
                let config = Mapper<Config>().map(JSONString: jsonStr)
//                debugPrint("login result", config?.config?.downloadToken ?? "errror", token)
                
                guard let downloadToken = config?.config?.downloadToken,
                      let token = headers["X-Session-Id"]
                else {
                    return
                }
                
                Client.shared.v1 = V1Client(downloadToken: downloadToken, token: token)
                
            case .failure(let error):
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
