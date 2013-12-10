//
//  GPSLocation.m
//  LocationClustering
//
//  Created by Kevin Fernandes on 12/10/13.
//  Copyright (c) 2013 KevinFernandes. All rights reserved.
//

#import "GPSLocation.h"


@implementation GPSLocation

@dynamic id;
@dynamic timestamp;
@dynamic latitude;
@dynamic longitude;
@dynamic accuracy;
@dynamic seen;
@dynamic type;
@dynamic inCluster;


-(BOOL) equals:(GPSLocation*) r{
    return self.id==r.id;
}

@end
