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
import Fabric
import Crashlytics
import KYDrawerController
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var shorkutAction: Bool = false
    var shorkutSegue: String = "verificationSegue"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        
        // TODO: mudar chave
        GMSServices.provideAPIKey("AIzaSyBqFQz3MyEQgxvIdid7U9VI6q7Vf11q11I")

      initSystem()
        
        return true
    }
    
    func initSystem() {
       
        var vc: UIViewController
        
        //mock user access
        Settings.hasFirstAccess = false
        
        if(Settings.isAuth){
            
            let storyboard = UIStoryboard(name: "Menu", bundle: nil)
            let dVC : KYDrawerController = (storyboard.instantiateInitialViewController() as? KYDrawerController)!
            dVC.mainSegueIdentifier = shorkutSegue
            vc = dVC
            
        }else{
            
            if(Settings.hasFirstAccess){
                
                let storyboard = UIStoryboard(name: "Intro", bundle: nil)
                vc = storyboard.instantiateInitialViewController()!
            }else{
                
                let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
                vc = storyboard.instantiateInitialViewController()!
            }
        }
        
        if let window = self.window{
            UIApplication.sharedApplication().statusBarStyle = .LightContent
            window.rootViewController = vc
        }

    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
//        if(shorkutAction){
//            shorkutAction = false
//            initSystem()
//        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

//    @available(iOS 9.0, *)
//    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
//
//        if(shortcutItem.type == "com.hotmart.hackathon.dragonfly.verification"){
//        
//            shorkutSegue = "verificationSegue"
//            shorkutAction = true
//            return
//        }
//        
//        if(shortcutItem.type == "com.hotmart.hackathon.dragonfly.address"){
//            
//            shorkutSegue = "addressSegue"
//            shorkutAction = true
//            return    //        }
//    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        if(url.absoluteString.containsString("forgot")){
            if let string : String = url.absoluteString {
                
                let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
                let vc : RedefinePassViewController = storyboard.instantiateViewControllerWithIdentifier("reset_pwd") as! RedefinePassViewController
                
                if let range = string.rangeOfString(Constants.Api.ParamsType.kToken + "=") {
                    let value = string[range.endIndex ..< string.endIndex]
                    vc.code = value
                }
                
                if let window = self.window{
                    window.rootViewController = vc
                }
                return true
            }
        }
        return false
    }
}