//
//  NGService.swift
//  Nerdgasm
//
//  Created by Hrach on 9/30/16.
//  Copyright © 2016 Hrach. All rights reserved.
//

import Foundation
import Moya
import Result

public enum NGNetworkError: Swift.Error{
    case NoConnection
    case ValidationFailed([String:String])
    case Error(Swift.Error)
    case Unauthorized
    case NotFound
    case Unknown
    
    var error: Swift.Error? {
        switch self {
        case .Error(let error): return error
        default: return nil
        }
    }
    
    var nsError:  NSError? {
        guard let error = error else { return nil }
        guard type(of: error) == NSError.self else { return nil }
        return error as NSError
    }
}

func toNgError(err: Swift.Error) -> NGNetworkError{
    if type(of: err) == Moya.Error.self {
        let moyaErr = err as! Moya.Error
        switch moyaErr {
        case .statusCode(let response):
            switch response.statusCode{
            case 404:
                return .NotFound
            case 401:
                return .Unauthorized
            default:
                return .Unknown
            }
        case .underlying(let err):
            let nserr = err as NSError
            switch nserr.code {
            case -1001, -1009:
                return .NoConnection
            default:
                return .Error(err)
            }
        default:
            return .Unknown
        }
    }
    else {
        return .Error(err)
    }
}

func isunAuhtorized(error: Swift.Error) -> Bool {
    guard case NGNetworkError.Unauthorized = toNgError(err: error) else {
        return false
    }
    return true
}

protocol NGServiceType {
    
}

enum StockInfoService: NGServiceType{
    case SearchStockInfo(query: String)
}



enum NGAuthenticatedService: NGServiceType {
    case Signout
    case SearchUsers(query: String)
    case UpdateMe(firstname: String, lastname: String)
}

extension StockInfoService: TargetType{
    var baseURL: URL {
        return URL(string: "http://autoc.finance.yahoo.com")!
    }
    
    var path: String{
        switch self {
        case .SearchStockInfo(_):
            return "autoc"
        }
    }
    
    var method: Moya.Method {
        return .GET
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .SearchStockInfo(let query):
            return ["query" : query, "region" : 2, "lang" : "en"]
        }
    }
    
    var task: Task{
        return .request
    }
}

extension NGAuthenticatedService: TargetType{
    var baseURL: URL {
        return URL(string: "https://www.hhakobyan.com/nerdgasm/api/v1")!
    }
    
    var path: String{
        switch self {
        case .Signout:
            return "/users/logout"
        case .SearchUsers(_):
            return "/users/search"
        case .UpdateMe(_, _):
            return "/users/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .SearchUsers(_):
            return .GET
        default:
            return .POST
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .Signout:
            return nil
        case .SearchUsers(let query):
            return ["query" : query]
        case .UpdateMe(let firstname, let lastname):
            return ["firstname" : firstname, "lastname" : lastname]
        }
    }
    
    var task: Task{
        return .request
    }
}

func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

