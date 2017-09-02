/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreData

class ViewController: UIViewController {

  // MARK: - Properties
  lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
  }()
  
  var managedContext: NSManagedObjectContext!
  var currentDog: Dog?

  // MARK: - IBOutlets
  @IBOutlet var tableView: UITableView!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    
    let dogName = "Fido"
    let dogFetch: NSFetchRequest<Dog> = Dog.fetchRequest()
    dogFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Dog.name), dogName)
    
    do {
      let result = try managedContext.fetch(dogFetch)
      if result.count > 0 {
        //Fido found, use Fido
        currentDog = result.first
      } else {
        //Fido not found, create Fido
        currentDog = Dog(context: managedContext)
        currentDog?.name = dogName
        try managedContext.save()
      }
    } catch let error as NSError {
      print("Fetch error: \(error) description: \(error.userInfo)")
    }
  }
}

// MARK: - IBActions
extension ViewController {

  @IBAction func add(_ sender: UIBarButtonItem) {
    //walks.insert(NSDate(), at: walks.index(before: 1))
    //walks.append(NSDate())
    
    // Insert a new Walk entity into CoreData
    let walk = Walk(context: managedContext)
    walk.date = NSDate()
    
    // Insert the new Walk into the Dog's walks set
//    if let dog = currentDog {
    //NSOrderedSet jest unmutable dlatego robi sie mutablecoppy zeby bylo mozna zmienic jego wartość
//      if let walks = dog.walks?.mutableCopy() as? NSMutableOrderedSet {
//        walks.add(walk)
//        dog.walks = walks
//      }
//    }
      //powyższe można zastąpić tym
//    currentDog?.addToWalks(walk)
    //aby układały się w kolejności wrzucam każdy nowy walk na index 0
    currentDog?.insertIntoWalks(walk, at: 0)
    
    // Save the managed object context
    
    do {
     try managedContext.save()
    } catch let error as NSError {
      print("Save error: \(error), description: \(error.userInfo)")
    }
    
    // Reload tableview
    tableView.reloadData()
  }
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let walks = currentDog?.walks else {
      return 1
    }
    return walks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    guard let walk = currentDog?.walks?[indexPath.row] as? Walk,
      let walkDate = walk.date as Date? else {
        return cell
    }
    cell.textLabel?.text = dateFormatter.string(from: walkDate)
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "List of Walks"
  }
}
