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

class AddressCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var addressDesc: UILabel!
    @IBOutlet var zipCode: UILabel!
    
    var address: Address!
    
    func setData(address: Address){
        
        self.address = address
        
        name.text = address.label
        self.addressDesc.text = address.address + "," + address.number + " " + address.neighborhood
        zipCode.text = "CEP: " + address.zipCode
        
    }
}