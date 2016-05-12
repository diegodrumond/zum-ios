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
import KYDrawerController

public class BaseViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
//        self.navigationController?.navigationBar.backgroundColor = UIColor.redColor()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMenu(){
        
        if let drawerController = navigationController?.parentViewController as? KYDrawerController {
            drawerController.setDrawerState(.Opened, animated: true)
        }else{
            
            if let drawerController = parentViewController as? KYDrawerController {
                drawerController.setDrawerState(.Opened, animated: true)
            }else{
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
        }
    }
    
    public func alert(title: String, message: String, instance: UIViewController, completion: (() -> Void)? = nil){
    
        let alert = UIAlertController(title: title,
                                      message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: { (action) -> Void in
            if(completion != nil){
                completion!()
            }
        }))
        
        instance.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    public func underDevelopment(instance: UIViewController){
        
      alert(Constants.App.message.warning, message: "Funcionalidade em desenvolvimento!", instance: instance)
        
    }
    
    public func unauthorizationAccess(){
        
        alert(Constants.App.message.warning, message: "Acesso inválido, você será redirecionado para a tela de login. Faça novamente o login.", instance: self, completion: {
        
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let viewController = mainStoryboard.instantiateInitialViewController()
            UIApplication.sharedApplication().keyWindow!.rootViewController = viewController
            
            Settings.isAuth = false

        })
    }
    
    func userInfo(){
        
        ApiUserClient().me { (user, response) in
            
            if(response.success){
                
                Settings.userName = (user?.name)!
                Settings.userEmail = (user?.email)!
                
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.App.observer.userDataUpdate, object: nil)
                
            } else {
                debugPrint("userInfo error")
            }
        }
    }
    
    func showLoading(){
        debugPrint("implement in subclass")
    }
    
    func hideLoading(){
        debugPrint("implement in subclass")
    }
}