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

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var next: UIButton!
    @IBOutlet weak var name: CustomTextField!

    @IBOutlet weak var nameWarning: UILabel!
    @IBOutlet weak var email: CustomTextField!
    @IBOutlet weak var emailWarning: UILabel!
    @IBOutlet weak var password: CustomTextField!
    @IBOutlet weak var passwordWarning: UILabel!
    @IBOutlet weak var confirmPassword: CustomTextField!
    @IBOutlet weak var confirmPasswordWarning: UILabel!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        next.layer.cornerRadius = 5
        
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
 
        let tapGestureScroll = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.tapScroll))
        scroll.addGestureRecognizer(tapGestureScroll)
        
    }
    
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        var contentInset:UIEdgeInsets = self.scroll.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scroll.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsetsZero
        scroll.contentInset = contentInset
    }
    
    func tapScroll(){
    
        view.endEditing(true)
    
    }
    
    @IBAction func avatarAction(sender: AnyObject) {
        underDevelopment(self)
        
    }
    
    @IBAction func facebookAction(sender: AnyObject) {
        underDevelopment(self)

    }

    @IBAction func nextAction(sender: AnyObject) {

        if(isValid()){
            checkEmail()
        }
    }
    
    func checkEmail(){

        ApiUserClient().checkEmail(email.text!) { (response) in
            
            if(response.httpCode == .httpNotFound404){
                self.signUp()
            }else{
                self.emailWarning.text = "email já cadastrado"
                Animation.fade(self.emailWarning, hidden: false)
            }
        }
    }
    
    func signUp(){
  
        showLoading()
        
        let user: User = User()
        
        user.password = password.text!
        user.name = name.text!
        user.email = email.text!
        
        ApiUserClient().signUp(user, callback: { (response) in
            
            if(!response.success){
                self.didNotSignUp(response)
            }else{
                self.didSignUp()
            }
        })
    }

    func isValid() -> Bool{
   
        self.view.endEditing(true)
        
        if(name.text != ""){
            
            Animation.fade(nameWarning, hidden: true)
            
        }else{
            
            Animation.fade(nameWarning, hidden: false)
            return false

        }
        
        if(email.text != "" && (email.text?.isEmailValid)!){
            
            Animation.fade(emailWarning, hidden: true)
            
        }else{
            
            self.emailWarning.text = "email inválido"
            Animation.fade(emailWarning, hidden: false)
            return false
            
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
    
    func didSignUp(){
    
        ApiUserClient().auth(email.text!, password: password.text!, callback: { (response) in
            
            self.hideLoading()
            
            if(response.success){
                    
                    self.userInfo()

                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
                    let viewController: MenuDrawViewController = mainStoryboard.instantiateInitialViewController() as! MenuDrawViewController
                    viewController.mainSegueIdentifier = "addressSegue"
                    UIApplication.sharedApplication().keyWindow!.rootViewController = viewController
                    
                }else{
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
    }
    
    func didNotSignUp(response: ResponseApi){
        
        hideLoading()
        
        switch response.httpCode {
            case .networkNotConnect:
            self.alert(Constants.App.message.warning, message: Constants.App.message.networkError, instance: self)
        case .httpInternalError500:
            self.alert(Constants.App.message.warning, message: "Não foi possível efetuar o cadastro, tente novamente!!", instance: self)
        default:
            self.alert(Constants.App.message.warning, message: Constants.App.message.defaultError, instance: self)

        }
    }
    
    // MARK: UITextViewDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if (textField == self.name) {
            self.email.becomeFirstResponder()
        }
        
        if (textField == self.email) {
            self.password.becomeFirstResponder()
        }
        
        if (textField == self.password) {
            self.confirmPassword.becomeFirstResponder()
        }
        
        if (textField == self.confirmPassword) {
            nextAction(self.confirmPassword)
        }
        
        return true
    }
    
    override func showLoading() {
        
        next.backgroundColor = Constants.App.colors.greyish
        next.enabled = false
        loading.startAnimating()
        loading.hidden = false
    }
    
    override func hideLoading() {
        
        next.backgroundColor = Constants.App.colors.sea
        next.enabled = true
        loading.stopAnimating()
        loading.hidden = true
    }
}