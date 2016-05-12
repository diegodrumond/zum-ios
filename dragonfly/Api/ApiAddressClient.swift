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

public class ApiAddressClient: ApiClient {

    public func list(page: Int, rows: Int, callback: (addressData : AddressData?, response : ResponseApi) -> Void){
        
        let parameters = [Constants.Api.ParamsType.kPage: page,
                          Constants.Api.ParamsType.kRows: rows]
        
        self.requestUrl(.GET, url: Constants.Api.Address.kUrl, parameters: parameters, encoding: .URL) { (response) in
                    
            if(response.success){
                let addressData : AddressData = AddressData(JSONData: response.data!)!
                callback(addressData: addressData, response: response)
            }else{
                callback(addressData: nil, response: response)
            }
        }
    }
    
    public func new(address: Address, callback: (response : ResponseApi) -> Void){
        
        let parameters = [Constants.Api.ParamsType.kLabel: address.label,
                          Constants.Api.ParamsType.kLatitude: address.latitude,
                          Constants.Api.ParamsType.kLongitude: address.longitude,
                          Constants.Api.ParamsType.kCity: address.city,
                          Constants.Api.ParamsType.kZipCode: address.zipCode,
                          Constants.Api.ParamsType.kState: address.state,
                          Constants.Api.ParamsType.kComplement: address.complement,
                          Constants.Api.ParamsType.kAddress: address.address,
                          Constants.Api.ParamsType.kNeighborhood: address.neighborhood,
                          Constants.Api.ParamsType.kNumber: address.number,
                          Constants.Api.ParamsType.kCountry: address.country]
        
        self.requestUrl(.POST, url: Constants.Api.Address.kUrl, parameters: parameters as? [String : AnyObject]) { (response) in
            
            callback(response: response)
        }
        
    }
    
    public func getAddress(idAddress: Int, callback: (address : Address?, response : ResponseApi) -> Void){
        
        
        let url=String (format: Constants.Api.Address.kGet, idAddress)
        
        self.requestUrl(.GET, url: url, parameters: nil, encoding: .URL) { (response) in
            
            if(response.success){
                let address : Address = Address(JSONData: response.data!)!
                callback(address: address, response: response)
            }else{
                callback(address: nil, response: response)
            }
        }
    }
}