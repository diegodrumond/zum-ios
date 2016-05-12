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

class AddressViewController: BaseViewController, AddAddressViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var page: Int = 1
    var numberPerPage: Int = 20
    var addressData: AddressData = AddressData()
    var isPullToRefresh: Bool = false
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var loadingFooter: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = HeaderView.loadFromNibNamed("HeaderView") as? HeaderView

        refreshControl.tintColor = Constants.App.colors.darkishPink
        refreshControl.contentMode = .ScaleAspectFill
        refreshControl.addTarget(self, action: #selector(AddressViewController.pullToRefresh), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        page = 1
        loadData()

    }
    
    @IBAction func showMenuTap(sender: AnyObject) {
        self.showMenu()
    }
    
    func pullToRefresh() -> Void{
        
        page = 1
        isPullToRefresh = true
        loadData()
    }
    
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
            self.loadingFooter.hidden = true
            self.isPullToRefresh = false
        }
    }
    
    func didFailLoadData(response : ResponseApi){
    
        switch response.httpCode {
        case .networkNotConnect:
            self.alert(Constants.App.message.warning, message: Constants.App.message.networkError, instance: self)
            
        case .httpUnauthorized401:
            self.unauthorizationAccess()
        
        default:
            self.alert(Constants.App.message.warning, message: Constants.App.message.defaultError, instance: self)
        }
    }
    
    // MARK: AddAddressViewDelegate
    
    func create() {
        self.performSegueWithIdentifier("addAddressSegue", sender: self)
    }
    
    // MARK: UITableViewDelegate UITableViewDataSource
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        return .Delete
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
            
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Editar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.underDevelopment(self)
        })
        
        editAction.backgroundColor = UIColor.grayColor()
        
        let removeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Remover" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.underDevelopment(self)
        })
        
        removeAction.backgroundColor = UIColor.redColor()
        
        return [removeAction, editAction]
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressData.data.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let addAddressView : AddAddressView = AddAddressView.loadFromNibNamed("AddAddressView") as! AddAddressView
        addAddressView.delegate = self
        
        return addAddressView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 90
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let  addressCell : AddressCell = tableView.dequeueReusableCellWithIdentifier("addressCell") as! AddressCell
        
        let address = addressData.data[indexPath.row]
        
        addressCell.setData(address)
        
        return addressCell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let count : Int = addressData.data.count
        
        if(indexPath.row == count - 1){
            
            if(addressData.size > count)
            {
                isPullToRefresh = true
                loadData()
                loadingFooter.hidden = false
            }
            else
            {
                loadingFooter.hidden = true
            }
        }
    }
}