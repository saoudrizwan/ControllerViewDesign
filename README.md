<p align="center">
    <img src="https://cloud.githubusercontent.com/assets/7799382/26687289/36eba6e0-46a4-11e7-9585-0ddfd27ab358.png" alt="Controller View Design" />
</p>

<p align="center">
    <a href="#installation">Installation</a>
  • <a href="#usage">Usage</a>
  • <a href="#debugging">Debugging</a>
  • <a href="#debugging">Philosophy</a>
</p>

The Control View Design pattern, or CVD, is a fresh and elegant approach to delegating subviews' initialization, layout, and animation code to a separate class from UIViewControllers. Managing user interfaces programatically can result in massive view controller classes; however with CVD, view-related code is contained in a ControllerView subclass while data model management, user interaction, etc. is handled by a Controller subclass (previously known as a ViewController.) [Read more about the CVD philosophy.](#creating-an-animation)

## Compatibility

The Controller View Design pattern is to be used primarily with Swift. 

## Installation

CVD is a programming design pattern, not a framework, so there shouldn't be much overhead when using it. The required boilerplate code is ~30 lines of Swift, which you can add anywhere in your project.
* You can also drag and drop `ControllerViewDesign.swift` into your project.

## Getting Started
Usually we would create subviews and lay them out in out UIViewController's viewDidLoad() method, then add animation functions if needed as well. However with CVD, we put all that view-related code in a ControllerView subclass and set view handlers (like targets, gesture recognizers, delegates, data sources, etc.) and call any animation functions in a Controller subclass.

1. [Create a Controller subclass.](#creating-a-controller-subclass)

2. [Create a ControllerView subclass.](#starting-an-animation)

### Creating a Controller subclass
Controller is simply a subclass of a UIViewController that's linked to a ControllerView class.
```swift
class HomeController: Controller {

    override func viewDidLoad() {
        super.viewDidLoad()
        controllerView = HomeControllerView(controller: self)
    }
    
    override func setViewHandlers() {
        guard let controllerView = self.controllerView as? HomeControllerView else { fatalError("Controller view has not been set") }
        controllerView.label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped)))
    }
    
    func labelTapped() {
        guard let controllerView = self.controllerView as? HomeControllerView else { fatalError("Controller view has not been set") }
        controllerView.animateLabel()
    }
    
}
```

### Creating a ControllerView subclass
ControllerView is simply a subclass of a UIView, and will act as a 'container view' for all our subviews.
```swift
class HomeControllerView: ControllerView {
    
    // MARK: Views
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Hello world"
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // This is where you want to add all your subviews. Creating custom views as computed objects is much faster and easier than creating custom subclasses for these views.
    
    // MARK: Layout
    
    override func layoutViews() {
        addSubview(label)
        // set constraints or frame ...
    }
    
    // MARK: Methods
    
    func animateLabel() {
        UIView.animate(withDuration: 0.4, animations: { 
            // update constraints or frame ...
        }, completion: nil)
    }
}
```


