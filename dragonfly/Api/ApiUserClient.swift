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

import Heimdallr
import Alamofire

public class ApiUserClient: ApiClient {
    
    public func auth(username: String, password: String, callback: (response : ResponseApi) -> Void){
        
        let credentials = OAuthClientCredentials(id: Constants.Api.Auth.kId, secret: Constants.Api.Auth.kSecret)
        
        let tokenURL = NSURL(string: Constants.Api.User.kAuth)!
        let heimdallr = Heimdallr(tokenURL: tokenURL, credentials: credentials)
        
        heimdallr.requestAccessToken(username: username, password: password) { result in
           
            dispatch_async(dispatch_get_main_queue(),{
                
                switch result {
                    
                case .Success:
                 
                    Settings.isAuth = true

                    let response: ResponseApi = ResponseApi()
                    response.success = true
                    callback(response: response)
                    
                case .Failure:
                    
                    let response: ResponseApi = ResponseApi()
                    response.success = false
                    response.httpCode = code.httpUnauthorized401
                    callback(response: response)
                }
            })
        }
    }
    
    public func me(callback : (user : User?, response : ResponseApi) -> Void){
        
        self.requestUrl(.GET, url: Constants.Api.User.kMe) { (response) in
   
        if(response.success){
                let user : User = User(JSONData: response.data!)!
                callback(user: user, response: response)
            }else{
                callback(user: nil, response: response)
            }
        }
    }
    
    public func signUp(user: User, callback: (response : ResponseApi) -> Void){
        
        let parameters = [Constants.Api.ParamsType.kName: user.name,
                          Constants.Api.ParamsType.kEmail: user.email,
                          Constants.Api.ParamsType.kPassword: user.password]
        
        self.requestUrl(.POST, url: Constants.Api.User.kSignUp, parameters: parameters, isAuth: false) { (response) in
            
            callback(response: response)
        }
    }
    
    public func checkEmail(email: String, callback: (response : ResponseApi) -> Void){
        
        let parameters = [Constants.Api.ParamsType.kEmail: email]
        
        self.requestUrl(.GET, url: Constants.Api.User.kCheckEmail, parameters: parameters, isAuth: false, encoding: .URL) { (response) in
  
                callback(response: response)
        }
    }
    
    public func forgotPassword(email: String, callback: (response : ResponseApi) -> Void){
        
        let parameters = [Constants.Api.ParamsType.kEmail: email]
        
        self.requestUrl(.POST, url: Constants.Api.User.kForgotPassword, parameters: parameters, isAuth: false) { (response) in
            
            callback(response: response)
        }
    }
    
    public func redefinePassword(token: String, password: String, callback: (response : ResponseApi) -> Void) {
        
        let parameters = [Constants.Api.ParamsType.kRepeatPassword: password,
                         Constants.Api.ParamsType.kNewPassword: password ]
        
        self.requestUrl(.POST, url: Constants.Api.User.kResetPassword + "?" + Constants.Api.ParamsType.kToken + "=" + token, parameters: parameters, isAuth: false) { (response) in
            
            callback(response: response)
        }
    }
}