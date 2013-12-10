//
//  DBSCAN.m
//  LocationClustering
//
//  Created by Erik Risinger on 12/10/13.
//  Copyright (c) 2013 KevinFernandes. All rights reserved.
//

#import "DBSCAN.h"

NSMutableArray *allLocations;

@implementation DBSCAN

-(NSMutableArray *)scanLocations:(NSMutableArray *)locations epsilonValue:(double)eps minPoints:(int)minPts
{
    allLocations = locations;
    NSMutableArray *clusters = [[NSMutableArray alloc] init];
    
    for (GPSLocation *location in locations)
    {
        location.seen = [NSNumber numberWithBool:YES];
        NSMutableArray *neighbors = [self regionQuery:location epsilonValue:eps];
        if (neighbors.count < minPts) {
            location.type = @"NOISE";
        }
        else
        {
            NSMutableArray *cluster = [[NSMutableArray alloc] init];
            [self expandClusterForLocation:location neighbors:neighbors cluster:cluster epsilonValue:eps minPoints:minPts];
            [clusters addObject:cluster];

        }
}
    return clusters;
}

-(NSMutableArray *)expandClusterForLocation:(GPSLocation *)location neighbors:(NSMutableArray *)neighbors cluster:(NSMutableArray *)cluster epsilonValue:(double)eps minPoints:(int)minPts
{
    location.inCluster = [NSNumber numberWithBool:YES];
    [cluster addObject:location];
    for (GPSLocation *n in neighbors)
    {
        NSMutableArray *neighborsPrime;
        if ([n.seen boolValue] == NO) {
            n.seen = [NSNumber numberWithBool:YES];
            neighborsPrime = [self regionQuery:n epsilonValue:eps];
            if (neighborsPrime.count >= minPts)
            {
                [neighbors addObjectsFromArray:neighborsPrime];
            }
            
        }
        if ([n.inCluster boolValue] == NO) {
            n.inCluster = [NSNumber numberWithBool:YES];
            [cluster addObject:n];
        }
    }
    return cluster;
}

-(NSMutableArray *)regionQuery:(GPSLocation *)location epsilonValue:(double)eps
{
    NSMutableArray *neighbors = [[NSMutableArray alloc]init];
    [neighbors addObject:location];
                                 
    for (GPSLocation *l in allLocations)
    {
        double myLat = [location.latitude doubleValue];
        double myLon = [location.longitude doubleValue];
        double otherLat = [l.latitude doubleValue];
        double otherLon = [l.longitude doubleValue];
        
        double distance = sqrt(pow(myLat - otherLat, 2) + pow(myLon - otherLon, 2));
        if (distance <= eps)
        {
            [neighbors addObject:l];
        }
    }
    return neighbors;
}

//-(id)init
//{
//    self = [super init];
//    if (self) {
//        clusters = [[NSMutableArray alloc] init];
//    }
//    return self;
//}

@end
