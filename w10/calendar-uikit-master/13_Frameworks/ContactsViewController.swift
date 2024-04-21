//
//  ContactsViewController.swift
//  13_Frameworks
//
//  Created by Richard Telford on 4/5/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

func checkForContactsAccess(andThen f:(()->())? = nil) {
    let status = CNContactStore.authorizationStatus(for:.contacts)
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        CNContactStore().requestAccess(for:.contacts) { ok, err in
            if ok {
                DispatchQueue.main.async {
                    f?()
                }
            }
        }
    case .restricted:
        break
    case .denied:
        print("denied")
        break
    @unknown default:
        print("unknown error")
    }
}

class ContactsViewController : UIViewController, CNContactPickerDelegate, CNContactViewControllerDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func findMyself (_ sender: Any!) {
        checkForContactsAccess {
            DispatchQueue.global(qos: .userInitiated).async {
                var which : Int {return 1} // only supports case 1
                do {
                    let pred = CNContact.predicateForContacts(matchingName:"Ric")
                    var rics = try CNContactStore().unifiedContacts(matching:pred, keysToFetch: [
                        CNContactFamilyNameKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor
                    ])
                    rics = rics.filter{$0.familyName == "Telford"}
                    guard let me = rics.first else {
                        print("couldn't find myself")
                        return
                    }
                    print("The contact record looks like this:\n\(me).\nNow let's find the work email:\n")

                    let me2 = try CNContactStore().unifiedContact(withIdentifier: me.identifier, keysToFetch: [CNContactFamilyNameKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])
                    let emails = me2.emailAddresses
                    let workemails = emails.filter{$0.label == CNLabelWork}.map{$0.value}
                    let full = CNContactFormatterStyle.fullName
                    let keys = CNContactFormatter.descriptorForRequiredKeys(for:full)
                    let moi3 = try CNContactStore().unifiedContact(withIdentifier: me.identifier, keysToFetch: [keys, CNContactEmailAddressesKey as CNKeyDescriptor])
                    if let name = CNContactFormatter.string(from: moi3, style: full) {
                        if workemails.count > 0 {
                            print("\(name): \(workemails[0])")
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @IBAction func doCreate (_ sender: Any!) {
        checkForContactsAccess {
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let spongy = CNMutableContact()
                    spongy.givenName = "SpongeBob"
                    spongy.familyName = "SquarePants"
                    let email = CNLabeledValue(label: CNLabelHome, value: "sponge@bikinibottom.com" as NSString)
                    spongy.emailAddresses.append(email)
                    spongy.imageData = UIImage(named:"SB")!.pngData()
                    let save = CNSaveRequest()
                    save.add(spongy, toContainerWithIdentifier: nil)
                    try CNContactStore().execute(save)
                } catch {
                    print(error)
                }
                DispatchQueue.main.async {
                    debugAlert(VC: self, title: "Success!", msg: "Created SpongeBob!")
                }
            }
        }
    }
    
    @IBAction func doPeoplePicker (_ sender: Any!) {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        do {
            picker.displayedPropertyKeys = [CNContactEmailAddressesKey]
            //            picker.predicateForSelectionOfProperty = NSPredicate(format: "key == 'emailAddresses'")
            picker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
            //            picker.predicateForSelectionOfContact = NSPredicate(format: "emailAddresses.@count > 0")
        }
        self.present(picker, animated:true)
    }
 
    func contactPicker(_ picker: CNContactPickerViewController, didSelect con: CNContact) {
        print("Selected this Contact:")
        print("\(con.givenName) \(con.familyName)")
    }
 
    func contactPicker(_ picker: CNContactPickerViewController, didSelect prop: CNContactProperty) {
        print("Selected this Property:")
        print(prop.key)
    }
    
    @IBAction func doViewPerson (_ sender: Any!) {
        DispatchQueue.global(qos: .userInitiated).async {
            var sponge : CNContact!
            let status = CNContactStore.authorizationStatus(for:.contacts)
            if status == .authorized {
                print("getting from store")
                do {
                    let pred = CNContact.predicateForContacts(matchingName: "SpongeBob")
                    let keys = CNContactViewController.descriptorForRequiredKeys()
                    let sponges = try CNContactStore().unifiedContacts(matching: pred, keysToFetch: [keys])
                    guard let sponge1 = sponges.first else {
                        print("no SpongeBob")
                        return
                    }
                    sponge = sponge1
                    let d = try NSKeyedArchiver.archivedData(withRootObject: sponge!, requiringSecureCoding: false)
                    let ud = UserDefaults.standard
                    ud.set(d, forKey:"sponge")
                } catch {
                    print (error)
                }
            }
            else {
                print("no SpongeBob. Sorry.")
            }
            
            let vc = CNContactViewController(for:sponge)
            vc.delegate = self
            vc.message = "Nyah ah ahhh"
            vc.allowsActions = false
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func contactViewController(_ vc: CNContactViewController, didCompleteWith con: CNContact?) {
        print(con as Any)
        self.dismiss(animated: true) // needed for `forNewContact`, does no harm in the others
    }
    
    func contactViewController(_ vc: CNContactViewController, shouldPerformDefaultActionFor prop: CNContactProperty) -> Bool {
        print("Tapped  a property.  won't print it because sometimes causes a crash.)")
        return false
    }
    
    @IBAction func doNewPerson (_ sender: Any!) {
        let con = CNMutableContact()
        con.givenName = "Ric"
        con.familyName = "Telford"
        con.emailAddresses.append(CNLabeledValue(label: CNLabelWork, value: "rt113@duke.edu" as NSString))
        con.imageData = UIImage(named:"rt113")!.pngData()
        let npvc = CNContactViewController(forNewContact: con)
        npvc.delegate = self
        self.present(UINavigationController(rootViewController: npvc), animated:true)
    }
    
    @IBAction func doUnknownPerson (_ sender: Any!) {
        let con = CNMutableContact()
        con.givenName = "Rishi"
        con.familyName = "Ravula"
        con.phoneNumbers.append(CNLabeledValue(label: "Duke Mobile Center:", value: CNPhoneNumber(stringValue: "555-123-4567")))
        let unkvc = CNContactViewController(forUnknownContact: con)
        unkvc.message = "ECE564 TA"
        unkvc.contactStore = CNContactStore()
        unkvc.delegate = self
        unkvc.allowsActions = true  // false does not allow message, etc.
        self.navigationController?.pushViewController(unkvc, animated: true)
    }
}
