/*
 * This file is part of Zum.
 * 
 * Zum is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Zum is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Zum. If not, see <http://www.gnu.org/licenses/>.
 */
 
import Foundation
import Heimdallr
import UIKit
import Alamofire

public class ApiClient{
    
    public func requestUrl(method : Alamofire.Method, url : String, parameters: [String: AnyObject]? = nil, isAuth: Bool = true, encoding: Alamofire.ParameterEncoding = .JSON, callback: (response: ResponseApi) -> Void){
        
        let response : ResponseApi = ResponseApi()
        
        var reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            
            if(!reachability.isReachable()){
                response.httpCode = code.networkNotConnect
                response.success = false
                callback(response: response)
                return
            }
            
        } catch {
            response.httpCode = code.error
            response.success = false
            callback(response: response);
            return
        }
        
        let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {

            self.request(method, url: url, parameters: parameters, isAuth: isAuth, encoding: encoding, callback: callback)
        }
    }
    
    private func request(method : Alamofire.Method, url : String, parameters: [String: AnyObject]? = nil, isAuth: Bool = true, encoding: Alamofire.ParameterEncoding = .JSON, callback: (response: ResponseApi) -> Void){
        
        var header : [String:String]? = nil
        
        if(isAuth){
            
            header = [Constants.Api.HeadType.kAuthorization: String(format: Constants.Api.ParamsType.kAuthorization,(OAuthAccessTokenKeychainStore().retrieveAccessToken()?.accessToken)!)]
        }
        
        Alamofire.request(method, url, parameters: parameters, headers:header, encoding: encoding)
            .responseJSON { response in
                
//                                if let JSON = response.result.value {
//                                    debugPrint("JSON: \(JSON)")
//                                }
                
                let r = ResponseApi()
                
                let httpCode = response.response != nil ? code(rawValue: (response.response?.statusCode)!)! : .error
                
                r.httpCode = httpCode
                r.success = r.httpCode.rawValue >= 200 &&  r.httpCode.rawValue <= 299 ? true : false
                r.data = response.data
                
                if(r.httpCode == .httpUnauthorized401){
                    self.refreshToken(method, url: url, callback: callback)
                }else{
                    callback(response: r)
                }
        }
    }
    
    private func refreshToken(method : Alamofire.Method, url : String, parameters: [String: AnyObject]? = nil, callback: (response: ResponseApi) -> Void){
        
        let tokenURL = NSURL(string: Constants.Api.User.kAuth)!
        let heimdallr = Heimdallr(tokenURL: tokenURL)
        
        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: url)!)
        
        heimdallr.authenticateRequest(request) { result in
            
            switch result {
            case .Success(let request):
                debugPrint("success: \(request)")
                
                self.request(method, url: url, callback: callback)

            case .Failure(let error):
                debugPrint("failure: \(error.localizedDescription)")
              
                let r = ResponseApi()
                r.httpCode = code.httpUnauthorized401
                
                dispatch_async(dispatch_get_main_queue()) {
                    callback(response: r)
                }

            }
        }
    }

}