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


public class CheckList :PPJSONSerialization {
    
    public var id: Int = 0
    public var name: String = ""
//    public var descriptionItem: String = ""
    public var avalaible: Bool = false
    
    public var checked = false
}

public class AddressData : PPJSONSerialization {
   
    public var size: Int = 0
    public var page: Int = 0
    public var data: [Address] = [Address]()
    
}

public class Address : PPJSONSerialization {
    
    public var id: Int = 0
    public var label: String = ""
    public var latitude: Double = 0
    public var longitude: Double = 0
    public var city: String = ""
    public var zipCode: String = ""
    public var state: String = ""
    public var complement: String = ""
    public var address: String = ""
    public var neighborhood: String = ""
    public var number: String = ""
    public var country: String = ""
    public var checklistItems: [CheckList] = [CheckList]()



    func parseNumber(thoroughfare : String)-> String{
        var number = ""
        var hasValue = false
        
        // Loops thorugh the street
        for i in thoroughfare.characters {
            let str = String(i)
            // Checks if the char is a number
            if (Int(str) != nil){
                // If it is it appends it to number
                number+=str
                // Here we set the hasValue to true, beacause the street number will come in one order
                // 531 in this case
                hasValue = true
            }
            else{
                // Lets say that we have runned through 531 and are at the blank char now, that means we have looped through the street number and can end the for iteration
                if(hasValue){
                    break
                }
            }
        }
        return number
    }
    
    func parseStreet(thoroughfare : String)-> String{
        let str = thoroughfare
        let streetNumber = str.componentsSeparatedByCharactersInSet(
            NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
        print(streetNumber)
        
        var address = thoroughfare
        var hasValue = false
        
        // Loops thorugh the street
        for i in thoroughfare.characters {
            let str = String(i)
            // Checks if the char is a number
            if (Int(str) != nil){
                // If it is it appends it to number
                address = address.stringByReplacingOccurrencesOfString(str, withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                // Here we set the hasValue to true, beacause the street number will come in one order
                // 531 in this case
                hasValue = true
            }
            else{
                // Lets say that we have runned through 531 and are at the blank char now, that means we have looped through the street number and can end the for iteration
                if(hasValue){
                    break
                }
            }
        }
        return address
    }
}
