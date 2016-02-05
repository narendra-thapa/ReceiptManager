//
//  DetailViewController.m
//  ReceiptsManager
//
//  Created by Narendra Thapa on 2016-02-04.
//  Copyright © 2016 Narendra Thapa. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailTableViewCell.h"
#import "Tag.h"
#import "Receipt.h"

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *allTags;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allTags = [self.receiptInstance.tags allObjects];
    
    self.detailAmountLabel.text = [NSString stringWithFormat:@"%.2f", self.receiptInstance.amount];
    self.detailNoteLabel.text = self.receiptInstance.note;
    
    NSDate *currentDate = [[NSDate alloc] initWithTimeIntervalSince1970:self.receiptInstance.timestamp];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"EEE MMM d, yyyy HH:mm a";
    //dateformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.detailDateLabel.text = [dateformatter stringFromDate:currentDate];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell" forIndexPath:indexPath];
        
    Tag *oneTag = self.allTags[indexPath.row];
    
    //NSLog(@"%@", oneTag.tagName);
    
    cell.detailSelectionLabel.text = oneTag.tagName;
    
    return cell;
    
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
