# GPUberView
Summon Uber from your app with 2 lines of code.

## Quick Start

```objective-c
// supply the pickup and drop-off locations
CLLocationCoordinate2D start = CLLocationCoordinate2DMake(40.7471787,-73.997494);
CLLocationCoordinate2D end = CLLocationCoordinate2DMake(40.712774,-74.006059);
    
GPUberViewController *uber = [[GPUberViewController alloc] initWithServerKey:@"your_server_token"
                                                                    clientId:@"your_client_id"
                                                                       start:start
                                                                         end:end];
[uber showInViewController:self];
```

## Demo

1. Go to the GPUberViewDemo directory.
2. Open the `.xcworkspace` (**not the `.xcodeproj`!**) file.
3. Navigate to the `MainViewController.m` file in the `GPUberViewDemo` folder.
4. Supply your own `serverKey` and `clientId` values in the `- (IBAction)callUber` function.
5. Optionally supply the desired pickup and drop-off values.
5. Run the app in the Simulator or on the device. **Note:** to launch the Uber app, you must run it on a device with Uber installed. Otherwise the user is forwarded to the Uber mobile website.

