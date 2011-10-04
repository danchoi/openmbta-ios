//
//  ScheduleViewController.m
//  OpenMBTA
//
//  Created by Daniel Choi on 9/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScheduleViewController.h"
#import "TripsViewController.h"
#import "ServerUrl.h"
#import "GridCell.h"
#import "GetRemoteDataOperation.h"
#import "JSON.h"

const int kRowHeight = 50;
const int kCellWidth = 44;

@interface ScheduleViewController (Private)

@end


@implementation ScheduleViewController

@synthesize stops, nearestStopId, selectedStopName, orderedStopNames;
@synthesize tableView, scrollView, gridTimes, gridID, tripsViewController, selectedRow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.stops = [NSArray array];
        self.orderedStopNames = [NSArray array];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gridTimes = [NSMutableArray array];
    self.scrollView.tileWidth  = kCellWidth;
    self.scrollView.tileHeight = kRowHeight;
    self.view.clipsToBounds = YES;
    self.tableView.scrollEnabled = NO;
    
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // override this so we don't lose the view if not visible 
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    self.nearestStopId = nil;
    self.orderedStopNames = nil;
    self.tripsViewController = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
//   [self.tableView reloadData];
//    [self.view bringSubviewToFront:self.scrollView];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.directionalLockEnabled = YES;    
    [super viewWillAppear:animated];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];    
}

- (void)viewWillDisappear:(BOOL)animated {
    //[self performSelectorInBackground:@selector(releaseLabels) withObject:nil];
    stopAddingLabels = YES;
    //[self releaseLabels];

    [super viewWillDisappear:animated];
}


- (void)highlightNearestStop:(NSString *)stopId {
    self.nearestStopId = stopId;
}

// FLOATING GRID

- (void)clearGrid {
    self.stops = [NSArray array];
    self.selectedStopName = nil;
    self.tableView.hidden = YES;    
    self.scrollView.hidden = YES;
}

- (void)createFloatingGrid {

    self.tableView.hidden = NO;
    [self.tableView reloadData];

    self.scrollView.stops = [NSArray array];
    self.scrollView.hidden = YES;

    if ([self.stops count] == 0) 
        return;
    NSDictionary *firstRow = [self.stops objectAtIndex:0];
    NSArray *timesForFirstRow = [firstRow objectForKey:@"times"];
    NSInteger numColumns = [timesForFirstRow count];

    int gridWidth = (numColumns * kCellWidth) + 12;
    int gridHeight = ([self.stops count] * kRowHeight);
    [scrollView setContentSize:CGSizeMake(gridWidth, gridHeight)];
    
    [self adjustScrollViewFrame];
    scrollView.stops = self.stops;
    [self.view bringSubviewToFront:scrollView];
    
//    [self.view addSubview:scrollView];
    
    [scrollView reloadData];
}

- (void)adjustScrollViewFrame {
    scrollView.frame = CGRectMake(6, 0, 320, self.view.frame.size.height); 
    
}

#pragma mark color grid cell

- (UIView *)gridScrollView:(GridScrollView *)scrollView tileForRow:(int)row column:(int)column {
    if ((row >= [self.stops count])  || (column >= [[[self.stops objectAtIndex:row] objectForKey:@"times"] count])) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kRowHeight)];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:11.0];
    id arrayOrNull = [[[self.stops objectAtIndex:row] objectForKey:@"times"] objectAtIndex:column];
    
    if (arrayOrNull == [NSNull null]) {
        label.text = @" ";
        view.backgroundColor = [UIColor clearColor];
    } else {
        
        NSString *time = [(NSArray *)arrayOrNull objectAtIndex:0];
        label.text = time;
        int period = [(NSNumber *)[(NSArray *)arrayOrNull objectAtIndex:1] intValue];   

        if (period == -1) {
            //view.backgroundColor = [UIColor colorWithRed: (25/255.0 ) green: (255.0/255.0) blue: (76/255.0) alpha:0.2];
            //label.textColor = [UIColor grayColor];
        }        
        
    }
    label.backgroundColor = [UIColor clearColor];
    
    if (column % 2 == 0) {
        view.backgroundColor = [UIColor clearColor];
    } else {
        view.backgroundColor = [UIColor colorWithRed: (214/255.0) green: (214/255.0) blue: (255/255.0) alpha: 0.3];
    }
    
    label.frame = CGRectMake(5, 15, kCellWidth, kRowHeight - 15);
    [view addSubview:label];
    [label release];

    
    return (UIView *)view; 
}

#pragma mark Scroll View delegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    tableView.contentOffset = CGPointMake(0, aScrollView.contentOffset.y);
    self.scrollView.directionalLockEnabled = YES; // I don't know why this keeps getting set to NO otherwise
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self alignGridAnimated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
        [self alignGridAnimated:YES];
}

#pragma mark align grid after decelerating or drag

- (void)alignGridAnimated:(BOOL)animated {
    float x = self.scrollView.contentOffset.x;
    float y = self.scrollView.contentOffset.y;
    float maxY = self.scrollView.contentSize.height - self.scrollView.frame.size.height - (kRowHeight / 2);

    if (y == self.scrollView.contentSize.height - self.scrollView.frame.size.height) {
        return;
        
    }
    // when at bottom, align toward bottom, except when too few rows
    float newY;
    if ( (y > maxY ) &&  (maxY >= self.scrollView.frame.size.height) )   {
        newY = self.scrollView.contentSize.height - self.scrollView.frame.size.height + 10;
    } else {
        newY = round(y/kRowHeight) * kRowHeight;
    }
    CGPoint contentOffset = CGPointMake( (round(x/kCellWidth) * kCellWidth), newY);

    [self.scrollView setContentOffset:contentOffset animated:animated];        
}


#pragma mark Table View stuff

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [self.stops count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"GridCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];

        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];

        cell.accessoryType =  UITableViewCellAccessoryNone; 
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row >= [self.stops count]) {
        cell.textLabel.text = @"missing";
        cell.detailTextLabel.text = @"missing";
        return cell;
    }
                          
    NSDictionary *stopRow = [self.stops objectAtIndex:indexPath.row];
    NSDictionary *stopDict = [stopRow objectForKey:@"stop"];
    NSString *stopName =  [stopDict objectForKey:@"name"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
    cell.textLabel.textColor = self.selectedRow == indexPath.row ? [UIColor purpleColor] : [UIColor blackColor];        
    cell.textLabel.text =  stopName;
    cell.detailTextLabel.text =  @" ";
    return cell;
}

- (void)highlightRow:(int)row showCurrentColumn:(BOOL)showCurrentColumn {
    
   // NSLog(@"hightlight row %d showCurrentColumn %d", row, showCurrentColumn);    
    if ([self.stops count] == 0) return;
    if (row >= [self.stops count]) return;

    self.selectedRow = row;
    
    float newX;
    if (showCurrentColumn) {
        // move to most relevant column
        NSArray *times = [[self.stops objectAtIndex:row] objectForKey:@"times"];

        int col = 0;
        for (id time in times) {
            if (![time isEqual:[NSNull null]]) {
                int period = [(NSNumber *)[(NSArray *)time objectAtIndex:1] intValue];
                if (period == 1) {
                    break;
                }
             }
            col++;
        }
        newX = kCellWidth * col;        
    } else {
        newX = self.scrollView.contentOffset.x; // keep the old value
    }
    float maxX = self.scrollView.contentSize.width - 320;
    float maxY = self.scrollView.contentSize.height - ((ScheduleViewController *)self.tripsViewController.scheduleViewController).view.frame.size.height;
//    float newY = row *kRowHeight;
    float newY = MAX( row * kRowHeight + ( kRowHeight / 2) - self.scrollView.frame.size.height / 2, 0);
    float y = self.scrollView.contentOffset.y;
    if (self.scrollView.contentSize.height >= self.view.frame.size.height) {
        y = MIN(newY, maxY);
    }


    float x = MIN(newX, maxX);
    if (self.scrollView.contentSize.width < self.view.frame.size.width) {
        x = 0;
    }    
    CGPoint contentOffset = CGPointMake(x , y);
    [self.scrollView setContentOffset:contentOffset animated:YES];        
    [scrollView reloadData];
    [tableView reloadData];
    
}

- (void)highlightStopNamed:(NSString *)stopName showCurrentColumn:(BOOL)showCurrentColumn {
    
    if (stopName == nil)
        return;
    int row = [self.orderedStopNames indexOfObject:stopName];
    if (row == NSNotFound)
        return;
    [self highlightRow:row showCurrentColumn:showCurrentColumn];
}

- (void)touchedColumn:(int)col {
    // if user touched right most column, page right etc.
    float currentX = self.scrollView.contentOffset.x;

    float newX;
    float rightEdge = self.scrollView.contentOffset.x + self.view.frame.size.width - (2 * kCellWidth);
    float leftEdge = self.scrollView.contentOffset.x + kCellWidth;
    if (col * kCellWidth >= rightEdge)  {
        newX = currentX + (kCellWidth * 6);
    } else if (col * kCellWidth < leftEdge)  {
        newX = currentX - (kCellWidth * 6);
    } else {
        return;
    }

    float maxX = self.scrollView.contentSize.width - 320;
    float x = MIN(newX, maxX);
    if (self.scrollView.contentSize.width < self.view.frame.size.width) {
        return;
    } 
    if (newX < 0)
        x = 0;
    CGPoint contentOffset = CGPointMake(x , self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:contentOffset animated:YES];        
    [scrollView reloadData];
    [self alignGridAnimated:YES];
}

- (void)doubleTouchedColumn:(int)col {
    // if user touched right most column, page right etc.
    
    float newX;
    float rightEdge = self.scrollView.contentOffset.x + self.view.frame.size.width - (2 * kCellWidth);
    float leftEdge = self.scrollView.contentOffset.x + kCellWidth;
    if (col * kCellWidth >= rightEdge)  {
        newX = self.scrollView.contentSize.width - 320;
    } else if (col * kCellWidth < leftEdge)  {
        newX = 0;
    } else {
        return;
    }
    CGPoint contentOffset = CGPointMake(newX , self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:contentOffset animated:YES];        
    [scrollView reloadData];
    [self alignGridAnimated:YES];
}

@end
