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

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var login: UIButton!
    
    @IBOutlet weak var email: CustomTextField!
    @IBOutlet weak var password: CustomTextField!
    
    @IBOutlet weak var emailWarning: UILabel!
    @IBOutlet weak var passwordWarning: UILabel!

    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login.layer.cornerRadius = 5
        login.layer.borderWidth = 1
        login.layer.borderColor = Constants.App.colors.darkishPink.CGColor
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let tapGestureScroll = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.tapView))
        view.addGestureRecognizer(tapGestureScroll)

    }
    
    @IBAction func facebookAction(sender: AnyObject) {
        underDevelopment(self)
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        
        if(isValid()){
            
            showLoading()
            ApiUserClient().auth(email.text!, password: password.text!, callback: { (response) in
                
                if(!response.success){
                    self.didNotLogin(response)
                }else{
                    self.didLogin()
                }
            })
        }
    }
    
    func tapView(){
        
        view.endEditing(true)
        
    }
    
    func isValid() -> Bool{
        
        self.view.endEditing(true)
        
        if(email.text != "" && (email.text?.isEmailValid)!){
            
            Animation.fade(emailWarning, hidden: true)
            
        }else{
            
            Animation.fade(emailWarning, hidden: false)
            return false
            
        }
        
        if(password.text != ""){
            
            Animation.fade(passwordWarning, hidden: true)
            
        }else{
            
            Animation.fade(passwordWarning, hidden: false)
            return false
        }
        
        return true
        
    }
    
    func didNotLogin(response : ResponseApi){
        
        hideLoading()
        
        switch response.httpCode {
        case .networkNotConnect:
            self.alert(Constants.App.message.warning, message: Constants.App.message.networkError, instance: self)
        default:
            self.alert(Constants.App.message.warning, message: "Email ou senha inválidos!!", instance: self)
        }
    }
    
    func didLogin(){
        
        userInfo()
        
        hideLoading()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        let viewController = mainStoryboard.instantiateInitialViewController()
        UIApplication.sharedApplication().keyWindow!.rootViewController = viewController
        
    }
    
    // MARK: UITextViewDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if (textField == self.email) {
            self.password.becomeFirstResponder()
        }
        
        if (textField == self.password) {
            loginAction(self.password)
        }
        
        return true
    }
    
    override func showLoading() {
        
        login.layer.borderColor = Constants.App.colors.greyish.CGColor
        login.enabled = false
        loading.startAnimating()
        loading.hidden = false
    }
    
    override func hideLoading() {

        login.layer.borderColor = Constants.App.colors.darkishPink.CGColor
        login.enabled = true
        loading.stopAnimating()
        loading.hidden = true
    }
}