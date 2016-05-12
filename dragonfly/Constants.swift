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
import UIKit

struct Constants {
    
    struct Api {
        
        static let kProduction = true
        static let kBaseVersionApi = "/v1"
        static let kBaseUrl = kProduction ? "http://api-hck.hotmart.com" : "???"
        static let kTypeApi = "/rest"
        
        static let kTimeout : Double = 30.0
        
        struct Context {
            
            static let kSecurity = "/security"
            static let kDragonfly = "/hack-dragonfly"
            
        }
        
        struct HeadType {
            
            static let kAuthorization = "Authorization"
            static let kContentType = "Content-Type"
        }
        
        struct ContentType {
            static let formUrlEncoded = "application/x-www-form-urlencoded"
            static let formData = "multipart/form-data"
            static let applicationJson = "application/json"
            
        }
        
        struct ParamsType {
            
            static let kAuthorization = "Bearer %@"
            static let kName = "name"
            static let kPassword = "password"
            static let kNewPassword = "newPassword"
            static let kRepeatPassword = "repeatPassword"
            static let kEmail = "email"
            static let kPage = "page"
            static let kRows = "rows"
            static let kLabel = "label"
            static let kLatitude = "lat"
            static let kLongitude = "lng"
            static let kCity = "city"
            static let kZipCode = "zipCode"
            static let kState = "state"
            static let kComplement = "complement"
            static let kAddress = "address"
            static let kNeighborhood = "neighborhood"
            static let kNumber = "number"
            static let kCountry = "country"
            static let kToken = "token"
            
            static let kAddressID = "addressId"
            static let kVerifiedItems = "verifiedItems"

            
        }
        
        struct Auth{
            
            static let kId = "e6bdeccb-7358-4997-b3c0-89640af12dde"
            static let kSecret = "d99cf154-1cdf-44b2-802f-e5c8bbe96698"
            
        }
        
       
        
        struct User {
            
            static let kUrl = kBaseUrl + Context.kSecurity + kTypeApi + kBaseVersionApi + "/user"
            static let kAuth = kBaseUrl + Context.kSecurity + "/oauth/token"
            static let kSignUp = kUrl + "/signup"
            static let kFacebookBind = kUrl + "/facebook/bind"
            static let kGet = kUrl + "/%i"
            static let kMe = kUrl + "/me"
            static let kCheckEmail = kUrl + "/check_email"
            static let kPassword = kUrl + "/password"
            static let kResetPassword = kPassword + "/reset"
            static let kForgotPassword = kPassword + "/forgot"
            static let kChangePassword = kPassword + "/change"
            
        }
        
        struct Address {
            
            static let kUrl = kBaseUrl + Context.kDragonfly + kTypeApi + kBaseVersionApi + "/address"
            static let kGet = kUrl + "/%i"
            
        }
        
        struct Checklist {
            
            static let kUrl = kBaseUrl + Context.kDragonfly + kTypeApi + kBaseVersionApi + "/checklist"
            
        }
        
        struct Verification {
            
            static let kUrl = kBaseUrl + Context.kDragonfly + kTypeApi + kBaseVersionApi + "/verification"
            static let kGet = kUrl + "/%i"
            static let kLast = kUrl + "/last"
            static let kNearby = kUrl + "/nearby"
            
        }
    }
    
    struct App {
        
        static let kShareLink = "https://www.hotmart.com/hackathon#"
        
        struct colors{
            static let denimBlue : UIColor = UIColor.colorWithRGBValue(59, greenValue: 89, blueValue: 152, alpha: 1)
            static let darkishPink : UIColor = UIColor.colorWithRGBValue(232, greenValue: 74, blueValue: 93, alpha: 1)
            static let greyish : UIColor = UIColor.colorWithRGBValue(179, greenValue: 179, blueValue: 179, alpha: 1)
            static let sea : UIColor = UIColor.colorWithRGBValue(60, greenValue: 163, blueValue: 140, alpha: 1)

        }
        
        struct timeAnimation {
            static let kFast = 0.25

        }
        
        struct message {
            static let warning = "Atenção =|"
            static let networkError = "Ocorreu um erro ao executar a operação, por favor verifique sua conexão com a internet e tente novamente!"
           static let defaultError = "Ocorreu um erro no servidor, tente novamente mais tarde."
        }
        
        struct observer {
            static let userDataUpdate = "userDataUpdate"
        }
    }
}