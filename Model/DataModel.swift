//
//  DataModel.swift
//  ADIM
//
//  Created by Ahmed Durrani on 06/10/2017.
//  Copyright © 2017 Expert_ni.halal_Pro. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper


class UserResponse: Mappable {
    
    var success                  :       Bool?
    var message                  :       String?
    var data                     :       UserInformation?
    var nurseList                :       [NurseListObject]?
    var selectedNurseList        :       NurseListObject?
    var requestObject            :       DirectNurseRequestObject?
    var availabilityObject       :       AvailabilityInfo?
    var historyObject            :       [HistoryInfo]?
    var nurseProfile             :       NurseProfile?


    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data    <- map["data"]
        nurseList <- map["data"]
        selectedNurseList <- map["data"]
        requestObject <- map["data"]
        
        availabilityObject <- map["data"]
        
        historyObject <- map["data"]
        
        nurseProfile <- map["data"]
        
        
    }
}

class ErrorObject : Mappable {
    var email: String?
    var password: String?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        email <- map["errors.email"]
        password <- map["errors.password"]
    }

}

class NotaryObject : Mappable {
    var selectNotaryList: [SelectDayObject]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        selectNotaryList <- map["allList"]
    }
    
}


class SelectDayObject: Mappable {
    var type: String?
    var typeObject: [ServiceRequestObject]?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        type <- map["day"]
        typeObject <- map["data"]
    }
}

class EmailValidator : Mappable {
    
    var user: UserInformation?
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        user <- map["user"]
        
    }
    
}

class PhoneNumberValidator : Mappable {
    
    var user: UserInformation?
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        user <- map["user"]
        
    }
    
}

class DirectNurseRequestObject : Mappable {
    
    var hospital_id: Int?
    var id : String?
    var nurse_id: String?
    var shift_date: String?
    var shift_end_time: String?
    var shift_start_time: String?
    
    
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        hospital_id <- map["hospital_id"]
        nurse_id <- map["nurse_id"]
        shift_date <- map["shift_date"]
        shift_end_time <- map["shift_end_time"]
        shift_start_time <- map["shift_start_time"]
        
        
        
        
    }
}

class HistoryInfo : Mappable {
    var hospital_id: Int?
    var id : Int?
    var nurse_id: String?
    var shift_date: String?
    var shift_end_time: String?
    var shift_start_time: String?
    var total_job_time   : Int?
    var has_accepted     : Bool?
    var has_confirmed     : Bool?
    var has_declined     : Bool?
    var has_expired     : Bool?
    var has_requested     : Bool?
    var shift_started      : Bool?
    var shift_ended       : String?
    var nurseObject       : NurseHistoryInfo?
    var hospitalObject       : HospitalHistoryInfo?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        hospital_id <- map["hospital_id"]
        nurse_id <- map["nurse_id"]
        shift_date <- map["shift_date"]
        shift_end_time <- map["shift_end_time"]
        shift_start_time <- map["shift_start_time"]
        total_job_time <- map["total_job_time"]
        has_accepted <- map["has_accepted"]
        has_confirmed <- map["has_confirmed"]
        has_declined <- map["has_declined"]
        has_expired <- map["has_expired"]
        has_requested <- map["has_requested"]
        nurseObject <- map["nurse"]
        hospitalObject <- map["hospital"]
        shift_started <- map["shift_started"]
        shift_ended <- map["shift_ended"]



    }
}

class NurseHistoryInfo : Mappable {
    
    var id: Int?
    var latitude: Double?
    var longitude: Double?
    var shift: String?
    var speciality: String?
    var state : String?
    var address : String?
    var city : String?
    var country : String?
    var type    :  String?
    var nurseProfile : NurseListObject?
    
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        shift <- map["shift"]
        speciality <- map["speciality"]
        state <- map["state"]
        address  <- map["address"]
        city  <- map["city"]
        country  <- map["country"]
        type <- map["type"]
        nurseProfile <- map["user"]
    }
}

class HospitalHistoryInfo : Mappable {
    
    var id: Int?
    var hospital_name: String?
    var latitude: Double?
    var longitude: Double?
    var shift: String?
    var speciality: String?
    var state : String?
    var address : String?
    var city : String?
    var country : String?
    var hospitalProfile : NurseListObject?

    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        hospital_name <- map["hospital_name"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        shift <- map["shift"]
        speciality <- map["speciality"]
        state <- map["state"]
        address  <- map["address"]
        city  <- map["city"]
        country  <- map["country"]
        hospitalProfile <- map["user"]

    }
}


class UserData : Mappable {
    
    var user: UserInformation?
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        user <- map["user"]
        
    }
    
}

class AvailabilityInfo : Mappable {
    
    var id: Int?
    var user_id : String?
    var gender: String?
    var shift: String?
    var type: String?
    var speciality: String?
    var available : String?
    var address : String?
    var city : String?
    var state : String?
    var country : String?
    var latitude : Double?
    var longitude : Double?
    var altitude : Double?
    var hospital_name : String?
    
    
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        gender <- map["gender"]
        shift <- map["shift"]
        type <- map["type"]
        speciality <- map["speciality"]
        available <- map["available"]
        address <- map["address"]
        city <- map["city"]
        state <- map["state"]
        country <- map["country"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        altitude <- map["altitude"]
        hospital_name <- map["hospital_name"]
        shift <- map["shift"]
        type <- map["type"]
        
        
        
        
        
    }
}

class NurseListObject : Mappable {
    
    var id: Int?
    var name : String?
    var email: String?
    var phone: String?
    var avatar_url: String?
    var speciality: String?
    var available : Bool?
    var availables : Int?

    var address : String?
    var city : String?
    var state : String?
    var country : String?
    var latitude : Double?
    var longitude : Double?
    var altitude : Double?
    var hospital_name : String?
    var shift : String?
    var type : String?
    var user_id : String?
    


    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        name <- map["name"]
        email <- map["email"]
        phone <- map["phone"]
        avatar_url <- map["avatar_url"]
        speciality <- map["speciality"]
        available <- map["available"]
        
        availables <- map["available"]
        address <- map["address"]
        city <- map["city"]
        state <- map["state"]
        country <- map["country"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        altitude <- map["altitude"]
        hospital_name <- map["hospital_name"]
        shift <- map["shift"]
        type <- map["type"]

        
        


    }
}


class NurseProfile : Mappable {
    
    var id: Int?
    var name : String?
    var shift: String?
    var type: String?
    var speciality: String?
    var available : Bool?
    
    var address : String?
    var city : String?
    var state : String?
    var country : String?
    var latitude : Double?
    var longitude : Double?
    var altitude : Double?
    var hospital_name : String?
    
    
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        speciality <- map["speciality"]
        available <- map["available"]
        
        address <- map["address"]
        city <- map["city"]
        state <- map["state"]
        country <- map["country"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        altitude <- map["altitude"]
        shift <- map["shift"]
        type <- map["type"]
        
        
        
        
        
    }
}

class UserInformation : Mappable {
    
    var id: Int?
    var apiToken: String?
    var name: String?
    var email: String?
    var phone: String?
    var type : String?
    var isVerified : Bool?
    var is_accepted : Bool?
    var profile_completed : Bool?
    var available         : String?
    


    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        apiToken <- map["api_token"]
        name <- map["name"]
        email <- map["email"]
        phone <- map["phone"]
        type <- map["type"]
        isVerified  <- map["is_verified"]
        is_accepted  <- map["is_accepted"]
        profile_completed  <- map["profile_completed"]
        available          <- map["available"]
    }
}


class NotaryProfileObject : Mappable {
    
    var id: Int?
    var user_id: String?
    var notary_type: String?
    var commission_no: String?
    var surety_bond_information: String?
    var e_and_o_insurance : String?
    var suggested_fees_for_services : Int?
    var delivery_charges : Int?
    var notary_qualifications     : String?
    
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        notary_type <- map["notary_type"]
        commission_no <- map["commission_no"]
        surety_bond_information <- map["surety_bond_information"]
        e_and_o_insurance <- map["e_and_o_insurance"]
        suggested_fees_for_services <- map["suggested_fees_for_services"]
        delivery_charges <- map["delivery_charges"]
        notary_qualifications <- map["notary_qualifications"]
        
    }
}

class RatingObject : Mappable {
    
    var average: String?
    var ratee_id: Int?
    
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        average <- map["average"]
        ratee_id <- map["ratee_id"]
        
    }
}



class ClientRequestJob : Mappable {
    var listOfClientCompleteJob : [ServiceRequestObject]?
    var listOfClientPendinfJob : [ServiceRequestObject]?

    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        
        listOfClientCompleteJob <- map["completed"]
        listOfClientPendinfJob <- map["pending"]
    }
}





class NotaryProfile : Mappable {
    var notaryUserID : Int?
    var notary_type: String?
    var commission_no: String?
    var activation_date: String?
    var expiration_date: String?
    var surety_bond_information: String?
    var e_and_o_insurance : String?
    var suggested_fees_for_services : String?
    var delivery_charges : String?
    var user_id     : Int?
    var notary_qualifications : String?
    var created_at : String?
    var userProfile : UserInformation?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        notaryUserID <- map["id"]
        notary_type <- map["notary_type"]
        commission_no <- map["commission_no"]
        activation_date <- map["activation_date"]
        expiration_date <- map["expiration_date"]
        surety_bond_information <- map["surety_bond_information"]
        e_and_o_insurance <- map["e_and_o_insurance"]
        suggested_fees_for_services <- map["suggested_fees_for_services"]
        delivery_charges <- map["delivery_charges"]
        user_id <- map["user_id"]
        notary_qualifications <- map["notary_qualifications"]
        created_at <- map["created_at"]
        userProfile <- map["user"]
    }
}



class GetAllServiceObject : Mappable {
    var serviceId : Int?
    var user_id: String?
    var name: String?
    var price: String?
    var prices: Int?

    var slug: String?
    var created_at: String?
    var updated_at: String?
    var deleted_at : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        serviceId <- map["id"]
        user_id <- map["user_id"]
        name <- map["name"]
        slug <- map["slug"]
        price <- map["price"]
        prices <- map["price"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        deleted_at <- map["deleted_at"]
    }
}

class GetALLReviewObject : Mappable {
    var idOfReview : Int?
    var rater: String?
    var rater_id: Int?
    var ratee: String?
    var ratee_id: Int?
    var rating: Int?
    var comment: String?
    var created_at : String?
    var updated_at : String?

    
    var notaryReview : GETALLNotaryObjectReview?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        
        idOfReview <- map["id"]
        rater <- map["rater"]
        rater_id <- map["rater_id"]
        ratee <- map["ratee"]
        ratee_id <- map["ratee_id"]
        rating <- map["rating"]
        comment <- map["comment"]
        notaryReview <- map["notary"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]

        
    }
}

class GETALLNotaryObjectReview : Mappable {
    var idOfNotary : Int?
    var name: String?
    var email: Int?
    var notaryReview : [GetAllNotaryReview]?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        
        idOfNotary <- map["id"]
        name <- map["name"]
        email <- map["email"]
        notaryReview <- map["rating"]
    }
}

class GetAllNotaryReview : Mappable {
   
    var ratee_id : Int?
    var average: String?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        
        ratee_id <- map["ratee_id"]
        average <- map["average"]
    }
}

class GETALLCertificateObject : Mappable {
    var idOfCertificate : Int?
    var name: String?
    var updated_at: Int?
    var url : String?
    var user_id : Int?

    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        
        idOfCertificate <- map["id"]
        name <- map["name"]
        updated_at <- map["updated_at"]
        url <- map["url"]
        user_id <- map["user_id"]

    }
}


class ServiceRequestObject : Mappable {
    var client_id : Int?
    var notary_id: String?
    var service_id: String?
    var company_name: String?
    var business_email: String?
    var address: String?
    var latitude : Double?
    var longitude : Double?
    var on_going : String?
    var payment_type     : String?
    var status : String?
    var created_at : String?
    var appointment : String?
    var appointmentDate               : AppointmentDateObject?
    var clientObj                    : UserInformation?
    var clientGetNotaryObject        :      UserInformation?
    var doucmentList                 : [DocuemtnObject]?


    var documentObject : [DocuemtnObject]?
   
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        client_id <- map["client_id"]
        notary_id <- map["notary_id"]
        service_id <- map["service_id"]
        company_name <- map["company_name"]
        business_email <- map["business_email"]
        address <- map["address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        on_going <- map["on_going"]
        payment_type <- map["payment_type"]
        status <- map["status"]
        appointment <- map["appointment_datetime"]
        
        created_at <- map["created_at"]
        appointmentDate <- map["appointment_datetime"]
        documentObject  <- map["documents"]
        clientObj       <- map["client"]
        documentObject <- map["documents"]
        clientGetNotaryObject <- map["notary"]
        
        
    }
}


class NotarySendOfferToClient : Mappable {
    var client_request_id : String?
    var client_id: Int?
    var notary_id: Int?
    var offer_details: String?
    var offer_date: String?
    
    var documentObject : [DocuemtnObject]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        client_request_id <- map["client_request_id"]
        client_id <- map["client_id"]
        notary_id <- map["notary_id"]
        offer_details <- map["offer_details"]
        offer_date <- map["offer_date"]
    }
}

class AppointmentDateObject : Mappable {
    
    var date : String?
    var timezone: String?
    var timezone_type : Int?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        
        date <- map["date"]
        timezone <- map["timezone"]
        timezone_type <- map["timezone_type"]

    }
}

class DocuemtnObject : Mappable {
    
    var created_at : String?
    var idofDocument: Int?
    var name : String?
    var request_id : Int?
    var url : String?
    var verified : Bool?
    var verified_url : String?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        
        created_at <- map["created_at"]
        idofDocument <- map["id"]
        name <- map["name"]
        request_id <- map["request_id"]
        url <- map["url"]
        verified <- map["verified"]
        verified_url <- map["verified_url"]
        
        

        
    }
}

