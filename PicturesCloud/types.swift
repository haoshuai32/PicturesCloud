//
//  types.swift
//  PicturesCloud
//
//  Created by haoshuai on 2023/2/1.
//

import Foundation
import ObjectMapper

struct Options: Mappable {
    var name: String?
    var version: String?
    var copyright: String?
    var downloadToken: String?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        name     <- map["name"]
        version     <- map["version"]
        copyright     <- map["copyright"]
        downloadToken     <- map["downloadToken"]
        
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

//type Photos []Photo
typealias Photos = [Photo]
// Photo represents a photo, all its properties, and link to all its images and sidecar files.
public struct Photo  {
    /// `gorm:"type:VARBINARY(42);index;" json:"DocumentID,omitempty" yaml:"DocumentID,omitempty"`
    var UUID : String?
    /// `gorm:"type:datetime;index:idx_photos_taken_uid;" json:"TakenAt" yaml:"TakenAt"`
    var TakenAt : Date?
    /// `gorm:"type:datetime;" yaml:"-"`
    var TakenAtLocal : Date?
    /// `gorm:"type:VARBINARY(8);" json:"TakenSrc" yaml:"TakenSrc,omitempty"`
    var TakenSrc : String?
    /// `gorm:"type:VARBINARY(42);unique_index;index:idx_photos_taken_uid;" json:"UID" yaml:"UID"`
    var PhotoUID : String?
    /// `gorm:"type:VARBINARY(8);default:'image';" json:"Type" yaml:"Type"`
    var PhotoType : String?
    /// `gorm:"type:VARBINARY(8);" json:"TypeSrc" yaml:"TypeSrc,omitempty"`
    var TypeSrc : String?
    /// `gorm:"type:VARCHAR(255);" json:"Title" yaml:"Title"`
    var PhotoTitle : String?
    /// `gorm:"type:VARBINARY(8);" json:"TitleSrc" yaml:"TitleSrc,omitempty"`
    var TitleSrc : String?
    /// `gorm:"type:TEXT;" json:"Description" yaml:"Description,omitempty"`
    var PhotoDescription : String?
    /// `gorm:"type:VARBINARY(8);" json:"DescriptionSrc" yaml:"DescriptionSrc,omitempty"`
    var DescriptionSrc : String?
    /// `gorm:"type:VARBINARY(500);index:idx_photos_path_name;" json:"Path" yaml:"-"`
    var PhotoPath : String?
    /// `gorm:"type:VARBINARY(255);index:idx_photos_path_name;" json:"Name" yaml:"-"`
    var PhotoName : String?
    /// `gorm:"type:VARBINARY(755);" json:"OriginalName" yaml:"OriginalName,omitempty"`
    var OriginalName : String?
    /// `json:"Stack" yaml:"Stack,omitempty"`
    var PhotoStack : Int8?
    /// `json:"Favorite" yaml:"Favorite,omitempty"`
    var PhotoFavorite : Bool?
    /// `json:"Private" yaml:"Private,omitempty"`
    var PhotoPrivate : Bool?
    /// `json:"Scan" yaml:"Scan,omitempty"`
    var PhotoScan : Bool?
    /// `json:"Panorama" yaml:"Panorama,omitempty"`
    var PhotoPanorama : Bool?
    /// `gorm:"type:VARBINARY(64);" json:"TimeZone" yaml:"-"`
    var TimeZone : String?
    /// `gorm:"type:VARBINARY(42);index;default:'zz'" json:"PlaceID" yaml:"-"`
    var PlaceID : String?
    /// `gorm:"type:VARBINARY(8);" json:"PlaceSrc" yaml:"PlaceSrc,omitempty"`
    var PlaceSrc : String?
    /// `gorm:"type:VARBINARY(42);index;default:'zz'" json:"CellID" yaml:"-"`
    var CellID : String?
    /// `json:"CellAccuracy" yaml:"CellAccuracy,omitempty"`
    var CellAccuracy : Int?
    /// `json:"Altitude" yaml:"Altitude,omitempty"`
    var PhotoAltitude : Int?
    /// `gorm:"type:FLOAT;index;" json:"Lat" yaml:"Lat,omitempty"`
    var PhotoLat : Float32?
    /// `gorm:"type:FLOAT;index;" json:"Lng" yaml:"Lng,omitempty"`
    var PhotoLng : Float32?
    /// `gorm:"type:VARBINARY(2);index:idx_photos_country_year_month;default:'zz'" json:"Country" yaml:"-"`
    var PhotoCountry : String?
    /// `gorm:"index:idx_photos_country_year_month;" json:"Year" yaml:"Year"`
    var PhotoYear : Int?
    /// `gorm:"index:idx_photos_country_year_month;" json:"Month" yaml:"Month"`
    var PhotoMonth : Int?
    /// `json:"Day" yaml:"Day"`
    var PhotoDay : Int?
    /// `json:"Iso" yaml:"ISO,omitempty"`
    var PhotoIso : Int?
    /// `gorm:"type:VARBINARY(64);" json:"Exposure" yaml:"Exposure,omitempty"`
    var PhotoExposure : String?
    /// `gorm:"type:FLOAT;" json:"FNumber" yaml:"FNumber,omitempty"`
    var PhotoFNumber : Float32?
    /// `json:"FocalLength" yaml:"FocalLength,omitempty"`
    var PhotoFocalLength : Int?
    /// `gorm:"type:SMALLINT" json:"Quality" yaml:"-"`
    var PhotoQuality : Int?
    /// `gorm:"type:SMALLINT" json:"Resolution" yaml:"-"`
    var PhotoResolution : Int?
    /// `json:"Color" yaml:"-"`
    var PhotoColor : UInt8?
    /// `gorm:"index:idx_photos_camera_lens;default:1" json:"CameraID" yaml:"-"`
    var CameraID : UInt?
    /// `gorm:"type:VARBINARY(255);" json:"CameraSerial" yaml:"CameraSerial,omitempty"`
    var CameraSerial : String?
    /// `gorm:"type:VARBINARY(8);" json:"CameraSrc" yaml:"-"`
    var CameraSrc : String?
    /// `gorm:"index:idx_photos_camera_lens;default:1" json:"LensID" yaml:"-"`
    var LensID : UInt?
    /// `gorm:"association_autoupdate:false;association_autocreate:false;association_save_reference:false" json:"Details" yaml:"Details"`
    var Details:Details?
    /// `gorm:"association_autoupdate:false;association_autocreate:false;association_save_reference:false" json:"Camera" yaml:"-"`
    var Camera:Camera?
    /// `gorm:"association_autoupdate:false;association_autocreate:false;association_save_reference:false" json:"Lens" yaml:"-"`
    var Lens:Lens?
    /// `gorm:"association_autoupdate:false;association_autocreate:false;association_save_reference:false" json:"Cell" yaml:"-"`
    var Cell:Cell?
    /// `gorm:"association_autoupdate:false;association_autocreate:false;association_save_reference:false" json:"Place" yaml:"-"`
    var Place:Place?
    /// `json:"-" yaml:"-"`
    var Keywords:[Keyword] = []
    /// `json:"-" yaml:"-"`
    var Albums:[Album] = []
    /// `yaml:"-"`
    var Files    : [File] = []
    /// `yaml:"-"`
    var Labels        : [PhotoLabel] = []
    /// `yaml:"CreatedAt,omitempty"`
    var CreatedAt : Date?
    /// `yaml:"UpdatedAt,omitempty"`
    var UpdatedAt : Date?
    /// `yaml:"EditedAt,omitempty"`
    var EditedAt : Date?
    /// `sql:"index" yaml:"-"`
    var CheckedAt : Date?
    /// `sql:"index" yaml:"DeletedAt,omitempty"`
    var DeletedAt : Date?
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

typealias Files = [File]

// File represents an image or sidecar file that belongs to a photo.
struct File  {
    /// `gorm:"primary_key" json:"-" yaml:"-"`
    var ID : UInt?
    /// `json:"-" yaml:"-"`
    var Photo           :Photo?
    /// `gorm:"index;" json:"-" yaml:"-"`
    var PhotoID : UInt?
    /// `gorm:"type:VARBINARY(42);index;" json:"PhotoUID" yaml:"PhotoUID"`
    var PhotoUID : String?
    /// `gorm:"type:VARBINARY(42);index;" json:"InstanceID,omitempty" yaml:"InstanceID,omitempty"`
    var InstanceID : String?
    /// `gorm:"type:VARBINARY(42);unique_index;" json:"UID" yaml:"UID"`
    var FileUID : String?
    /// `gorm:"type:VARBINARY(755);unique_index:idx_files_name_root;" json:"Name" yaml:"Name"`
    var FileName : String?
    /// `gorm:"type:VARBINARY(16);default:'/';unique_index:idx_files_name_root;" json:"Root" yaml:"Root,omitempty"`
    var FileRoot : String?
    /// `gorm:"type:VARBINARY(755);" json:"OriginalName" yaml:"OriginalName,omitempty"`
    var OriginalName : String?
    /// `gorm:"type:VARBINARY(128);index" json:"Hash" yaml:"Hash,omitempty"`
    var FileHash : String?
    /// `json:"Size" yaml:"Size,omitempty"`
    var FileSize : Int64?
    /// `gorm:"type:VARBINARY(32)" json:"Codec" yaml:"Codec,omitempty"`
    var FileCodec : String?
    /// `gorm:"type:VARBINARY(32)" json:"Type" yaml:"Type,omitempty"`
    var FileType : String?
    /// `gorm:"type:VARBINARY(64)" json:"Mime" yaml:"Mime,omitempty"`
    var FileMime : String?
    /// `json:"Primary" yaml:"Primary,omitempty"`
    var FilePrimary : Bool?
    /// `json:"Sidecar" yaml:"Sidecar,omitempty"`
    var FileSidecar : Bool?
    /// `json:"Missing" yaml:"Missing,omitempty"`
    var FileMissing : Bool?
    /// `json:"Portrait" yaml:"Portrait,omitempty"`
    var FilePortrait : Bool?
    /// `json:"Video" yaml:"Video,omitempty"`
    var FileVideo : Bool?
    /// `json:"Duration" yaml:"Duration,omitempty"`
    var FileDuration    :Int?
    /// `json:"Width" yaml:"Width,omitempty"`
    var FileWidth : Int?
    /// `json:"Height" yaml:"Height,omitempty"`
    var FileHeight : Int?
    /// `json:"Orientation" yaml:"Orientation,omitempty"`
    var FileOrientation : Int?
    /// `gorm:"type:VARBINARY(16);" json:"Projection,omitempty" yaml:"Projection,omitempty"`
    var FileProjection : String?
    /// `gorm:"type:FLOAT;" json:"AspectRatio" yaml:"AspectRatio,omitempty"`
    var FileAspectRatio : Float32?
    /// `gorm:"type:VARBINARY(16);index;" json:"MainColor" yaml:"MainColor,omitempty"`
    var FileMainColor : String?
    /// `gorm:"type:VARBINARY(9);" json:"Colors" yaml:"Colors,omitempty"`
    var FileColors : String?
    /// `gorm:"type:VARBINARY(9);" json:"Luminance" yaml:"Luminance,omitempty"`
    var FileLuminance : String?
    /// `json:"Diff" yaml:"Diff,omitempty"`
    var FileDiff        :UInt32?
    /// `json:"Chroma" yaml:"Chroma,omitempty"`
    var FileChroma:UInt8?
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
