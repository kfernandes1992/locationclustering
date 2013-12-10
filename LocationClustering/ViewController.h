//
//  ViewController.h
//  LocationClustering
//
//  Created by Kevin Fernandes on 12/9/13.
//  Copyright (c) 2013 KevinFernandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController < NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end
