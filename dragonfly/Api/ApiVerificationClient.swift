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

public class ApiVerificationClient: ApiClient{
    
    
    
    
     public func verification(idAddress: Int, checkListItens: [CheckList], callback: (response : ResponseApi) -> Void){
        
        let checkListItensIds = checkListItens.map { (item) -> Int in
            return item.id
        }
        
        let parameters = [Constants.Api.ParamsType.kAddressID: idAddress,
                          Constants.Api.ParamsType.kVerifiedItems: checkListItensIds]
        
        self.requestUrl(.POST, url: Constants.Api.Verification.kUrl, parameters: parameters as? [String : AnyObject]) { (response) in
            
            callback(response: response)
        }
    }
    
    public func getNearbies(address: Address, callback: (ValidationData?, ResponseApi) -> Void){
        
        let parameters: [String: AnyObject] = [Constants.Api.ParamsType.kLatitude: address.latitude,
                          Constants.Api.ParamsType.kLongitude: address.longitude]
        
        self.requestUrl(.GET, url: Constants.Api.Verification.kNearby, parameters: parameters, encoding: .URL ) { (response) in
            
            if response.success && response.data != nil {
                
                if let validationData = ValidationData(JSONData: response.data!) {
                    callback(validationData, response)
                }else {
                    callback(nil, response)
                }
            }else {
                callback(nil, response)
            }
        }
    }
    
    
    public func getLast(callback: (Validation?, ResponseApi) -> Void){
        
            self.requestUrl(.GET, url: Constants.Api.Verification.kLast, parameters: nil, encoding: .URL ) { (response) in
            
            if response.success && response.data != nil {
                
                if let validationData = Validation(JSONData: response.data!) {
                    callback(validationData, response)
                }else {
                    callback(nil, response)
                }
            }else {
                callback(nil, response)
            }
        }
    }

}