import UIKit
import Foundation
import PlaygroundSupport
//: # Communications
/*:
 * Communications between an iOS device and another system can occur over any number of protocols, such as
     * HTTP - Internet protocol to communicate with web servers and other Internet-connected devices
 * Examples of others not covered today:
     * Bluetooth - communications with nearby devices of all types
     * Bonjour (Discover / Connect)
     * TCP / UDP (Low level Internet)
     * Peer-to-peer WiFi (Multipeer)
 */
/*:
 ## HTTP Sessions
 * An HTTP request is made through a `URLSession` object.
     * For simple case, `URLSession.shared` object is used
     * Otherwise, `init()` an `URLSession` with an `URLSessionConfiguration` object (defines the behavior and policies to use when uploading/downloading)
 */
let url = URL(string: "https://duke.edu")
let simpleSession = URLSession.shared
let session : URLSession = {
    let config = URLSessionConfiguration.ephemeral
    config.allowsCellularAccess = false
    let session = URLSession(configuration: config, delegate: nil, delegateQueue: .main)
    return session
}()

//: * `URLSession` can use a **Completion Handler** or a **Delegate Protocol**
//: * The delegate protocol approach allows notification as tasks are done asynchronously.
func urlSession(_ session: URLSession, downloadTask:URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    if let d = try? Data(contentsOf: location) {
        let im = UIImage(data:d)
        DispatchQueue.main.async {
           // self.iv.image = im
        }
    }
}
/*:
 ## HTTP - Simple Data, Upload and Download
 * For a given action, an `URLSessionTask` is used.
 * A URLSessionTask can be inititalized with just a `URL` object or a `URLRequest`.
 * The `URLRequest' object allows you to include any policies for the task in addition to the URL itself.  Policies, for example, like caching policy.
 * There are 3 kinds of session tasks:
     * `DataTask` – data is provided incrementally to the app as it arrives across the network, as Data
     * `DownloadTask` – data stored in a file and handed to the app
     * `UploadTask` – file is provided by app to upload
 */
let req = URLRequest(url: url!)
let task2 = session.downloadTask(with: req)
task2.resume()
/*:
 ## Using HTTP with REST APIs
 * REST is an acronym for *Representational State Transfer*
 * It is a way for two computer systems to communicate over **HTTP**, in a similar way to web browsers and servers.
 * REST APIs are stateless, meaning that each API call happens in isolation so includes all information required to execute the transaction.
 * The API is just an HTTP URL string, where the parameters are part of the URL
 */
var httpRESTCall = "https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=Duke%20University&format=json"
/*:
 ## HTTP, REST and JSON
 * As you know, **JSON** (JavaScript Object Notation) is a simple data interchange format
 * JSON is a popular data format to use with **REST** interfaces
 * HTTP, REST and JSON go together as an open way to query information, etc.
 `URLSession` and `JSONSerialization` are the key classes for sending/receiving using JSON.
 * If you enter the URL above into a browser, you can see the JSON that comes back.  Try it [here](https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=Duke%20University&format=json)
 */
/*:
## ECE564 JSON over HTTP
* We will be using the ECE564 JSON grammar to send information to a server. The complete spec for the ECE564 JSON grammar will be in the homework spec.

* The grammar includes a field for *picture*, which is an actual image 
    * The UIImage object needs to be saved as Data.
    * The Data in turn needs to be converted to base64.
    * base64 is a technique for turning binary data into printable characters only.
    * This ensures that the data can traverse any network without misinterpretation or data loss.
    * The binary stream is chopped into 6-bit blocks which are indices into a table of 64 printable characters (a-z, A-Z, 0-9, / and +)
    * The process is reversed coming back.
*/
// convert images to base64 images
func stringFromImage(_ imagePic: UIImage) -> String {
    let picImageData: Data = imagePic.jpegData(compressionQuality: 0.2)!
    let picBase64 = picImageData.base64EncodedString()
    return picBase64
}
/*:
 * Note:
I suggest you down sample the image to 2x2 inches or less, and 72 dpi to keep the String from being too long.  If you take a picture from a camera, I suggest using the "copy" method extension to UIImage I have in the Utilities file.
*/
/*:
 * Note:
You can test your base64 at [this web site](https://codebeautify.org/base64-to-image-converter).  You can test it out with the "base64pic" file in this repo.  Just copy and paste the entire string into the web site.
 */
class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}


// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
