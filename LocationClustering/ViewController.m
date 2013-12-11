//
//  ViewController.m
//  LocationClustering
//
//  Created by Kevin Fernandes on 12/9/13.
//  Copyright (c) 2013 KevinFernandes. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

CLLocationManager *locationManager;
NSTimer *timer;
int locationID = -1;
DBSCAN *dbscan;

@implementation ViewController

GMSMapView *mapView_;
@synthesize managedObjectContext;

-(void)updateLocation
{
    CLLocationCoordinate2D coord = locationManager.location.coordinate;
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    locationID++;
    
    GPSLocation *gpsLoc = [NSEntityDescription insertNewObjectForEntityForName:@"GPSLocation" inManagedObjectContext:managedObjectContext];
    
    gpsLoc.latitude = [NSNumber numberWithDouble:coord.latitude];
    gpsLoc.longitude = [NSNumber numberWithDouble:coord.longitude];
    gpsLoc.timestamp = [NSNumber numberWithDouble:timeStamp];
    gpsLoc.id = [NSNumber numberWithInteger:locationID];
    
    GMSMarker *marker = [GMSMarker markerWithPosition:coord];
//    marker.title = @"ID: %i", locationID;
    marker.map = mapView_;

//    NSLog(@"current location: %f, %f", coord.latitude, coord.longitude);
//    NSLog(@"location: ");
    if (locationID !=0 && locationID % 100 == 0){
        if(![managedObjectContext save:nil]){
            NSLog(@"Error Saving") ;
        }
        
        [[self fetchedResultsController] performFetch:nil];
        NSMutableArray *locations = [NSMutableArray arrayWithArray:[[self fetchedResultsController] fetchedObjects]];
        
        if (locations.count > 1000) {
            [timer invalidate];
        }
        
//        NSLog(@"FETCHED OBJECTS: %d", locations.count);
        NSMutableArray *clusters = [dbscan scanLocations:locations epsilonValue:.003 minPoints:3];
//        NSLog(@"CLUSTERS: %d", clusters.count);
        
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    dbscan = [[DBSCAN alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    timer = [NSTimer scheduledTimerWithTimeInterval: .01 target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
    
    
    
    [self createMap];
    
    
    
   
}
-(void) createMap{
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:42.387990
                                                            longitude:-72.530787
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
//    marker.title = @"Sydney";
//    marker.snippet = @"Australia";
//    marker.map = mapView_;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-FetchedResultsController

-(NSFetchedResultsController*) fetchedResultsController{
    if(_fetchedResultsController){
        return _fetchedResultsController;
    }
    else{
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"GPSLocation"
                                                  inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id"
                                                                       ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        _fetchedResultsController =[[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        [_fetchedResultsController setDelegate:self];
        return _fetchedResultsController;
    }
}

@end
