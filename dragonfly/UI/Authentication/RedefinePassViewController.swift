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

class RedefinePassViewController: BaseViewController {
    
    var code : String = ""
    @IBOutlet weak var token: CustomTextField!
    @IBOutlet weak var tokenWarning: UILabel!
    @IBOutlet weak var password: CustomTextField!
    @IBOutlet weak var passwordWarning: UILabel!
    @IBOutlet weak var confirmPassword: CustomTextField!
    @IBOutlet weak var confirmPasswordWarning: UILabel!
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token.text = code
        send.layer.cornerRadius = 5
    }
    
    @IBAction func sendAction(sender: AnyObject) {
        
        if (isValid()) {
            showLoading()
            
            ApiUserClient().redefinePassword(token.text!, password: password.text!, callback: { (response) in
                self.hideLoading()
                
                if(response.success){
                    
                    self.alert("", message: "Senha redefinida com sucesso.", instance: self, completion: {
                        
                        self.redirectToLogin()
                    })
                }else{
                
                    self.didFailLoadData(response)
                }
            })
        }
    }
    
    func didFailLoadData(response : ResponseApi){
        
        switch response.httpCode {
        case .networkNotConnect:
            self.alert(Constants.App.message.warning, message: Constants.App.message.networkError, instance: self)
            
        default:
            self.alert(Constants.App.message.warning, message: "Email ou senha inválidos!!", instance: self)
        }
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        
        self.redirectToLogin()

    }
 
    func isValid() -> Bool{
        
        self.view.endEditing(true)
        
        if(token.text == ""){

            Animation.fade(tokenWarning, hidden: false)
            return false
            
        }else{
            Animation.fade(tokenWarning, hidden: true)
        }
    
        if(password.text != ""){
            
            if(password.text?.characters.count < 6){
                
                self.passwordWarning.text = "senha deve conter o mínimo de 6 caracteres"
                Animation.fade(passwordWarning, hidden: false)
                return false
                
            }else{
                Animation.fade(passwordWarning, hidden: true)
            }
            
        }else{
         
            self.passwordWarning.text = "senha inválida"
            Animation.fade(passwordWarning, hidden: false)
            return false
        }
        
        if(confirmPassword.text != ""){
            
            Animation.fade(confirmPasswordWarning, hidden: true)
            
        }else{
            
            Animation.fade(confirmPasswordWarning, hidden: false)
            return false
        }
        
        if(password.text != confirmPassword.text){
            
            self.confirmPasswordWarning.text = "Campos de senha e confirmar senha não conferem"
            Animation.fade(confirmPasswordWarning, hidden: false)
            
            password.text = ""
            confirmPassword.text = ""
            
            return false
            
        }else{
            Animation.fade(confirmPasswordWarning, hidden: true)
            self.confirmPasswordWarning.text = "senha inválida"
        }
        
        return true
    }
    
    func redirectToLogin(){
    
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        let viewController = mainStoryboard.instantiateInitialViewController()
        UIApplication.sharedApplication().keyWindow!.rootViewController = viewController

    }

    override func showLoading() {
        
        send.backgroundColor = Constants.App.colors.greyish
        send.enabled = false
        loading.startAnimating()
        loading.hidden = false
    }
    
    override func hideLoading() {
        
        send.backgroundColor = Constants.App.colors.sea
        send.enabled = true
        loading.stopAnimating()
    }
    
}
