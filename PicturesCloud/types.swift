//
//  types.swift
//  PicturesCloud
//
//  Created by haoshuai on 2023/2/1.
//

import Foundation
import ObjectMapper

struct User:Mappable {
    init?(map: ObjectMapper.Map) {
        
    }
    mutating func mapping(map: ObjectMapper.Map) {
        userID <- map["UID"]
    }
    var userID: String?
}

struct ThumbSize: Mappable {
    var size: String?
    var use: String?
    var w: Int = 0
    var h: Int = 0
    init?(map: Map) {

    }
    mutating func mapping(map: Map) {
        size <- map["size"]
        use <- map["use"]
        w <- map["w"]
        h <- map["h"]
    }
}

struct Options: Mappable {
    var name: String?
    var version: String?
    var copyright: String?
    var downloadToken: String?
    var previewToken: String?
    static var thumbSize = "fit_720"
    var thumbs: [ThumbSize] = []
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        name     <- map["name"]
        version     <- map["version"]
        copyright     <- map["copyright"]
        downloadToken     <- map["downloadToken"]
        
        previewToken <- map["previewToken"]
    
        thumbs <- map["thumbs"]
    }
}

struct Config: Mappable {
    init?(map: ObjectMapper.Map) {
        
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        config     <- map["config"]
        userID <- map["user.UID"]
    }
    
    var config: Options?
    var userID: String?
}

enum PhotoType:String {
    case live = "live"
    case image = "image"
    case video = "video"
    case gif = "animated"
}

//type Photos []Photo
typealias Photos = [Photo]
// Photo represents a photo, all its properties, and link to all its images and sidecar files.
public struct Photo: Mappable  {
    
    public init?(map: ObjectMapper.Map) {
        
    }
    
    public mutating func mapping(map: ObjectMapper.Map) {
        ID <- map["ID"]
        UID <- map["UID"]
        PhotoType <- (map["Type"],EnumTransform<PhotoType>())
        TypeSrc <- map["TypeSrc"]
        TakenAt <- map["TakenAt"]
        TakenAtLocal <- map["TakenAtLocal"]
        TakenSrc <- map["TakenSrc"]
        TimeZone <- map["TimeZone"]
        Path <- map["Path"]
        Name <- map["Name"]
        OriginalName <- map["OriginalName"]
        Title <- map["Title"]
        Description <- map["Description"]
        Year <- map["Year"]
        Month <- map["Month"]
        Day <- map["Day"]
        Country <- map["Country"]
        Stack <- map["Stack"]
        Favorite <- map["Favorite"]
        Private <- map["Private"]
        Iso <- map["Iso"]
        FocalLength <- map["FocalLength"]
        FNumber <- map["FNumber"]
        Exposure <- map["Exposure"]
        Quality <- map["Quality"]
        Resolution <- map["Resolution"]
        Color <- map["Color"]
        Scan <- map["Scan"]
        Panorama <- map["Panorama"]
        CameraID <- map["CameraID"]
        CameraSrc <- map["CameraSrc"]
        CameraModel <- map["CameraModel"]
        CameraMake <- map["CameraMake"]
        LensID <- map["LensID"]
        LensModel <- map["LensModel"]
        Lat <- map["Lat"]
        Lng <- map["Lng"]
        CellID <- map["CellID"]
        PlaceID <- map["PlaceID"]
        PlaceSrc <- map["PlaceSrc"]
        PlaceLabel <- map["PlaceLabel"]
        PlaceCity <- map["PlaceCity"]
        PlaceState <- map["PlaceState"]
        PlaceCountry <- map["PlaceCountry"]
        InstanceID <- map["InstanceID"]
        FileUID <- map["FileUID"]
        FileRoot <- map["FileRoot"]
        FileName <- map["FileName"]
        Hash <- map["Hash"]
        Width <- map["Width"]
        Height <- map["Height"]
        Portrait <- map["Portrait"]
        Merged <- map["Merged"]
        CreatedAt <- map["CreatedAt"]
        UpdatedAt <- map["UpdatedAt"]
        EditedAt <- map["EditedAt"]
        CheckedAt <- map["CheckedAt"]
        DeletedAt <- map["DeletedAt"]
        Files <- map["Files"]
    }
    
    var ID: String?
    var UID: String?
    var PhotoType: PhotoType = .image
    var TypeSrc: String?
    var TakenAt: String?
    var TakenAtLocal: String?
    var TakenSrc: String?
    var TimeZone: String?
    var Path: String?
    var Name: String?
    var OriginalName: String?
    var Title: String?
    var Description: String?
    var Year: Int = 0
    var Month: Int = 0
    var Day: Int = 0
    var Country: String?
    var Stack: Int = 0
    var Favorite: Bool = false
    var Private: Bool = false
    var Iso: Int = 0
    var FocalLength: Int = 0
    var FNumber: Int = 0
    var Exposure: String?
    var Quality: Int = 0
    var Resolution: Int = 0
    var Color: Int = 0
    var Scan: Bool = false
    var Panorama: Bool = false
    var CameraID: Int = 0
    var CameraSrc: String?
    var CameraModel: String?
    var CameraMake: String?
    var LensID: Int = 0
    var LensModel: String?
    var Lat: Int = 0
    var Lng: Int = 0
    var CellID: String?
    var PlaceID: String?
    var PlaceSrc: String?
    var PlaceLabel: String?
    var PlaceCity: String?
    var PlaceState: String?
    var PlaceCountry: String?
    var InstanceID: String?
    var FileUID: String?
    var FileRoot: String?
    var FileName: String?
    var Hash: String?
    var Width: Int = 0
    var Height: Int = 0
    var Portrait: Bool = false
    var Merged: Bool = false
    var CreatedAt: String?
    var UpdatedAt: String?
    var EditedAt: String?
    var CheckedAt: String?
    var DeletedAt: String?
    var Files: [File] = []
    var Duration: Int {
        if Files.count == 2 , PhotoType == .video {
//            27000000000
            return Files[1].Duration / 1000000000
        }
        return 0
    }
    var previewURL: URL {
        let root = API_ROOT + "/api/v1/t/"
        guard let hash = Hash, let toekn = Client.shared.previewToken
        else {
            fatalError()
            return URL.init(fileURLWithPath: "")
        }
        let urlStr = root + hash + "/" + toekn + "/" + Options.thumbSize
        
        guard let url = URL(string: urlStr) else {
            fatalError()
            return URL.init(fileURLWithPath: "")
        }
        return url
    }
    
}

typealias Files = [File]

// File represents an image or sidecar file that belongs to a photo.
public struct File: Mappable  {
    
    
    public init?(map: ObjectMapper.Map) {
        
    }
    
    public mutating func mapping(map: ObjectMapper.Map) {
        UID <- map["UID"]
        FileUID <- map["FileUID"]
        Name <- map["Name"]
        Root <- map["Root"]
        OriginalName <- map["OriginalName"]
        Hash <- map["Hash"]
        Size <- map["Size"]
        Codec <- map["Codec"]
        FileType <- map["FileType"]
        Mime <- map["Mime"]
        Primary <- map["Primary"]
        FileSidecar <- map["FileSidecar"]
        FileMissing <- map["FileMissing"]
        FilePortrait <- map["FilePortrait"]
        Video <- map["Video"]
        Duration <- map["Duration"]
        Width <- map["Width"]
        Height <- map["Height"]
        Orientation <- map["Orientation"]
        FileProjection <- map["FileProjection"]
        AspectRatio <- map["AspectRatio"]
        FileMainColor <- map["FileMainColor"]
        Colors <- map["Colors"]
        Luminance <- map["Luminance"]
        Diff <- map["Diff"]
        Chroma <- map["Chroma"]
        FileError <- map["FileError"]
        ModTime <- map["ModTime"]
        CreatedAt <- map["CreatedAt"]
        CreatedIn <- map["CreatedIn"]
        UpdatedAt <- map["UpdatedAt"]
        UpdatedIn <- map["UpdatedIn"]
        DeletedAt <- map["DeletedAt"]
    }
    
    /// `gorm:"primary_key" json:"-" yaml:"-"`
    var UID : String?
    /// `json:"-" yaml:"-"`
//    var Photo           :Photo?
    /// `gorm:"index;" json:"-" yaml:"-"`
//    var PhotoID : UInt?
    /// `gorm:"type:VARBINARY(42);index;" json:"PhotoUID" yaml:"PhotoUID"`
    var PhotoUID : String?
    /// `gorm:"type:VARBINARY(42);index;" json:"InstanceID,omitempty" yaml:"InstanceID,omitempty"`
//    var InstanceID : String?
    /// `gorm:"type:VARBINARY(42);unique_index;" json:"UID" yaml:"UID"`
    var FileUID : String?
    /// `gorm:"type:VARBINARY(755);unique_index:idx_files_name_root;" json:"Name" yaml:"Name"`
    var Name : String?
    /// `gorm:"type:VARBINARY(16);default:'/';unique_index:idx_files_name_root;" json:"Root" yaml:"Root,omitempty"`
    var Root : String?
    /// `gorm:"type:VARBINARY(755);" json:"OriginalName" yaml:"OriginalName,omitempty"`
    var OriginalName : String?
    /// `gorm:"type:VARBINARY(128);index" json:"Hash" yaml:"Hash,omitempty"`
    var Hash : String?
    /// `json:"Size" yaml:"Size,omitempty"`
    var Size : Int64?
    /// `gorm:"type:VARBINARY(32)" json:"Codec" yaml:"Codec,omitempty"`
    var Codec : String?
    /// `gorm:"type:VARBINARY(32)" json:"Type" yaml:"Type,omitempty"`
    var FileType : String?
    /// `gorm:"type:VARBINARY(64)" json:"Mime" yaml:"Mime,omitempty"`
    var Mime : String?
    /// `json:"Primary" yaml:"Primary,omitempty"`
    var Primary : Bool = false
    /// `json:"Sidecar" yaml:"Sidecar,omitempty"`
    var FileSidecar : Bool?
    /// `json:"Missing" yaml:"Missing,omitempty"`
    var FileMissing : Bool?
    /// `json:"Portrait" yaml:"Portrait,omitempty"`
    var FilePortrait : Bool?
    /// `json:"Video" yaml:"Video,omitempty"`
    var Video : Bool = false
    /// `json:"Duration" yaml:"Duration,omitempty"`
    var Duration    :Int = 0
    /// `json:"Width" yaml:"Width,omitempty"`
    var Width : Int?
    /// `json:"Height" yaml:"Height,omitempty"`
    var Height : Int?
    /// `json:"Orientation" yaml:"Orientation,omitempty"`
    var Orientation : Int?
    /// `gorm:"type:VARBINARY(16);" json:"Projection,omitempty" yaml:"Projection,omitempty"`
    var FileProjection : String?
    /// `gorm:"type:FLOAT;" json:"AspectRatio" yaml:"AspectRatio,omitempty"`
    var AspectRatio : Float32?
    /// `gorm:"type:VARBINARY(16);index;" json:"MainColor" yaml:"MainColor,omitempty"`
    var FileMainColor : String?
    /// `gorm:"type:VARBINARY(9);" json:"Colors" yaml:"Colors,omitempty"`
    var Colors : String?
    /// `gorm:"type:VARBINARY(9);" json:"Luminance" yaml:"Luminance,omitempty"`
    var Luminance : String?
    /// `json:"Diff" yaml:"Diff,omitempty"`
    var Diff        :UInt32?
    /// `json:"Chroma" yaml:"Chroma,omitempty"`
    var Chroma:UInt8?
    /// `gorm:"type:VARBINARY(512)" json:"Error" yaml:"Error,omitempty"`
    var FileError : String?
    /// `json:"ModTime" yaml:"-"`
    var ModTime : Int64?
    /// `json:"CreatedAt" yaml:"-"`
    var CreatedAt : Date?
    /// `json:"CreatedIn" yaml:"-"`
    var CreatedIn : Int64?
    /// `json:"UpdatedAt" yaml:"-"`
    var UpdatedAt : Date?
    /// `json:"UpdatedIn" yaml:"-"`
    var UpdatedIn : Int64?
    /// `sql:"index" json:"DeletedAt,omitempty" yaml:"-"`
    var DeletedAt : Date?
    /// `json:"-" yaml:"-"`
    var Share           :[FileShare] = []
    /// `json:"-" yaml:"-"`
    var Sync            :[FileSync] = []
}

// Details stores additional metadata fields for each photo to improve search performance.
struct Details  {
    /// `gorm:"primary_key;auto_increment:false" yaml:"-"`
    var PhotoID : UInt?
    /// `gorm:"type:TEXT;" json:"Keywords" yaml:"Keywords"`
    var Keywords : String?
    /// `gorm:"type:VARBINARY(8);" json:"KeywordsSrc" yaml:"KeywordsSrc,omitempty"`
    var KeywordsSrc : String?
    /// `gorm:"type:TEXT;" json:"Notes" yaml:"Notes,omitempty"`
    var Notes : String?
    /// `gorm:"type:VARBINARY(8);" json:"NotesSrc" yaml:"NotesSrc,omitempty"`
    var NotesSrc : String?
    /// `gorm:"type:VARCHAR(255);" json:"Subject" yaml:"Subject,omitempty"`
    var Subject : String?
    /// `gorm:"type:VARBINARY(8);" json:"SubjectSrc" yaml:"SubjectSrc,omitempty"`
    var SubjectSrc : String?
    /// `gorm:"type:VARCHAR(255);" json:"Artist" yaml:"Artist,omitempty"`
    var Artist : String?
    /// `gorm:"type:VARBINARY(8);" json:"ArtistSrc" yaml:"ArtistSrc,omitempty"`
    var ArtistSrc : String?
    /// `gorm:"type:VARCHAR(255);" json:"Copyright" yaml:"Copyright,omitempty"`
    var Copyright : String?
    /// `gorm:"type:VARBINARY(8);" json:"CopyrightSrc" yaml:"CopyrightSrc,omitempty"`
    var CopyrightSrc : String?
    /// `gorm:"type:VARCHAR(255);" json:"License" yaml:"License,omitempty"`
    var License : String?
    /// `gorm:"type:VARBINARY(8);" json:"LicenseSrc" yaml:"LicenseSrc,omitempty"`
    var LicenseSrc : String?
    /// `yaml:"-"`
    var CreatedAt : Date?
    /// `yaml:"-"`
    var UpdatedAt : Date?
}

// Camera model and make (as extracted from UpdateExif metadata)
struct Camera  {
    /// `gorm:"primary_key" json:"ID" yaml:"ID"`
    var ID : UInt?
    /// `gorm:"type:VARBINARY(255);unique_index;" json:"Slug" yaml:"-"`
    var CameraSlug : String?
    /// `gorm:"type:VARCHAR(255);" json:"Name" yaml:"Name"`
    var CameraName : String?
    /// `gorm:"type:VARCHAR(255);" json:"Make" yaml:"Make,omitempty"`
    var CameraMake : String?
    /// `gorm:"type:VARCHAR(255);" json:"Model" yaml:"Model,omitempty"`
    var CameraModel : String?
    /// `gorm:"type:VARCHAR(255);" json:"Type,omitempty" yaml:"Type,omitempty"`
    var CameraType : String?
    /// `gorm:"type:TEXT;" json:"Description,omitempty" yaml:"Description,omitempty"`
    var CameraDescription : String?
    /// `gorm:"type:TEXT;" json:"Notes,omitempty" yaml:"Notes,omitempty"`
    var CameraNotes : String?
    /// `json:"-" yaml:"-"`
    var CreatedAt : Date?
    /// `json:"-" yaml:"-"`
    var UpdatedAt : Date?
    /// `sql:"index" json:"-" yaml:"-"`
    var DeletedAt : Date?
}

// Lens represents camera lens (as extracted from UpdateExif metadata)
struct Lens  {
    /// `gorm:"primary_key" json:"ID" yaml:"ID"`
    var ID : UInt?
    /// `gorm:"type:VARBINARY(255);unique_index;" json:"Slug" yaml:"Slug,omitempty"`
    var LensSlug : String?
    /// `gorm:"type:VARCHAR(255);" json:"Name" yaml:"Name"`
    var LensName : String?
    /// `gorm:"type:VARCHAR(255);" json:"Make" yaml:"Make,omitempty"`
    var LensMake : String?
    /// `gorm:"type:VARCHAR(255);" json:"Model" yaml:"Model,omitempty"`
    var LensModel : String?
    /// `gorm:"type:VARCHAR(255);" json:"Type" yaml:"Type,omitempty"`
    var LensType : String?
    /// `gorm:"type:TEXT;" json:"Description,omitempty" yaml:"Description,omitempty"`
    var LensDescription : String?
    /// `gorm:"type:TEXT;" json:"Notes,omitempty" yaml:"Notes,omitempty"`
    var LensNotes : String?
    /// `json:"-" yaml:"-"`
    var CreatedAt : Date?
    /// `json:"-" yaml:"-"`
    var UpdatedAt : Date?
    /// `sql:"index" json:"-" yaml:"-"`
    var DeletedAt : Date?
}

// Cell represents a S2 cell with location data.
struct Cell  {
    /// `gorm:"type:VARBINARY(42);primary_key;auto_increment:false;" json:"ID" yaml:"ID"`
    var ID : String?
    /// `gorm:"type:VARCHAR(255);" json:"Name" yaml:"Name,omitempty"`
    var CellName : String?
    /// `gorm:"type:VARCHAR(64);" json:"Category" yaml:"Category,omitempty"`
    var CellCategory : String?
    /// `gorm:"type:VARBINARY(42);default:'zz'" json:"-" yaml:"PlaceID"`
    var PlaceID : String?
    /// `gorm:"PRELOAD:true" json:"Place" yaml:"-"`
    var Place : Place?
    /// `json:"CreatedAt" yaml:"-"`
    var CreatedAt : Date?
    /// `json:"UpdatedAt" yaml:"-"`
    var UpdatedAt : Date?
}

// Place used to associate photos to places
struct Place  {
    /// `gorm:"type:VARBINARY(42);primary_key;auto_increment:false;" json:"PlaceID" yaml:"PlaceID"`
    var ID : String?
    /// `gorm:"type:VARBINARY(755);unique_index;" json:"Label" yaml:"Label"`
    var PlaceLabel : String?
    /// `gorm:"type:VARCHAR(255);" json:"City" yaml:"City,omitempty"`
    var PlaceCity : String?
    /// `gorm:"type:VARCHAR(255);" json:"State" yaml:"State,omitempty"`
    var PlaceState : String?
    /// `gorm:"type:VARBINARY(2);" json:"Country" yaml:"Country,omitempty"`
    var PlaceCountry : String?
    /// `gorm:"type:VARCHAR(255);" json:"Keywords" yaml:"Keywords,omitempty"`
    var PlaceKeywords : String?
    /// `json:"Favorite" yaml:"Favorite,omitempty"`
    var PlaceFavorite : Bool?
    /// `gorm:"default:1" json:"PhotoCount" yaml:"-"`
    var PhotoCount : Int?
    /// `json:"CreatedAt" yaml:"-"`
    var CreatedAt : Date?
    /// `json:"UpdatedAt" yaml:"-"`
    var UpdatedAt : Date?
}

// Keyword used for full text search
struct Keyword  {
    /// `gorm:"primary_key"`
    var ID : UInt?
    /// `gorm:"type:VARCHAR(64);index;"`
    var Keyword : String?
    var Skip : Bool?
}

// Album represents a photo album
public struct Album  {
    /// `gorm:"primary_key" json:"ID" yaml:"-"`
    var ID : UInt?
    /// `gorm:"type:VARBINARY(42);unique_index;" json:"UID" yaml:"UID"`
    var AlbumUID : String?
    /// `gorm:"type:VARBINARY(42);" json:"CoverUID" yaml:"CoverUID,omitempty"`
    var CoverUID : String?
    /// `gorm:"type:VARBINARY(42);index;" json:"FolderUID" yaml:"FolderUID,omitempty"`
    var FolderUID : String?
    /// `gorm:"type:VARBINARY(255);index;" json:"Slug" yaml:"Slug"`
    var AlbumSlug : String?
    /// `gorm:"type:VARBINARY(500);index;" json:"Path" yaml:"-"`
    var AlbumPath : String?
    /// `gorm:"type:VARBINARY(8);default:'album';" json:"Type" yaml:"Type,omitempty"`
    var AlbumType : String?
    /// `gorm:"type:VARCHAR(255);" json:"Title" yaml:"Title"`
    var AlbumTitle : String?
    /// `gorm:"type:VARCHAR(255);" json:"Location" yaml:"Location,omitempty"`
    var AlbumLocation : String?
    /// `gorm:"type:VARCHAR(255);index;" json:"Category" yaml:"Category,omitempty"`
    var AlbumCategory : String?
    /// `gorm:"type:TEXT;" json:"Caption" yaml:"Caption,omitempty"`
    var AlbumCaption : String?
    /// `gorm:"type:TEXT;" json:"Description" yaml:"Description,omitempty"`
    var AlbumDescription : String?
    /// `gorm:"type:TEXT;" json:"Notes" yaml:"Notes,omitempty"`
    var AlbumNotes : String?
    /// `gorm:"type:VARBINARY(1024);" json:"Filter" yaml:"Filter,omitempty"`
    var AlbumFilter : String?
    /// `gorm:"type:VARBINARY(32);" json:"Order" yaml:"Order,omitempty"`
    var AlbumOrder : String?
    /// `gorm:"type:VARBINARY(255);" json:"Template" yaml:"Template,omitempty"`
    var AlbumTemplate : String?
    /// `gorm:"type:VARBINARY(2);index:idx_albums_country_year_month;default:'zz'" json:"Country" yaml:"Country,omitempty"`
    var AlbumCountry : String?
    /// `gorm:"index:idx_albums_country_year_month;" json:"Year" yaml:"Year,omitempty"`
    var AlbumYear : Int?
    /// `gorm:"index:idx_albums_country_year_month;" json:"Month" yaml:"Month,omitempty"`
    var AlbumMonth : Int?
    /// `json:"Day" yaml:"Day,omitempty"`
    var AlbumDay : Int?
    /// `json:"Favorite" yaml:"Favorite,omitempty"`
    var AlbumFavorite : Bool?
    /// `json:"Private" yaml:"Private,omitempty"`
    var AlbumPrivate : Bool?
    /// `json:"CreatedAt" yaml:"CreatedAt,omitempty"`
    var CreatedAt : Date?
    /// `json:"UpdatedAt" yaml:"UpdatedAt,omitempty"`
    var UpdatedAt : Date?
    /// `sql:"index" json:"DeletedAt" yaml:"DeletedAt,omitempty"`
    var DeletedAt : Date?
    /// `gorm:"foreignkey:AlbumUID;association_foreignkey:AlbumUID" json:"-" yaml:"Photos,omitempty"`
    var Photos   : [PhotoAlbums] = []
}

typealias PhotoAlbums = [PhotoAlbum]
// PhotoAlbum represents the many_to_many relation between Photo and Album
struct PhotoAlbum  {
    /// `gorm:"type:VARBINARY(42);primary_key;auto_increment:false" json:"PhotoUID" yaml:"UID"`
    var PhotoUID : String?
    /// `gorm:"type:VARBINARY(42);primary_key;auto_increment:false;index" json:"AlbumUID" yaml:"-"`
    var AlbumUID : String?
    /// `json:"Order" yaml:"Order,omitempty"`
    var Order : Int?
    /// `json:"Hidden" yaml:"Hidden,omitempty"`
    var Hidden : Bool?
    /// `json:"Missing" yaml:"Missing,omitempty"`
    var Missing : Bool?
    /// `json:"CreatedAt" yaml:"CreatedAt,omitempty"`
    var CreatedAt : Date?
    /// `json:"UpdatedAt" yaml:"-"`
    var UpdatedAt : Date?
    /// `gorm:"PRELOAD:false" yaml:"-"`
    var Photo     : Photo?
    /// `gorm:"PRELOAD:true" yaml:"-"`
    var Album     :Album?
}



// FileSync represents a one-to-many relation between File and Account for syncing with remote services.
struct FileSync  {
    /// `gorm:"primary_key;auto_increment:false;type:VARBINARY(255)"`
    var RemoteName : String?
    /// `gorm:"primary_key;auto_increment:false"`
    var AccountID : UInt?
    /// `gorm:"index;"`
    var FileID : UInt?
    var RemoteDate : Date?
    var RemoteSize : Int64?
    /// `gorm:"type:VARBINARY(16);"`
    var Status : String?
    /// `gorm:"type:VARBINARY(512);"`
    var Error : String?
    var Errors     :Int?
    var File       :File?
    var Account    :Account?
    var CreatedAt  :Date?
    var UpdatedAt  :Date?
}

// FileShare represents a one-to-many relation between File and Account for pushing files to remote services.
struct FileShare  {
    /// `gorm:"primary_key;auto_increment:false"`
    var FileID : UInt?
    /// `gorm:"primary_key;auto_increment:false"`
    var AccountID : UInt?
    /// `gorm:"primary_key;auto_increment:false;type:VARBINARY(255)"`
    var RemoteName : String?
    /// `gorm:"type:VARBINARY(16);"`
    var Status : String?
    /// `gorm:"type:VARBINARY(512);"`
    var Error : String?
    var Errors     :Int?
    var File       :File?
    var Account    :Account?
    var CreatedAt  :Date?
    var UpdatedAt  :Date?
}

// PhotoLabel represents the many-to-many relation between Photo and label.
// Labels are weighted by uncertainty (100 - confidence)
struct PhotoLabel  {
    /// `gorm:"primary_key;auto_increment:false"`
    var PhotoID : UInt?
    /// `gorm:"primary_key;auto_increment:false;index"`
    var LabelID : UInt?
    /// `gorm:"type:VARBINARY(8);"`
    var LabelSrc : String?
    /// `gorm:"type:SMALLINT"`
    var Uncertainty : Int?
    /// `gorm:"PRELOAD:false"`
    var Photo       :Photo?
    /// `gorm:"PRELOAD:true"`
    var Label       :Label?
}

// Label is used for photo, album and location categorization
struct Label  {
    /// `gorm:"primary_key" json:"ID" yaml:"-"`
    var ID : UInt?
    /// `gorm:"type:VARBINARY(42);unique_index;" json:"UID" yaml:"UID"`
    var LabelUID : String?
    /// `gorm:"type:VARBINARY(255);unique_index;" json:"Slug" yaml:"-"`
    var LabelSlug : String?
    /// `gorm:"type:VARBINARY(255);index;" json:"CustomSlug" yaml:"-"`
    var CustomSlug : String?
    /// `gorm:"type:VARCHAR(255);" json:"Name" yaml:"Name"`
    var LabelName : String?
    /// `json:"Priority" yaml:"Priority,omitempty"`
    var LabelPriority : Int?
    /// `json:"Favorite" yaml:"Favorite,omitempty"`
    var LabelFavorite : Bool?
    /// `gorm:"type:TEXT;" json:"Description" yaml:"Description,omitempty"`
    var LabelDescription : String?
    /// `gorm:"type:TEXT;" json:"Notes" yaml:"Notes,omitempty"`
    var LabelNotes : String?
    /// `gorm:"many2many:categories;association_jointable_foreignkey:category_id" json:"-" yaml:"-"`
    var LabelCategories  :[Label] = []
    /// `gorm:"default:1" json:"PhotoCount" yaml:"-"`
    var PhotoCount : Int?
    /// `json:"CreatedAt" yaml:"-"`
    var CreatedAt : Date?
    /// `json:"UpdatedAt" yaml:"-"`
    var UpdatedAt : Date?
    /// `sql:"index" json:"DeletedAt,omitempty" yaml:"-"`
    var DeletedAt : Date?
    /// `gorm:"-" json:"-" yaml:"-"`
    var New : Bool?
}

// FileInfos represents meta data about a file
struct FileInfos  {
    var FileWidth       : Int?
    var FileHeight      : Int?
    var FileOrientation : Int?
    var FileAspectRatio : Float32?
    var FileMainColor : String?
    var FileColors : String?
    var FileLuminance : String?
    var FileDiff      : UInt32?
    var FileChroma : UInt8?
}

// Account represents a remote service account for uploading, downloading or syncing media files.
struct Account  {
    /// `gorm:"primary_key"`
    var ID : UInt?
    /// `gorm:"type:VARCHAR(255);"`
    var AccName : String?
    /// `gorm:"type:VARCHAR(255);"`
    var AccOwner : String?
    /// `gorm:"type:VARBINARY(512);"`
    var AccURL : String?
    /// `gorm:"type:VARBINARY(255);"`
    var AccType : String?
    /// `gorm:"type:VARBINARY(255);"`
    var AccKey : String?
    /// `gorm:"type:VARBINARY(255);"`
    var AccUser : String?
    /// `gorm:"type:VARBINARY(255);"`
    var AccPass : String?
    /// `gorm:"type:VARBINARY(512);"`
    var AccError : String?
    var AccErrors     :Int?
    var AccShare : Bool?
    var AccSync : Bool?
    var RetryLimit    :Int?
    /// `gorm:"type:VARBINARY(500);"`
    var SharePath : String?
    /// `gorm:"type:VARBINARY(16);"`
    var ShareSize : String?
    var ShareExpires  :Int?
    /// `gorm:"type:VARBINARY(500);"`
    var SyncPath : String?
    /// `gorm:"type:VARBINARY(16);"`
    var SyncStatus : String?
    var SyncInterval: Int?
    /// `deepcopier:"skip"`
    var SyncDate : Date?
    var SyncUpload : Bool?
    var SyncDownload : Bool?
    var SyncFilenames : Bool?
    var SyncRaw : Bool?
    /// `deepcopier:"skip"`
    var CreatedAt : Date?
    /// `deepcopier:"skip"`
    var UpdatedAt : Date?
    /// `deepcopier:"skip" sql:"index"`
    var DeletedAt : Date?
}
