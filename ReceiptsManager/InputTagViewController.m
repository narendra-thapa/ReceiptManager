//
//  InputTagViewController.m
//  ReceiptsManager
//
//  Created by Narendra Thapa on 2016-02-04.
//  Copyright © 2016 Narendra Thapa. All rights reserved.
//

#import "InputTagViewController.h"
#import "AppDelegate.h"
#import "Tag.h"

@interface InputTagViewController ()

@end

@implementation InputTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tagSavePressed:(UIButton *)sender {
    NSLog(@"Save Button Pressed");
    
    NSManagedObjectContext *context = self.managedObjectContext;

    Tag *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
    
    newManagedObject.tagName = self.enteredTag.text;

    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.delegate newTagDetails:newManagedObject];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
