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

/*import Foundation
import UIKit

protocol AdressViewControllerExtension : NSObjectProtocol {
    
    var page: Int { get set }
    var numberPerPage: Int { get set }
    var addressData: AddressData { get set }
    var isPullToRefresh: Bool { get set }
    var refreshControl: UIRefreshControl { get }

    var tableView: UITableView { get set }
    
    func didFinishLoadData()
}

extension AdressViewControllerExtension {
    
    func loadData() {
        
        ApiAddressClient().list(page, rows: numberPerPage) { (addressData, response) in
            
            if(response.success){
                
                self.addressData.page = (addressData?.page)!
                self.addressData.size = (addressData?.size)!
                
                if(self.page == 1){
                    self.addressData.data = (addressData?.data)! as [Address]
                }else{
                    self.addressData.data += (addressData?.data)! as [Address]
                }
                self.page += 1
                self.tableView.reloadData()
                
            }else{
                self.didFailLoadData(response)
            }
            
            if(self.isPullToRefresh){
                self.refreshControl.endRefreshing()
            }
            
            self.didFinishLoadData()
            
            self.loadingFooter.hidden = true
            self.isPullToRefresh = false
        }
    }
    
    
    
    func pullToRefresh() -> Void{
        
        page = 1
        isPullToRefresh = true
        loadData()
    }
    
    func didFinishLoadData() {
        
       // loadingFooter.hidden = true

    }
    
    func didFailLoadData(response : ResponseApi){
        
        switch response.httpCode {
        case .networkNotConnect:
            self.alert(Constants.App.message.warning, message: Constants.App.message.networkError, instance: self)
            
        case .httpUnauthorized401:
            self.unauthorizationAccess()
            
        default:
            self.alert(Constants.App.message.warning, message: "Email ou senha inválidos!!", instance: self)
        }
    }
    
}
*/
