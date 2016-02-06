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

@property (nonatomic) NSMutableArray *Tags;
@property (nonatomic) NSMutableArray *SecTags;
@property (nonatomic) NSMutableArray *Receipts;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Tags = [[NSMutableArray alloc] init];
    self.Receipts = [[NSMutableArray alloc] init];
    self.SecTags = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    NSError *errT = nil;
    NSFetchRequest *fetchRequestT = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityT = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequestT setEntity:entityT];
    
    NSArray *tags = [self.managedObjectContext executeFetchRequest:fetchRequestT error:&errT];
    self.Tags = [tags mutableCopy];

    if (self.Tags.count == 0) {
    NSManagedObjectContext *context = self.managedObjectContext;
    Tag *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
    newManagedObject.tagName = @"DEFAULT TAG";
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    }
    
    [self UpdateArraysWithTagsAndReceipts];
    
    for (NSArray *sectionReceiptArray in self.SecTags) {
        for (Receipt *oneReceipt in sectionReceiptArray) {
            NSLog(@"Receipt : %@", oneReceipt.note);
        }
    }
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)UpdateArraysWithTagsAndReceipts {
    
    [self.SecTags removeAllObjects];
    [self.Receipts removeAllObjects];
    [self.Tags removeAllObjects];
    
    NSError *errR = nil;
    NSFetchRequest *fetchRequestR = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityR = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
    [fetchRequestR setEntity:entityR];
    
    NSArray *receipts = [self.managedObjectContext executeFetchRequest:fetchRequestR error:&errR];
    self.Receipts = [receipts mutableCopy];
    
    NSError *errT = nil;
    NSFetchRequest *fetchRequestT = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityT = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequestT setEntity:entityT];
    
    NSArray *tags = [self.managedObjectContext executeFetchRequest:fetchRequestT error:&errT];
    self.Tags = [tags mutableCopy];

    for (Tag *oneTag in self.Tags) {
        [self.SecTags addObject:[oneTag.receipts allObjects]];
    }

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self UpdateArraysWithTagsAndReceipts];
     [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [self UpdateArraysWithTagsAndReceipts];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.Tags.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *secReceiptsArray = [self.SecTags objectAtIndex:section];
    return secReceiptsArray.count;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Tag *headerTag = [self.Tags objectAtIndex:section];
    NSString *header = headerTag.tagName;
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell" forIndexPath:indexPath];
    
    Receipt *oneReceipt = [self.SecTags objectAtIndex:indexPath.section][indexPath.row];
    cell.noteLabel.text = oneReceipt.note;
    return cell;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
if (editingStyle == UITableViewCellEditingStyleDelete) {
    
    Receipt *oneReceipt = [self.SecTags objectAtIndex:indexPath.section][indexPath.row];
    
    NSManagedObject *aManagedObject;
    
    for (Receipt *receiptToDelete in self.Receipts) {
        if (oneReceipt == receiptToDelete) {
            aManagedObject = receiptToDelete;
        }
    }
    
        //NSManagedObject *aManagedObject = self.Receipts[indexPath.row];

        [self.managedObjectContext deleteObject:aManagedObject];
    
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            // Handle the error.
        }

        [self viewWillAppear:YES];

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
    [self.tableView reloadData];
    
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ShowDetail"]) {
        
        DetailViewController *detailViewController = (DetailViewController *)[segue destinationViewController];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Receipt *receipt = [self.SecTags objectAtIndex:indexPath.section][indexPath.row];
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
