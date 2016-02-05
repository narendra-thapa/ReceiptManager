//
//  ViewController.m
//  ReceiptsManager
//
//  Created by Narendra Thapa on 2016-02-04.
//  Copyright © 2016 Narendra Thapa. All rights reserved.
//

#import "ViewController.h"
#import "InputViewController.h"
#import "DetailViewController.h"
#import "InputTagViewController.h"
#import "AppDelegate.h"
#import "Tag.h"
#import "Receipt.h"
#import "TableViewCell.h"

@interface ViewController () <InputViewControllerDelegate, InputTagViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    NSError *err = nil;
    NSFetchRequest *allTags = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    NSArray *allFoods = [self.managedObjectContext executeFetchRequest:allTags error:&err];
    NSLog(@"%@", allFoods);
    
    for (Tag *tags in allFoods) {
        NSLog(@"%@", tags.tagName);
    }
    
    NSError *errR = nil;
    NSFetchRequest *allReceipts = [NSFetchRequest fetchRequestWithEntityName:@"Receipt"];
    NSArray *allFoodsa = [self.managedObjectContext executeFetchRequest:allReceipts error:&errR];
    NSLog(@"%@", allFoodsa);
    
    for (Receipt *receipts in allFoodsa) {
        NSLog(@"%@", receipts.note);
    }
        
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    NSError *errR = nil;
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    NSArray *allTags = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errR];
//    
//    return allTags.count;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSError *errR = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *allReceipts = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errR];

    return allReceipts.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell" forIndexPath:indexPath];
    
    NSError *errR = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *allReceipts = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errR];
    
    Receipt *oneReceipt = allReceipts[indexPath.row];
    NSLog(@"%@", oneReceipt.note);
    cell.noteLabel.text = oneReceipt.note;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
if (editingStyle == UITableViewCellEditingStyleDelete) {
    
    
        NSError *errR = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
    
        NSArray *allReceipts = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errR];

        NSManagedObject *aManagedObject = [allReceipts objectAtIndex:indexPath.row];

        [self.managedObjectContext deleteObject:aManagedObject];
    
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            // Handle the error.
        }
        
        //[tempReceiptArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Input View Controller Delegate

-(void)newItemDetails:(Receipt *)newItem {
    NSLog(@"Save new receipt");
    [self.tableView reloadData];
}

#pragma mark - Input View Controller Delegate

-(void)newTagDetails:(Tag *)newItem {
    NSLog(@"Save new tag");
    
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ShowDetail"]) {
        
        DetailViewController *detailViewController = (DetailViewController *)[segue destinationViewController];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSError *errR = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSArray *allReceipts = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errR];
        
        Receipt *receipt = [allReceipts objectAtIndex:indexPath.row];
        
        detailViewController.receiptInstance = receipt;
        detailViewController.managedObjectContext = self.managedObjectContext;
    }
    else if ([[segue identifier] isEqualToString:@"ShowInput"]) {
        
        InputViewController *inputViewController = (InputViewController *)[segue destinationViewController];
        
        inputViewController.managedObjectContext = self.managedObjectContext;
        inputViewController.delegate = self;
        
    }
    else if ([[segue identifier] isEqualToString:@"InputTag"]) {
        
        InputTagViewController *inputTagViewController = (InputTagViewController *)[segue destinationViewController];
        
        inputTagViewController.managedObjectContext = self.managedObjectContext;
        inputTagViewController.delegate = self;
        
    }
}

@end
