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
import GoogleMaps
import CoreLocation
import AddressBookUI

class CreateAddressViewController: BaseViewController, UITextViewDelegate {
    
    @IBOutlet var createButton: UIButton!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var nameWarning: UILabel!
    @IBOutlet var addressField: UITextField!
    @IBOutlet var addressWarning: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var googleMapView: GMSMapView!
    @IBOutlet var noAddressView: UIView!
    @IBOutlet var findView: UIView!
    
    var address = Address()
    var isFind = true
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateAddressViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateAddressViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        createButton.layer.cornerRadius = 5
        
        addressField.addTarget(self, action: #selector(CreateAddressViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        
        self.view.endEditing(true)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, frame.height, 0.0);
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }
    
    // MARK: UITextViewDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if (textField == self.nameField) {
            self.addressField.becomeFirstResponder()
        }
        
        if (textField == self.addressField) {
            checkFind()
        }
        
        return true
    }
    
    func textFieldDidChange(textField: UITextField) {
        buttonStatus(true)
    }
    
    @IBAction func findSaveAction(sender: AnyObject){
        checkFind()
    }
    
    func checkFind(){
    
        if(isFind){
            forwardGeocoding(addressField.text!)
        }else{
            save()
        }
    }
    
    func forwardGeocoding(address: String) {
        
        showLoading()
        
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            
            self.hideLoading()
            
            if error != nil {
                print(error)
                
                self.findView.hidden = true
                self.noAddressView.hidden = false
                self.googleMapView.hidden = true
                self.buttonStatus(true)
                
                return
            }
            
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                
                self.setLocationInMap(coordinate!)
                
            }else{
            
                self.findView.hidden = true
                self.noAddressView.hidden = false
                self.googleMapView.hidden = true
                self.buttonStatus(true)
            }
        })
    }
    
    func setLocationInMap(cordinate: CLLocationCoordinate2D){
    
        let camera = GMSCameraPosition.cameraWithLatitude(cordinate.latitude,longitude: cordinate.longitude, zoom: 16)
        googleMapView.camera = camera
        googleMapView.userInteractionEnabled = false
        
        let marker = GMSMarker()
        marker.position = cordinate
        marker.icon = UIImage.init(named: "pin1")
        
        getAddressForLatLng(cordinate)
        
        marker.map = googleMapView
       
        findView.hidden = true
        noAddressView.hidden = true
        googleMapView.hidden = false
        
        buttonStatus(false)
    }
    
    func getAddressForLatLng(cordinate: CLLocationCoordinate2D) {

    let aGMSGeocoder: GMSGeocoder = GMSGeocoder()
        
        aGMSGeocoder.reverseGeocodeCoordinate(cordinate) { (response, error) in
            
            let gmsAddress: GMSAddress = response!.firstResult()!

            self.address = Address()
            self.address.latitude = gmsAddress.coordinate.latitude
            self.address.longitude = gmsAddress.coordinate.longitude
            self.address.zipCode = gmsAddress.postalCode == nil ? "" : gmsAddress.postalCode!
            self.address.city = gmsAddress.locality == nil ? "" : gmsAddress.locality!
            self.address.neighborhood = gmsAddress.subLocality == nil ? "" : gmsAddress.subLocality!
            self.address.state = gmsAddress.administrativeArea == nil ? "" : gmsAddress.administrativeArea!.stringByReplacingOccurrencesOfString("State of ", withString: "")
            self.address.country = gmsAddress.country == nil ? "" : gmsAddress.country!

            self.address.number = self.address.parseNumber(gmsAddress.thoroughfare == nil ? "" : gmsAddress.thoroughfare!)
            
            self.address.address = self.address.parseStreet(gmsAddress.thoroughfare == nil ? "" : gmsAddress.thoroughfare!)
            }
    }
    
    func isValid() -> Bool{
        
        if(nameField.text != ""){
            
            Animation.fade(nameWarning, hidden: true)
            
        }else{
            
            Animation.fade(nameWarning, hidden: false)
            return false
            
        }
        
        if(addressField.text != ""){
            
            Animation.fade(addressWarning, hidden: true)
            
        }else{
            
            Animation.fade(addressWarning, hidden: false)
            return false
            
        }
        
        return true
    }
    
    func save(){
    
        if(!isValid()){
            return
        }
        
        showLoading()
        address.label = nameField.text!

        ApiAddressClient().new(address) { (response) in
           
            self.hideLoading()
            
            if(response.success){
                self.navigationController?.popViewControllerAnimated(true)
            }else{
                self.didFail(response)
            }
        }
    }
    
    func didFail(response: ResponseApi){
    
        switch response.httpCode {
        case .networkNotConnect:
            self.alert(Constants.App.message.warning, message: Constants.App.message.networkError, instance: self)
            
        case .httpInternalError500:
            self.alert(Constants.App.message.warning, message: "Não foi possível efetuar o cadastro, tente novamente!!", instance: self)
            
        case .httpUnauthorized401:
            self.unauthorizationAccess()

        default:
            self.alert(Constants.App.message.warning, message: Constants.App.message.defaultError, instance: self)
        }
    }
    
    func buttonStatus(setFind : Bool){
        
        UIView.animateWithDuration(Constants.App.timeAnimation.kFast, animations: { () -> Void in
            
            if(setFind){
                self.createButton.setTitle("Encontrar", forState: .Normal)
                self.createButton.backgroundColor = Constants.App.colors.denimBlue
                self.isFind = true
            }else{
                self.createButton.setTitle("Salvar", forState: .Normal)
                self.createButton.backgroundColor = Constants.App.colors.sea
                self.isFind = false
            }
            
        })
    }

    override func showLoading() {
        
        createButton.backgroundColor = Constants.App.colors.greyish
        createButton.enabled = false
        loading.startAnimating()
        loading.hidden = false
    }
    
    override func hideLoading() {
        
        createButton.backgroundColor = Constants.App.colors.sea
        createButton.enabled = true
        loading.stopAnimating()
        loading.hidden = true
    }
}