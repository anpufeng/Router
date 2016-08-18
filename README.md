# HOW TO USE
### make your ViewController implement `protocol Routable`
```swift
extension FirstViewController: Routable {
    static func initWithParams(params: RouterParam?) -> UIViewController? {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("FirstViewController") as! FirstViewController
        vc.hidesBottomBarWhenPushed = true
        
        if let params = params {
            let converter = RouterParamsConverter(params: params)
            converter.valueWithKey(kStringKey, out: &vc.name)
            converter.valueWithKey(kIntKey, out: &vc.age)
            converter.valueWithKey(kEnumKey, out: &vc.week)
            converter.valueWithKey(kClassKey, out: &vc.classModel)
            converter.valueWithKey(kStructKey, out: &vc.structModel)
            converter.valueWithKey(kClosureKey, out: &vc.closure)
            
            print("got params String name: \(vc.name)\n Int age : \(vc.age)\n Enum week: \(vc.week)\n Class: \(vc.classModel?.description)\n Struct: \(vc.structModel)\n")
            let result = vc.closure?(name: "Lily", age: 10)
            print("closure result: \(result)")
        }
        
        return vc
    }
    
    static var routableKey: String {
        return "FirstViewController"
    }
}
```
###call `map` before you route your `viewController`
```swift
  let router = Router.sharedInstance
  router.navigationController = nav
  router.map(FirstViewController.routableKey, className: FirstViewController.description())      router.map(SecondViewController.routableKey, className: SecondViewController.description())
  router.map(WebViewController.routableKey, className: WebViewController.description())      router.map(FirstNavigationController.routableKey, className: FirstNavigationController.description())
```
###call `open` to route your `viewController`
```swift
Router.sharedInstance.open(FirstViewController.routableKey)
///got the vc just inited
 Router.sharedInstance.open(WebViewController.routableKey, animated: true) { (opened) in
    if let opened = opened as? WebViewController {
    	///
    }
  }
```
###route with params `RouterParam`
```swift
let params: RouterParam = [FirstViewController.kStringKey: "zhongan",
                            FirstViewController.kIntKey: 3,
                            FirstViewController.kEnumKey: Week.Monday,
                            FirstViewController.kClassKey: ClassModel(name: "china"),
                            FirstViewController.kStructKey: StructModel(name: "us"),
                            FirstViewController.kClosureKey: closure]
        
Router.sharedInstance.open(FirstViewController.routableKey, params: params)
```
###route with options `RouterOptions`
```swift
let option = RouterOptions(presentationStyle: .Popover, transitionStyle: .FlipHorizontal, isModal: true)
Router.sharedInstance.open(FirstNavigationController.routableKey, options: option)
```
###pop your `viewController`
```swift
Router.sharedInstance.pop()
///pop to root
Router.sharedInstance.pop(toRoot:true, animated: true)
```
###special viewController like `UIAlertController`
```swift
let param = UIAlertController.alertParams(nil, message: "message", preferredStyle: .Alert)
Router.sharedInstance.open(UIAlertController.routableKey, params: param, options: UIAlertController.defaultRouterOptions, animated: true) { (opened) in
    if let alertController = opened as? UIAlertController {
        let okAction = UIAlertAction(title: "ok", style: .Default, handler: { (alertAction) in
            print("clicked ok")
        })
        
        alertController.addAction(okAction)
    }
}
```
###TODO 
 * more special ViewController(UIImagePickerController ...)
 * more test
