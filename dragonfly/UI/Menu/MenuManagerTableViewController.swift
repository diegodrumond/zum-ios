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

class MenuManagerTableViewController: UITableViewController {
    
    var menus : [Menu] = [Menu]()
    var user : User!
    var header : MenuHeaderTableViewCell!
    var obsUserDataUpdate : NSObjectProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMenu(.verification)
        setMenu(.mylocations)
        setMenu(.historic)
        setMenu(.share)
        setMenu(.about)
        
     obsUserDataUpdate =   NSNotificationCenter.defaultCenter().addObserverForName(Constants.App.observer.userDataUpdate, object: nil, queue: nil) { notification in
            self.updateHeader()
        }
    }
    
    @IBAction func tapProfile(sender: AnyObject) {
        BaseViewController().underDevelopment(self)
    }

    func changeController(cell : Menu){
        
        if let drawerController = self.parentViewController as? KYDrawerController {
            
            let mainNavigation = UIStoryboard(name: "Menu", bundle: nil).instantiateViewControllerWithIdentifier(cell.segue)
            drawerController.mainViewController = mainNavigation
            drawerController.setDrawerState(.Closed, animated: true)
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(obsUserDataUpdate)
    }
    
    func setMenu(type : typeMenu){
      
        let menu : Menu = Menu()
        menu.type = type
        
        switch type {
            
        case .verification:
            menu.name = "Verificar"
            menu.icon = "verificar.pdf"
            menu.segue = "verificationSegue"

        case .mylocations:
            menu.name = "Meus locais"
            menu.icon = "meusLocais.pdf"
            menu.segue = "addressSegue"

        case .historic:
            menu.name = "Histórico de verificações"
            menu.icon = "historicoDeVerificacoes"
            menu.segue = "historicSegue"

        case .share:
            menu.name = "Convidar amigos"
            menu.icon = "convidarAmigo.pdf"
            menu.segue = "shareSegue"

        case .about:
            menu.name = "About"
            menu.icon = "about.pdf"
            menu.segue = "aboutSegue"

        default:
            return
        }
    
        menus.append(menu)
    }
    
    func updateHeader(){
        
        header.setData()
    }

    // MARK: UITableViewDelegate UITableViewDataSource

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 170
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        header = tableView.dequeueReusableCellWithIdentifier("headerCell") as! MenuHeaderTableViewCell
        header.setData()
        
        let tapGestureProfile = UITapGestureRecognizer(target: self, action: #selector(MenuManagerTableViewController.tapProfile(_:)))
        header.addGestureRecognizer(tapGestureProfile)
        
        return header
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 62
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : MenuTableViewCell = tableView.dequeueReusableCellWithIdentifier("menuCell") as! MenuTableViewCell
        let menuItem : Menu = menus[indexPath.row]
        
        if(indexPath.row == menus.count - 1){
            cell.separator.hidden = true
        }
        
        cell.setData(menuItem)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell : MenuTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! MenuTableViewCell

        switch cell.menu.type {
            
        case .historic:
            BaseViewController().underDevelopment(self)

        case .share:

            if let activityVC = Share().shareString("Conheça agora o aplicativo que te auxilia nas checagem de sua casa, vamos juntos exterminar o Aedes aegypt!!!"){
                self.presentViewController(activityVC, animated: true, completion: nil)
            }
            
        case .about:
            BaseViewController().underDevelopment(self)
            
        default:
            changeController(cell.menu)
        }
    }
}