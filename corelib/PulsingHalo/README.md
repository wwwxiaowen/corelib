PulsingHalo
===========

iOS Component For Creating A Pulsing Animation. It allows you to create single halo or multiple halos.

![](http://f.cl.ly/items/2Q0X052p2m371m0w2O0C/halogif.gif "single halo | multiple halos")
                    
Great For:

- **Beacons for iBeacon**
- Map Annotations


##How to use

1. Add PulsingHaloLayer.h,m into your project
2. Initiate and add to your view.

####Single halo
````
PulsingHaloLayer *halo = [PulsingHaloLayer layer];
halo.position = self.view.center;
[self.view.layer addSublayer:halo];
````

####Multiple halos
````
//you can specify the number of halos by initial method or by instance property "haloLayerNumber"
MultiplePulsingHaloLayer *multiLayer = [[MultiplePulsingHaloLayer alloc] initWithHaloLayerNum:3 andStartInterval:1];
multiLayer.position = self.view.center;
[multiLayer buildSublayers];
[self.view.layer addSublayer:multiLayer];
````

##Install with CocoaPods

Add Podfile.

````
pod "PulsingHalo"
````

And

````
$ pod install
````


##Customization

###radius

Use `radius` property.

````
self.halo.radius = 240.0;
````

###color

Use `backgroundColor` property.

````
UIColor *color = [UIColor colorWithRed:0.7
                                 green:0.9
                                  blue:0.3
                                 alpha:1.0];

self.halo.backgroundColor = color.CGColor;
````

###animation duration

Use `animationDuration` or `pulseInterval` property.


###animation repeat count

Initialize using `initWithRepeatCount:` method, or set `repeatCount` property. The default value is `INFINITY`.


###animation key values and times

Use properties `fromValueForRadius`, `fromValueForAlpha` and `keyTimeForHalfOpacity`.

###enable/disable timing function for animation
Use property `useTimingFunction`

##Demo

You can try to change the radius and color properties with demo app.

![](http://f.cl.ly/items/0u3c211i2g372c390p44/halodemo.jpg)


##Special Thanks

Inspired by [SVPulsingAnnotationView](https://github.com/samvermette/SVPulsingAnnotationView).




//demo  =============================================================================  

- (void)viewDidLoad
{
[super viewDidLoad];

///setup single halo layer
PulsingHaloLayer *layer = [PulsingHaloLayer layer];
self.halo = layer;
self.halo.position = self.beaconView.center;
[self.view.layer insertSublayer:self.halo below:self.beaconView.layer];

///setup multiple halo layer
//you can specify the number of halos by initial method or by instance property "haloLayerNumber"
MultiplePulsingHaloLayer *multiLayer = [[MultiplePulsingHaloLayer alloc] initWithHaloLayerNum:3 andStartInterval:1];
self.mutiHalo = multiLayer;
self.mutiHalo.position = self.beaconViewMuti.center;
self.mutiHalo.useTimingFunction = NO;
[self.mutiHalo buildSublayers];
[self.view.layer insertSublayer:self.mutiHalo below:self.beaconViewMuti.layer];

[self setupInitialValues];
}
 

- (void)setupInitialValues {

self.radiusSlider.value = 0.5;
[self radiusChanged:nil];

self.rSlider.value = 0;
self.gSlider.value = 0.487;
self.bSlider.value = 1.0;
[self colorChanged:nil];
}


// =============================================================================
#pragma mark - IBAction

- (IBAction)radiusChanged:(UISlider *)sender {

self.mutiHalo.radius = self.radiusSlider.value * kMaxRadius;
self.halo.radius = self.radiusSlider.value * kMaxRadius;

self.radiusLabel.text = [@(self.radiusSlider.value) stringValue];
}

- (IBAction)colorChanged:(UISlider *)sender {

UIColor *color = [UIColor colorWithRed:self.rSlider.value
green:self.gSlider.value
blue:self.bSlider.value
alpha:1.0];

[self.mutiHalo setHaloLayerColor:color.CGColor];
[self.halo setBackgroundColor:color.CGColor];

self.rLabel.text = [@(self.rSlider.value) stringValue];
self.gLabel.text = [@(self.gSlider.value) stringValue];
self.bLabel.text = [@(self.bSlider.value) stringValue];
}

