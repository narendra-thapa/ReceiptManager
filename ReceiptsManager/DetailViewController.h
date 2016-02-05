//
//  DetailViewController.h
//  ReceiptsManager
//
//  Created by Narendra Thapa on 2016-02-04.
//  Copyright © 2016 Narendra Thapa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Receipt;

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *detailAmountLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailNoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailDateLabel;

@property (nonatomic) Receipt *receiptInstance;

@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@end
