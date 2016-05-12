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
import CoreLocation
import GoogleMaps

class SubmitChecklistViewController: BaseViewController {
    @IBOutlet weak var googleMaps: GMSMapView!
    
    @IBOutlet weak var cepLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    var address: Address!
    
    func backToRoot(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.addressLabel.text = address.label
        self.streetLabel.text = address.address + "," + address.number + " " + address.neighborhood
        self.cepLabel.text = address.zipCode

        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(SubmitChecklistViewController.backToRoot))
        self.navigationItem.setHidesBackButton(true, animated: false)
        let location = CLLocationCoordinate2D(latitude: self.address.latitude, longitude: self.address.longitude)
        self.setLocationInMap(location)
        ApiVerificationClient().getNearbies(self.address) { (validationData, response) in
            print(response)
            
            for validationItem in (validationData?.data)! {
                
                let address = validationItem.address!
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude)
                marker.icon = UIImage.init(named: "pinVerdeCopy")
                marker.map = self.googleMaps
            }
        }
    }
    
    func setLocationInMap(cordinate: CLLocationCoordinate2D){
        
        let camera = GMSCameraPosition.cameraWithLatitude(cordinate.latitude,longitude: cordinate.longitude, zoom: 16)
        googleMaps.camera = camera
        googleMaps.userInteractionEnabled = true
        
        let marker = GMSMarker()
        marker.position = cordinate
        marker.icon = UIImage.init(named: "pin1")
        
        
        marker.map = googleMaps
        
    }


}
