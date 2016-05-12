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

class Animation : UIView{
    
    static func fade(element : UIView, hidden: Bool) -> Void{
        
        if(element.alpha == 1 && hidden == false){
            
            UIView.animateWithDuration(Constants.App.timeAnimation.kFast, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                
                element.alpha = 0
                
                }, completion: { (Bool) -> Void in
                    UIView.animateWithDuration(Constants.App.timeAnimation.kFast, animations: { () -> Void in
                        
                        element.alpha = 1
                    })
            })
        }
        else{
            UIView.animateWithDuration(Constants.App.timeAnimation.kFast, animations: { () -> Void in
                
                if(hidden == false){
                    element.alpha = 1
                }else{
                    element.alpha = 0
                }
                
            })
        }
    }
}