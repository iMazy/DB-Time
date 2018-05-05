//
//  DBRatingModel.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/4.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit
import ObjectMapper

struct DBTop250: Mappable {
    
    var count: Int = 0
    var start: Int = 0
    var total: Int = 0
    var subjects: [DBMovieSubject] = []
    
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        count <- map["count"]
        start <- map["start"]
        total <- map["total"]
        subjects <- map["subjects"]
    }
    
}

struct DBMovieSubject: Mappable {
    var rating: DBRatingModel!
    var genres: [String] = []
    var title: String = ""
    var casts: [DBCastModel] = []
    var collectCount: Int64 = 0
    var originalTitle: String = ""
    var subtype: String = ""
    var directors: [DBCastModel] = []
    var year: String = ""
    var images: DBAvatar!
    var alt: String = ""
    var id: Int64 = 0
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        rating <- map["rating"]
        genres <- map["genres"]
        title <- map["title"]
        casts <- map["casts"]
        collectCount <- map["collect_count"]
        originalTitle <- map["original_title"]
        subtype <- map["subtype"]
        directors <- map["directors"]
        year <- map["year"]
        images <- map["images"]
        alt <- map["alt"]
        id <- map["id"]
    }
}

struct DBCastModel: Mappable {
    
    var alt: String = ""
    var name: String = ""
    var id: Int64 = 0
    var avatars: DBAvatar!
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        alt <- map["alt"]
        name <- map["name"]
        id <- map["id"]
        avatars <- map["avatars"]
    }
}

struct DBAvatar: Mappable {
    var small: String = ""
    var large: String = ""
    var medium: String = ""
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        small <- map["small"]
        large <- map["large"]
        medium <- map["medium"]
    }
}

struct DBRatingModel: Mappable {
    var max: Int = 0
    var min: Int = 0
    var average: Double = 0
    var stars: String = ""

    init?(map: Map) { }
    
    // Mappable
    mutating func mapping(map: Map) {
        max <- map["max"]
        min <- map["min"]
        average <- map["average"]
        stars <- map["stars"]
    }
}
