//
//  Driver+CoreDataProperties.h
//  
//
//  Created by Abhinav Khanna on 2/21/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Driver.h"

NS_ASSUME_NONNULL_BEGIN

@interface Driver (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *campaign;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *google_idtoken;
@property (nullable, nonatomic, retain) NSString *google_userid;
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDate *trial_end_date;
@property (nullable, nonatomic, retain) NSString *image;

@end

NS_ASSUME_NONNULL_END
