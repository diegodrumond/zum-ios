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

class ForgotPassViewController: BaseViewController {

    @IBOutlet weak var email: CustomTextField!
    @IBOutlet weak var emailWarning: UILabel!
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        send.layer.cornerRadius = 5
    }

    func isValid() -> Bool{
        
        self.view.endEditing(true)
        self.emailWarning.text = "e-mail inválido"
        
        if(email.text != "" && (email.text?.isEmailValid)!) {
            Animation.fade(emailWarning, hidden: true)
        }else{
            Animation.fade(emailWarning, hidden: false)
            return false
        }
        
        return true
    }
    
    @IBAction func sendAction(sender: AnyObject) {
        
        if(isValid()) {
            
            showLoading()
            
            ApiUserClient().forgotPassword(email.text!) { (response) in
                
                self.hideLoading()
                
                if(response.httpCode == .httpAccepted200){
                    
                    self.alert("", message: "Enviado com sucesso! Chegará no seu e-mail ou mensagem o código para redefinir sua senha", instance: self, completion: { 
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                    
                }else{
                    self.emailWarning.text = "e-mail não cadastrado"
                    Animation.fade(self.emailWarning, hidden: false)
                }
            }
        }
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
        loading.hidden = true
    }
}