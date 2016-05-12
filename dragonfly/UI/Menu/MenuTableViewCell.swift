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

import UIKit

public class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var icon: UIImageView!
    var menu : Menu!
    
    func setData(menu : Menu){
        self.menu = menu
        name.text = menu.name
        icon.image = UIImage(named: menu.icon)
    }
    
    func didLogin(){
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        let viewController = mainStoryboard.instantiateInitialViewController()
        UIApplication.sharedApplication().keyWindow!.rootViewController = viewController;
    }
}
