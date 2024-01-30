import UIKit
/*:
## Concepts to Know
 Before we get into Communications, there are some key concepts you need to be familiar with in order to write effective communications code in Swift.
 ### Closure
* You should already know what a **closure** is - any block of code in {}.  You can include a closure as a parameter -
*/
func passMeSomethingToDo(_ somethingToDo:() -> String) {
   let workResult = somethingToDo()
   print(workResult)
}

passMeSomethingToDo(
    {
   var myStr = ""
   for xx in 1...10 {
       myStr = myStr + String(xx)
   }
   return(myStr)
    }
)
/*:
### Trailing closures
 If the last parameter to a function is a closure, Swift lets you use special syntax called **trailing closure syntax**. Rather than pass in your closure as a parameter, you pass it directly after the function inside braces.
*/
passMeSomethingToDo()
    {
       let one = 1
       let two = 2
       let output = "Testing\(one), \(two)"
       return(output)
    }

//:  ### Completion handler
//: A closure that gets passed to a function as an argument and then called when that function is *done*.  Uncomment the line below to see an example of this.
// let task = URLSession.shared.dataTask(with: <#T##URLRequest#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
//:    Most of the time you will write this type of call using a **trailing closure**, like this:
let urlReq = URLRequest(url: URL(string: "https://duke.edu")!)
let task = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
   print("done!")
   let xxx = data
   let rep = response
   let er = error
   let xx = 1
    return
}
/*: ### Dispatch queues
 FIFO queues to which your application can submit tasks in the form of block objects (closures). Dispatch queues execute tasks either serially or concurrently.  Here are some examples from the Apple documentation:
  * main - A system-provided dispatch queue that schedules tasks for serial execution on the app's main thread.
  * global - A system-provided dispatch queue that schedules tasks for concurrent execution.
  * serial- A custom dispatch queue that schedules tasks for serial execution on an arbitrary thread.
  * concurrent - A custom dispatch queue that schedules tasks for concurrent execution.
*/
//: ### `@escaping`
//:  A keyword used to inform callers of a function that takes a closure that the closure might be stored or otherwise outlive the scope of the receiving function. This means that the caller must take precautions against retain cycles and memory leaks. It also tells the Swift compiler that this is intentional.
public func delay(bySeconds seconds: Double, closure: @escaping () -> Void) {
   let dispatchTime = DispatchTime.now() + seconds
   DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: closure)
}

func printCompleteMsg() -> Void {
    print("complete")
}

delay(5.0, closure: { printCompleteMsg() })
