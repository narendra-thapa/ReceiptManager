//
//  Receipt+CoreDataProperties.h
//  ReceiptsManager
//
//  Created by Narendra Thapa on 2016-02-04.
//  Copyright © 2016 Narendra Thapa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Receipt.h"

NS_ASSUME_NONNULL_BEGIN

@interface Receipt (CoreDataProperties)

@property (nonatomic) float amount;
@property (nullable, nonatomic, retain) NSString *note;
@property (nonatomic) NSTimeInterval timestamp;
@property (nullable, nonatomic, retain) Tag *tags;

@end

NS_ASSUME_NONNULL_END
