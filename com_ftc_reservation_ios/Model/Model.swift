//
//  File.swift
//  com_ftc_reservation_ios
//
//  Created by Toby on 2019/4/14.
//  Copyright © 2019 Toby. All rights reserved.
//

import Foundation

struct M_Code: Decodable {
    var code: Int
    var message: String
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}

struct M_Login: Decodable {
    var code: Int
    var message: String
    var acno: String
    var access_token: String
    var expires_in: Int
    var nm: String
    
    init(code: Int, message: String, acno: String, access_token: String, expires_in: Int, nm: String) {
        self.code = code
        self.message = message
        self.acno = acno
        self.access_token = access_token
        self.expires_in = expires_in
        self.nm = nm
    }
}

struct M_Portal: Decodable {
    var code: Int
    var message: String
    var title: String
    var actxuid: String
    var totalcount: Int
    var realcount: Int
    //    var dtlurl: String
    
    init(code: Int, message: String, title: String, actxuid: String, totalcount: Int, realcount: Int) {
        self.code = code
        self.message = message
        self.title = title
        self.actxuid = actxuid
        self.totalcount = totalcount
        self.realcount = realcount
        //        self.dtlurl = dtlurl
    }
}

struct M_Forget : Decodable {
    var code: Int
    var message: String
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}

struct M_MemberCheck : Decodable {
    var code : Int
    var message: String
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}

struct M_MemberCancel : Decodable {
    var code : Int
    var message: String
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}


struct M_Search: Codable {
    var code: Int
    var message: String
    var mblist: [M_Member]
    
}


struct M_SearchByMk: Codable {
    var code: Int
    var message: String
    var mblist: [M_Member]
    
}

struct M_Member: Codable {
    
    var mbxuid: String
    var mbnm: String
    var mbtel: String
    var mbgender: String?
    var mbcheckinseq: String?
    
}

struct M_MemberDetail : Decodable {
    var code: Int
    var message: String
    var mbxuid: String
    var mbnm: String
    var mbtel: String
    var mbgender: String
    var mbemail: String
    var mbmk: String
    var mbco: String
    var mbdut : String
    var mbno: String
    var livetype: String
    
    init(code: Int, message: String, mbxuid: String, mbnm: String, mbtel:String, mbgender:String, mbemail:String,  mbmk:String, mbco: String, mbdut: String, mbno: String, livetype: String ) {
        self.code = code
        self.message = message
        self.mbxuid = mbxuid
        self.mbnm = mbnm
        self.mbtel = mbtel
        self.mbgender = mbgender
        self.mbemail = mbemail
        self.mbmk = mbmk
        self.mbco = mbco
        self.mbdut = mbdut
        self.mbno = mbno
        self.livetype = livetype
    }
}

struct M_ScanQuick: Decodable {
    var code : Int
    var message: String
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}

struct M_QRcode : Decodable {
    var code: Int
    var message: String
    var mbxuid: String
    var mbnm: String
    var mbtel: String
    var mbgender: String = ""
    var mbmk: String
    var mbco: String
    var mbdut : String
    var mbno: String
    var mbemail: String
    var livetype: String

    init(code: Int, message: String, mbxuid: String, mbnm: String, mbtel:String, mbgender:String, mbmk:String, mbco: String, mbdut: String, mbno: String, mbemail: String, livetype: String ) {
        self.code = code
        self.message = message
        self.mbxuid = mbxuid
        self.mbnm = mbnm
        self.mbtel = mbtel
        self.mbgender = mbgender
        self.mbmk = mbmk
        self.mbco = mbco
        self.mbdut = mbdut
        self.mbno = mbno
        self.mbemail = mbemail
        self.livetype = livetype
    }
}

struct M_ScanOK : Decodable {
    var code : Int
    var message: String
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}

struct M_Logout : Decodable {
    var code : Int
    var message: String
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}

