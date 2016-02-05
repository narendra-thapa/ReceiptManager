//
//  InputViewController.h
//  ReceiptsManager
//
//  Created by Narendra Thapa on 2016-02-04.
//  Copyright © 2016 Narendra Thapa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Receipt.h"

@protocol InputViewControllerDelegate <NSObject>

-(void)newItemDetails:(Receipt *)newItem;

@end

@interface InputViewController : UIViewController

@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITextField *amountEntered;
@property (weak, nonatomic) IBOutlet UITextView *noteEntered;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateEntered;

@property (weak, nonatomic) id <InputViewControllerDelegate> delegate;

@end
