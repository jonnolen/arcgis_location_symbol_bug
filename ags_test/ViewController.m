

#import "ViewController.h"
#import <ArcGIS/ArcGIS.h>
#import "FSNavigationButton.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface ViewController ()<AGSMapViewLayerDelegate>

@property (weak, nonatomic) IBOutlet AGSMapView *mapView;
@property (weak, nonatomic) IBOutlet FSNavigationButton *navigationButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.layerDelegate = self;
    
    RACSignal *locationDataSourceIsStarted = RACObserve(self, mapView.locationDisplay.dataSourceStarted);
    RACSignal *locationAutoPanMode = RACObserve(self, mapView.locationDisplay.autoPanMode);
    
    RACSignal *mapNavigationState = [RACSignal combineLatest:@[locationDataSourceIsStarted, locationAutoPanMode]
                                                      reduce:^NSNumber *(NSNumber *isStarted, NSNumber *panMode){
                                                          if (isStarted == nil || panMode == nil){
                                                              return @(FSNavigationButtonStateOff);
                                                          }
                                                          else{
                                                              BOOL isStartedVal = isStarted.boolValue;
                                                              AGSLocationDisplayAutoPanMode panModeVal = (AGSLocationDisplayAutoPanMode)panMode.integerValue;
                                                              
                                                              if (!isStartedVal){
                                                                  return @(FSNavigationButtonStateOff);
                                                              }
                                                              else{
                                                                  if(panModeVal == AGSLocationDisplayAutoPanModeDefault || panModeVal == AGSLocationDisplayAutoPanModeOff){
                                                                      return @(FSNavigationButtonStateOn);
                                                                  }
                                                                  else{
                                                                      return @(FSNavigationButtonStateDirection);
                                                                  }
                                                              }
                                                          }
                                                      }];
    
    RAC(self, navigationButton.navigationState) = [mapNavigationState distinctUntilChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)locationButton:(FSNavigationButton *)sender {
    switch (sender.nextState) {
        case FSNavigationButtonStateOn:
            [self.mapView.locationDisplay startDataSource];
            self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
            break;
        case FSNavigationButtonStateDirection:
            [self.mapView.locationDisplay startDataSource];
            self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeCompassNavigation;
            break;
        default:
            [self.mapView.locationDisplay stopDataSource];
            self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeOff;
            [self.mapView setRotationAngle:0 animated:YES];
            break;
    }
}

- (IBAction)initMap:(id)sender {
    [self.mapView reset];
    AGSLayer *basemapLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:[NSURL URLWithString:@"http://services.arcgisonline.com/arcgis/rest/services/Canvas/World_Light_Gray_Base/MapServer"]];
    [self.mapView addMapLayer:basemapLayer withName:@"basemap"];
}

- (IBAction)releaseMap:(id)sender {
    [self.mapView.locationDisplay stopDataSource];
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeOff;
    
    [self.mapView removeMapLayerWithName:@"basemap"];
    [self.mapView reset];
}

-(void)mapViewDidLoad:(AGSMapView *)mapView{
    [mapView zoomToEnvelope:[self initialExtent] animated:NO];
}

-(AGSEnvelope *)initialExtent{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"extent" ofType:@"json"];
    NSData *d = [NSData dataWithContentsOfFile:jsonPath];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:d options:kNilOptions error:nil];
    return [[AGSEnvelope alloc] initWithJSON:jsonObject];
}

@end
