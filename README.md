<p align="center">
    <img src="https://cloud.githubusercontent.com/assets/7799382/26687289/36eba6e0-46a4-11e7-9585-0ddfd27ab358.png" alt="Controller View Design" />
</p>

<p align="center">
    <a href="#installation">Installation</a>
  • <a href="#getting-started">Getting Started</a>
</p>

The Control View Design pattern, or CVD, is a fresh and elegant approach to delegating subviews' initialization, layout, and animation code to a separate class from UIViewControllers. Managing user interfaces programatically can result in massive view controller classes; however with CVD, view-related code is contained in a ControllerView subclass while data model management, user interaction, etc. is handled by a Controller subclass (previously known as a ViewController.)

## Compatibility

The Controller View Design pattern is to be used primarily with Swift. 

## Installation

CVD is a programming design pattern, not a framework, so there shouldn't be much overhead when using it. The required boilerplate code is ~30 lines of Swift, which you can add anywhere in your project. You can also drag and drop `ControllerViewDesign.swift` into your project.

## Getting Started
Before, we would create a *UIViewController* subclass, where we initialize subviews, lay them out in our *viewDidLoad()* method, and then add any animation functions if we need them. 
However with CVD, we put all that view-related code in a *ControllerView* subclass and set view handlers (like targets, gesture recognizers, delegates, data sources, etc.) & call any animation functions in a *Controller* subclass.

1. [Create a ControllerView subclass.](#creating-a-controllerview-subclass)

2. [Create a Controller subclass.](#creating-a-controller-subclass)

### Creating a ControllerView subclass
*ControllerView* is simply a subclass of a *UIView*, and will act as a 'container view' for all our subviews.
```swift
class HomeControllerView: ControllerView {
    
    // MARK: Views
    // This is where you want to add all your subviews. Creating custom views as computed objects is much faster and easier than creating custom subclasses.
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Hello world"
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // MARK: Layout
    
    override func layoutViews() {
        // Here we will add all our subviews on to self as if we would to self.view in a UIViewController.
        addSubview(label)
        // Set constraints or frames for all our subviews here as well.
        label.frame = CGRect(x: 100, y: 100, width: 300, height: 30)
    }
    
    // MARK: Methods
    // We also want to add any interface updating code here such as animations.
    
    func animateLabel() {
        UIView.animate(withDuration: 0.4, animations: { 
            label.frame = CGRect(x: 0, y: 0, width: 300, height: 30)
        }, completion: nil)
    }
}
```

### Creating a Controller subclass
*Controller* is simply a subclass of a *UIViewController* that's linked to a *ControllerView* class.
```swift
class HomeController: Controller {

    override func viewDidLoad() {
        super.viewDidLoad()
        // We have to set our controllerView property in viewDidLoad, as this is the best place to initialize and layout subviews.
        controllerView = HomeControllerView(controller: self)
    }
    
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
Now whenever we need to access a subview, we first need to get our ControllerView subclass. 
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
