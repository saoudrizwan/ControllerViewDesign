<p align="center">
    <img src="https://cloud.githubusercontent.com/assets/7799382/26728465/2e259924-475f-11e7-813a-3e691c82567a.png" alt="Controller View Design" />
</p>

<p align="center">
    <a href="#installation">Installation</a>
  • <a href="#getting-started">Getting Started</a>
  • <a href="#should-i-use-cvd">Should I use CVD?</a>
</p>

The Control View Design pattern, or CVD, is a new & elegant approach to delegating subviews' initialization, layout, and animation code to a separate class from UIViewControllers. Managing user interfaces programatically can result in massive view controller classes; however with CVD, view-related code is contained in a **ControllerView** subclass while data model management, user interaction, etc. is handled by a **Controller** subclass (previously known as a ViewController.) In many ways, CVD ensures you follow proper MVC guidelines [recommended by Apple](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html). 

[Read the Medium article.](https://medium.com/@sdrzn/controller-view-design-pattern-for-swift-new-6283cb052)

## Compatibility

The Controller View Design pattern is to be used primarily with Swift. 

## Installation

CVD is a programming design pattern, not a framework, so there shouldn't be much overhead when using it. The required boilerplate code is ~30 lines of Swift, which you can add anywhere in your project. You can also drag and drop `ControllerViewDesign.swift` into your project.

## Getting Started
Before, we would create a *UIViewController* subclass, where we initialize subviews, lay them out in our *viewDidLoad()* method, and then add any animation functions if we needed them. 
However with CVD, we put all that view-related code in a *ControllerView* subclass and set view handlers (like targets, gesture recognizers, delegates, data sources, etc.) & call any animation functions in a *Controller* subclass.

1. [Create a ControllerView subclass.](#creating-a-controllerview-subclass)

2. [Create a Controller subclass.](#creating-a-controller-subclass)

### Creating a ControllerView subclass
*ControllerView* is simply a subclass of a *UIView*, and will act as a 'container view' for all our subviews.
```swift
class HomeControllerView: ControllerView {
    
    // MARK: Views
    // This is where you want to declare all your subviews' instances. Creating custom views as computed objects is much faster and easier than creating custom subclasses.
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Hello world"
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // MARK: Layout
    
    override func addSubviews() {
        // Here we will add all our subviews on to self as if we would to self.view in a UIViewController.
        addSubview(label)
        // Set constraints or frames for all our subviews here as well.
        label.frame = CGRect(x: 100, y: 100, width: 300, height: 30)
    }
    
    // MARK: Methods
    // We also want to add any interface-changing code here, such as animations.
    
    func animateLabel() {
        UIView.animate(withDuration: 0.4, animations: { 
            label.frame = CGRect(x: 0, y: 0, width: 300, height: 30)
        }, completion: nil)
    }
}
```

### Creating a Controller subclass
*Controller* is simply a subclass of a *UIViewController* that's linked to a *ControllerView* instance.
```swift
class HomeController: Controller {

    override func viewDidLoad() {
        super.viewDidLoad()
        // We have to set our controllerView property in viewDidLoad, as this is the best place to initialize and layout subviews.
        controllerView = HomeControllerView(controller: self)
    }
    
    // Use this function to set up any targets, gesture recognizers, delegates, data sources, etc. for our subviews. Our ControllerView subclass automatically calls this function for us in the background at the proper time.
    override func setViewHandlers() {
        // To access our views, we first have to downcast our controllerView class property to our custom ControllerView subclass.
        guard let controllerView = self.controllerView as? HomeControllerView else { fatalError("Controller view has not been set") }
        controllerView.label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped)))
    }
    
    func labelTapped() {
        guard let controllerView = self.controllerView as? HomeControllerView else { fatalError("Controller view has not been set") }
        controllerView.animateLabel()
    }
}
```
Now whenever we need to access a subview, we first need to get our *ControllerView* subclass. 
```swift
extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let controllerView = self.controllerView as? HomeControllerView else { fatalError("Controller view has not been set") }
        let cell = controllerView.tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}
```
**NOTE:** Don't let the *fatalError()* bit scare you. That's simply there to throw an error if you forget to set the *controllerView* property in the *viewDidLoad()* function.

**Alternative ways of accessing a ControllerView's views and methods using CVD:**

Using a computer variable with a custom getter:

```swift
class HomeController: Controller {
    
    var homeControllerView: HomeControllerView {
        get {
            guard let controllerView = self.controllerView as? HomeControllerView else { fatalError("Controller view has not been set") }
            return controllerView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerView = HomeControllerView(controller: self)
    }
    
    override func setViewHandlers() {
        homeControllerView.label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped)))
    }
    
    func labelTapped() {
        homeControllerView.animateLabel()
    }
}
```
... or if you like optional chaining:
```swift
(controllerView as? HomeControllerView)?.label.text = "Bye world"
(controllerView as? HomeControllerView)?.animateLabel()
```

## Should I use CVD?

If you create, layout, animate, and manage your app's subviews programatically, then CVD is a clean & easy approach to ensuring you don't end up with massive view controllers. CVD is a design pattern you can use alongside MVC or MVVM, so it isn't a replacement for all other design patterns - in fact, it even helps ensure you follow proper MVC guidelines if that's what you're using in your project.  However, if you're using only storyboards for your particular project, then CVD may not be the best solution for managing all your IBOutlets.

## Credits

Icons in header image by [Yummygum](https://yummygum.com/)
