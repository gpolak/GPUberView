# GPUberView
Summon Uber from your iOS app with 2 lines of code.

![GPUberView](gpuberview_screenshot.png)

## Quick Start

```objective-c
#import <GPUberViewController.h>

// ...

GPUberViewController *uber = [[GPUberViewController alloc] initWithServerToken:@"your_server_token"];

// optional
uber.startLocation = CLLocationCoordinate2DMake(40.7471787,-73.997494);
uber.endLocation = CLLocationCoordinate2DMake(40.712774,-74.006059);

[uber showInViewController:self];
```

## Demo

1. Go to the GPUberViewDemo directory.
2. Open the `.xcworkspace` (not the `.xcodeproj`) file.
3. Run the app in the Simulator or on the device.

### Note:
If the phone has the Uber app installed, tapping any of the Uber service buttons will bring it up with the appropriate parameters already set. Otherwise the Uber mobile website will be launched.


## Adding GPUberView to Your Project

### CocoaPods

```ruby
platform :ios, '7.1'
pod "GPUberView"
```


## Usage

### Register You App With Uber

To use this library you need a valid *Server Token* from Uber. You can get it here: https://developer.uber.com

### Add url schemes

[For iOS 9 compatibility](http://awkwardhare.com/post/121196006730/quick-take-on-ios-9-url-scheme-changes), add the following scheme to your application's `info.plist`:

```
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>uber</string>
</array>
```

### Import GPUberView

```objective-c
#import <GPUberViewController.h>
```

### Initialize the GPUberViewController

Pass in your Uber *server token* for authentication.

```objective-c    
GPUberViewController *uber = [[GPUberViewController alloc] initWithServerToken:@"your_server_token"];
```

### (Optional) Specify the Pickup and/or Destination

You can pass-in the desired pickup and dropoff coordinates as CLLocationCoordinate2D structs.
```objective-c
// example: from Boston South Station to Fenway Park
uber.startLocation = CLLocationCoordinate2DMake(40.7471787,-73.997494);
uber.endLocation = CLLocationCoordinate2DMake(40.712774,-74.006059);
```

- If you omit `startLocation`, GPUberView will attempt to determine it based on your user's current location. For iOS 8.0 and higher, this requires you to add the [`NSLocationWhenInUseUsageDescription`](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW26) key into your application's `Info.plist` file. The value should be a short string explaining the reason why your app needs location (e.g., "Uber needs to determine your pickup location.").

- If you omit the `endLocation`, GPUberView will not be able to calculate the price estimate, but still will be able to show the estimated pickup time.


> **Note:** If you supply both the pickup and dropoff locations, make sure the distance between the two isn't exceedingly large. [Most Uber products](http://blog.uber.com/tag/uberchopper/) cannot drive you from San Francisco to New York.

You can also pass in user-readable names of the pickup and dropoff points. These labels will be shown to the user as the *pickup* and *dropoff* labels in the Uber app once launched. If not supplied, GPUberView (or the Uber app itself) will attempt to determine these automatically.

```objective-c
uber.startName = @"South Station";
uber.endName = @"Fenway Park";
```

### (Optional) Add Your Client Id

Add your Uber *client id* to receive Uber credits for new user signups. You can get it here: https://developer.uber.com

```objective-c
uber.clientId = @"your_client_id";
```

### Show GPUberView

```objective-c
[uber showInViewController:self];
```

## License

GPUberView is available under the MIT license. See the LICENSE file for more info.

