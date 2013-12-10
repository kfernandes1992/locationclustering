//
//  GPSLocation.h
//  LocationClustering
//
//  Created by Kevin Fernandes on 12/10/13.
//  Copyright (c) 2013 KevinFernandes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GPSLocation : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * accuracy;
@property (nonatomic, retain) NSNumber * seen;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * inCluster;

@end
