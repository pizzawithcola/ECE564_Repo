//
//  CalendarViewController.swift
//  13_Frameworks
//
//  Created by Richard Telford on 4/5/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import MessageUI

let database = EKEventStore()

var log:String = ""

class CalendarViewController: UIViewController, EKEventViewDelegate, EKEventEditViewDelegate, EKCalendarChooserDelegate {
    var eventid : String!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var ccal: UIButton!
    @IBOutlet weak var editevent: UIButton!
    @IBOutlet weak var searchcal: UIButton!
    @IBOutlet weak var crevent: UIButton!
    @IBOutlet weak var eventvc: UIButton!
    @IBOutlet weak var cevent: UIButton!
    @IBOutlet weak var pickcal: UIButton!
    var database : EKEventStore {
        return _3_Frameworks.database
    }
    
    override func viewDidLoad() {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
        }
        betterButton(ccal)
        betterButton(eventvc)
        betterButton(searchcal)
        betterButton(crevent)
        betterButton(cevent)
        betterButton(pickcal)
        betterButton(editevent)
        log = textView.text + "\n"
    }
    
    //: MARK: Step 1 - Create Calendar
    @IBAction func createCalendar (_ sender: Any!) {
        checkForEventAccess {
            do {
                let locals = self.database.sources.filter {$0.sourceType == .local}
                guard let src = locals.first else {
                    self.printx("failed to find local source")
                    return
                }
                let cal = EKCalendar(for:.event, eventStore:self.database)
                cal.source = src
                cal.title = "ECE564"

                try self.database.saveCalendar(cal, commit:true)
                self.printx("Good! Now press Calendar Picker to see the new Calendar you created - ECE564.  Then you can Create Event.")
            } catch {
                self.printx("save calendar error: \(error)")
                return
            }
        }
    }
    
    //: MARK:  Step 2 - Show List of Calendars and optionally delete
    
    @IBAction func deleteCalendar (_ sender: Any!) {
        checkForEventAccess {
            
            let choo = EKCalendarChooser(
                selectionStyle:.single,
                displayStyle:.allCalendars,
                entityType:.event,
                eventStore:self.database)
            choo.showsDoneButton = true
            choo.showsCancelButton = true
            choo.delegate = self
            choo.navigationItem.prompt = "Pick a calendar to delete:"
            let nav = UINavigationController(rootViewController: choo)
            nav.modalPresentationStyle = .popover
            self.present(nav, animated: true)
            if let pop = nav.popoverPresentationController {
                if let v = sender as? UIView {
                    pop.sourceView = v
                    pop.sourceRect = v.bounds
                }
            }
            
        }
    }
        
    //: MARK: Step 3 - Create Simple Event
    @IBAction func createSimpleEvent (_ sender: Any!) {
        
        checkForEventAccess {
            
            do {
                
                guard let cal = self.calendar(name:"ECE564") else {
                    self.printx("failed to find calendar")
                    return
                }
                // form the start and end dates
                let greg = Calendar(identifier:.gregorian)
                var comp = DateComponents(year:2024, month:04, day:19, hour:11)
                let d1 = greg.date(from:comp)!
                comp.hour = comp.hour! + 3
                let d2 = greg.date(from:comp)!
                
                // form the event
                let ev = EKEvent(eventStore:self.database)
                ev.title = "Projects Due"
                ev.notes = "Must turn in on time!"
                ev.calendar = cal
                (ev.startDate, ev.endDate) = (d1,d2)
                
                // we can also easily add an alarm
                let alarm = EKAlarm(relativeOffset:-3600) // one hour before
                ev.addAlarm(alarm)
                
                // save it
                try self.database.save(ev, span:.thisEvent, commit:true)
                self.printx("Event Created - Now hit the button to create recurring event.")
                
            } catch {
                self.printx("save simple event \(error)")
                return
            }
            
            
        }
    }
    
    //: MARK:  Step 4 - Create Recurring Event
    @IBAction func createRecurringEvent (_ sender: Any!) {
        
        checkForEventAccess {
            
            do {
                
                guard let cal = self.calendar(name:"ECE564") else {
                    self.printx("failed to find calendar")
                    return
                }
                
                let everyTuesday = EKRecurrenceDayOfWeek(.tuesday)
                let april = 4 as NSNumber
                let recur = EKRecurrenceRule(
                    recurrenceWith:.yearly, // every year
                    interval:2, // no, every *two* years
                    daysOfTheWeek:[everyTuesday],
                    daysOfTheMonth:nil,
                    monthsOfTheYear:[april],
                    weeksOfTheYear:nil,
                    daysOfTheYear:nil,
                    setPositions: nil,
                    end:nil)
                
                print(recur)
                let ev = EKEvent(eventStore:self.database)
                ev.title = "Project Reviews"
                ev.addRecurrenceRule(recur)
                ev.calendar = cal
                // need a start date and end date
                let greg = Calendar(identifier:.gregorian)
                var comp = DateComponents(year:2024, month:04, hour:12)
                comp.weekday = 3 // Tuesday
                comp.weekdayOrdinal = 1 // *first* Sunday
                ev.startDate = greg.date(from:comp)!
                comp.hour = 13
                ev.endDate = greg.date(from:comp)!
                
                try self.database.save(ev, span:.futureEvents, commit:true)
                self.printx("Recurring Event created with no errors.  Now press Search to make sure we can find the Simple event.")
                
            } catch {
                self.printx("save recurring event \(error)")
                return
            }
            
            
        }
        
    }
    
    //:  MARK:  Step 5 - Search for the Event
    @IBAction func searchByRange (_ sender: Any!) {
        
        checkForEventAccess {
            
            guard let cal = self.calendar(name:"ECE564") else {
                self.printx("failed to find calendar")
                return
            }
            
            let greg = Calendar(identifier:.gregorian)
            let d = Date() // today
            let d1 = greg.date(byAdding:DateComponents(year:0), to:d)!
            let d2 = greg.date(byAdding:DateComponents(year:1), to:d)!
            print("from:", d1)
            print("to:", d2)
            let pred = self.database.predicateForEvents(withStart:
                                                            d1, end:d2, calendars:[cal])
            DispatchQueue.global(qos:.default).async {
                var events = [EKEvent]()
                self.database.enumerateEvents(matching:pred) { ev, stop in
                    events += [ev]
                    if ev.title.range(of:"Projects") != nil {
                        self.eventid = ev.calendarItemIdentifier
                        DispatchQueue.main.async {
                            self.printx("found 'Projects Due'.\n Below is the printout of the object itself.  Now you can press Event VC to see the event.  Also, Edit Event VC and Email VC are similar in that they give you a window to create a new event or email.\n\n")
                        }
                        // comment out next line to see all the events created in the examples
                        stop.pointee = true
                    }
                }
                events.sort { $0.compareStartDate(with:$1) == .orderedAscending }
                DispatchQueue.main.async {
                    self.printx(events.description)
                }
            }
        }
    }
    
    //: MARK:  Step 6 - Show the Simple Event
    
    @IBAction func showEventUI (_ sender: Any!) {
        checkForEventAccess {
            
            if self.eventid == nil {
                print("need to search for event first")
                return
            }
            let ev = self.database.calendarItem(withIdentifier:self.eventid) as! EKEvent
            
            let evc = EKEventViewController()
            evc.event = ev
            evc.allowsEditing = false
            evc.delegate = self
            self.present(evc, animated: true)
        }
    }
    
    func eventViewController(_ controller: EKEventViewController,
                             didCompleteWith action: EKEventViewAction) {
        print("did complete with action \(action.rawValue)")
        if action == .deleted {
            self.navigationController?.popViewController(animated:true)
        }
    }
    
    //:  MARK:  Step 7 - Edit Event VC
    @IBAction func editEvent (_ sender: Any!) {
        checkForEventAccess {
            
            let evc = EKEventEditViewController()
            evc.eventStore = self.database
            evc.editViewDelegate = self
            evc.modalPresentationStyle = .popover
            self.present(evc, animated: true)
            if let pop = evc.popoverPresentationController {
                if let v = sender as? UIView {
                    pop.sourceView = v
                    pop.sourceRect = v.bounds
                }
            }
            
        }
    }
    
    //:  MARK: Delegate methods
    
    func eventEditViewController(_ controller: EKEventEditViewController,
                                 didCompleteWith action: EKEventEditViewAction) {
        print("did complete: \(action.rawValue), \(controller.event as Any)")
        self.dismiss(animated:true)
    }
    
    func eventEditViewControllerDefaultCalendar(forNewEvents controller: EKEventEditViewController) -> EKCalendar {
        return self.calendar(name:"ECE564")!
    }

    
    func calendarChooserDidCancel(_ choo: EKCalendarChooser) {
        self.dismiss(animated:true)
    }
    
    func calendarChooserDidFinish(_ choo: EKCalendarChooser) {
        let cals = choo.selectedCalendars
        guard cals.count > 0 else { self.dismiss(animated:true); return }
        let calsToDelete = cals.map {$0.calendarIdentifier}
        let alert = UIAlertController(title:"Delete selected calendar?",
                                      message:nil, preferredStyle:.actionSheet)
        alert.addAction(UIAlertAction(title:"Cancel", style:.cancel))
        alert.addAction(UIAlertAction(title:"Delete", style:.destructive) {_ in
            for id in calsToDelete {
                if let cal = self.database.calendar(withIdentifier:id) {
                    try? self.database.removeCalendar(cal, commit: true)
                }
            }
            self.dismiss(animated:true) // dismiss *everything*
        })
        // alert sheet inside presented-or-popover
        choo.present(alert, animated: true)
    }
    
    //* MARK: Utility Functions
    
    func betterButton(_ button: UIButton){
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.frame = button.frame.insetBy(dx: -2,dy: -2)
        button.isHidden = false
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.font = UIFont(name: "American Typewriter", size: CGFloat(16))
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.setTitleColor(UIColor.yellow, for: .highlighted)
    }
    
    func calendar(name:String ) -> EKCalendar? {
        let cals = self.database.calendars(for:.event)
        return cals.filter {$0.title == name}.first
    }
    
    func printx(_ str: String) {
        log += str
        log += "\n"
        textView.text = log
    }
}
//: MARK:  utility to check access
func checkForEventAccess(andThen f:(()->())? = nil) {
    let status = EKEventStore.authorizationStatus(for:.event)
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        database.requestAccess(to:.event) { ok, err in
            if ok {
                DispatchQueue.main.async {
                    f?()
                }
            } else {
                print(err)
            }
        }
    case .restricted:
        // do nothing
        break
    case .denied:
        // do nothing, or beg the user to authorize us in Settings
        print("denied")
        break
    @unknown default:
        print("unknown error")
    }
}
