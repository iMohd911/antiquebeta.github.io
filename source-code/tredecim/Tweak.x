#import "Classes/Card.h"
#import "Classes/Install.h"


void append(NSString *msg) {
    NSString *path = @"/var/mobile/log.txt";
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSData data] writeToFile:path atomically:YES];
    } 

    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    [handle writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
}


BOOL hasIconAndVisible(LSApplicationProxy *app) {
NSArray *hiddenApps = @[@"com.apple.siri.parsec.HashtagImagesApp",
    @"com.apple.ActivityMessagesApp",
    @"com.apple.icloud.apps.messages.business",
    @"com.apple.FunCamera.EmojiStickers",
    @"com.apple.Jellyfish",
    @"com.apple.Animoji.StickersApp",
    @"com.apple.FunCamera.ShapesPicker",
    @"com.apple.webapp",
    @"com.apple.FunCamera.TextPicker",
    @"com.apple.sidecar",
    @"com.apple.siri"];


    if(![app.appTags containsObject:@"hidden"] && ![hiddenApps containsObject:app.bundleIdentifier]) {
        return YES;
    } return NO;
}


NSMutableArray *getInstalledApps() {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];

    NSMutableArray *allApps = @[].mutableCopy;
    NSArray *workspaceApps = [[NSClassFromString(@"LSApplicationWorkspace") defaultWorkspace] allApplications];
    for(LSApplicationProxy *app in workspaceApps) {
        if(hasIconAndVisible(app)) {
            [allApps addObject:@{
                @"app" : app,
                @"bundleID" : app.bundleIdentifier,
                @"name" : app.localizedName
            }];
        }
    } return [allApps sortedArrayUsingDescriptors:@[sortDescriptor]].mutableCopy;
}



@interface SBUIController : NSObject
+(id) sharedInstance;
-(void)_activateApplicationFromAccessibility:(id)arg1;
@end

void launchApplication(SBApplication *app) {
    [[NSClassFromString(@"SBUIController") sharedInstance] _activateApplicationFromAccessibility:app];
}


UICollectionView *collectionView;
UIRefreshControl *refreshControl;
@interface Tredecim : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSMutableArray *apps;
}
@end

@implementation Tredecim
-(void) viewDidLoad {
    [super viewDidLoad];
    apps = getInstalledApps();


    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [collectionView setBackgroundColor:nil];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    [collectionView registerClass:[Card class] forCellWithReuseIdentifier:@"Card"];
    [collectionView registerClass:[Install class] forCellWithReuseIdentifier:@"Install"];
    // [collectionView setClipsToBounds:NO];
    [self.view addSubview:collectionView];

    [self addConstraintToItem:self.view attribute:NSLayoutAttributeTopMargin relation:NSLayoutRelationEqual toItem:collectionView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];

    [self addConstraintToItem:self.view attribute:NSLayoutAttributeLeading relation:NSLayoutRelationEqual toItem:collectionView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];

    [self addConstraintToItem:self.view attribute:NSLayoutAttributeBottom relation:NSLayoutRelationEqual toItem:collectionView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];

    [self addConstraintToItem:self.view attribute:NSLayoutAttributeTrailing relation:NSLayoutRelationEqual toItem:collectionView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];



    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl setTintColor:[UIColor whiteColor]];
    [refreshControl addTarget:self action:@selector(refreshApps:) forControlEvents:UIControlEventValueChanged];
    [collectionView setRefreshControl:refreshControl];
}


-(void) refreshApps:(UIRefreshControl *)refreshControl {
    if(apps != getInstalledApps()) {
        apps = nil;
        apps = getInstalledApps();
        [collectionView reloadData];
        [refreshControl endRefreshing];
    }
}


-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return apps.count;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *dict = apps[indexPath.item];
    SBIconModel *model = ((SBIconController *)[NSClassFromString(@"SBIconController") sharedInstance]).model;
    SBIcon *icon = [model expectedIconForDisplayIdentifier:dict[@"bundleID"]];
    SBApplication *app = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:icon.applicationBundleID];

    LSApplicationProxy *appProxy = dict[@"app"];


    if([icon progressPercent] > 0 && [icon progressPercent] < 1.0) {
        Install *install = (Install *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Install" forIndexPath:indexPath];


        [NSTimer scheduledTimerWithTimeInterval:1.0 target:[NSBlockOperation blockOperationWithBlock:^{
            [self updateProgress:install withIcon:icon];
        }] selector:@selector(main) userInfo:nil repeats:YES];


        [install.textLabel setText:appProxy.localizedName];
        [install.iconImageView setIcon:icon location:0 animated:NO];
        return install;
    } else {

        Card *card = (Card *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
        [card setApp:app];

        if(icon.badgeValue != 0) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
            [formatter setNumberStyle: NSNumberFormatterDecimalStyle];

            NSString *badgeValue = [formatter stringFromNumber:[NSNumber numberWithLongLong:icon.badgeValue]];
            NSString *newBadgeValue = @"";
            if(badgeValue.length > 5) {
                newBadgeValue = [badgeValue substringToIndex:badgeValue.length-(badgeValue.length-5)];
            } else {
                newBadgeValue = badgeValue;
            }


            [card.badgeTextView setHidden:NO];
            [card.badgeTextView setText:[NSString stringWithFormat:@"%@", newBadgeValue]];
        } else {
            [card.badgeTextView setHidden:YES];
        }

        if([[[%c(SBApplicationController) sharedInstance] runningApplications] containsObject:app]) {
            [card.runningTextView setHidden:NO];
        } else {
            [card.runningTextView setHidden:YES];
        }


        [card.updateLabel setText:@""];
        [self app:appProxy checkNewAppVersion:^(BOOL newVersion, NSString *version, NSString *url) {
            if(newVersion && !app.systemApplication && !app.internalApplication) {
                [card.updateLabel setText:@"New version available"];
                card.updateLabel.url = url;
            } else {
                [card.updateLabel setText:@""];
            }
        }];



        // [card.updateLabel setText:appProxy._infoDictionary.propertyList[@"CFBundleShortVersionString"]];
        [card.iconImageView setIcon:icon location:0 animated:NO];
        [card.textLabel setText:appProxy.localizedName];

        return card;
    }
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *dict = apps[indexPath.item];
    SBIconModel *model = ((SBIconController *)[NSClassFromString(@"SBIconController") sharedInstance]).model;
    SBIcon *icon = [model expectedIconForDisplayIdentifier:dict[@"bundleID"]];
    SBApplication *app = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:icon.applicationBundleID];


    launchApplication(app);
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 14;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   return CGSizeMake(CGRectGetWidth(collectionView.frame) - 80, 60);
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 40, 40, 40);
}

-(void) collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}


// Other stuff
-(void) updateProgress:(Install *)install withIcon:(SBIcon *)icon {
    [install installApplicationWithProgress:[icon progressPercent]];
}

-(void) app:(LSApplicationProxy *)appProxy checkNewAppVersion:(void(^)(BOOL newVersion, NSString *version, NSString *url))completion
{
    NSDictionary *bundleInfo = appProxy._infoDictionary.propertyList;
    NSString *bundleIdentifier = bundleInfo[@"CFBundleIdentifier"];
    NSString *currentVersion = bundleInfo[@"CFBundleShortVersionString"];
    NSURL *lookupURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?bundleId=%@", bundleIdentifier]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        
        NSData *lookupResults = [NSData dataWithContentsOfURL:lookupURL];
        if (!lookupResults) {
            completion(NO, nil, nil);
            return;
        }
        
        NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:lookupResults options:0 error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSUInteger resultCount = [jsonResults[@"resultCount"] integerValue];
            if (resultCount){
                NSDictionary *appDetails = [jsonResults[@"results"] firstObject];
                NSString *latestVersion = appDetails[@"version"];
                NSString *latestUrl = appDetails[@"trackViewUrl"];
                if ([latestVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
                    completion(YES, latestVersion, latestUrl);
                } else {
                    completion(NO, nil, nil);
                }
            } else {
                completion(NO, nil, nil);
            }
        });
    });
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    if((offsetY < contentHeight - scrollView.frame.size.height) && ([apps isEqual:getInstalledApps()])) {
        [refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"No changes available" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]];
    } else {
        [refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Changes available"]];
    }
}


-(void) addConstraintToItem:(UIView *)firstItem attribute:(NSLayoutAttribute)firstAttribute relation:(NSLayoutRelation)relation toItem:(UIView *)secondItem attribute:(NSLayoutAttribute)secondAttribute multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstItem attribute:firstAttribute relatedBy:relation toItem:secondItem attribute:secondAttribute multiplier:multiplier constant:constant]];
}
@end


@interface SBHomeScreenWindow : UIWindow
@end

BOOL hasLoaded = FALSE;
%hook SBHomeScreenWindow
-(void) layoutSubviews {
    Tredecim *tredecim = [[Tredecim alloc] init];
    if(self.rootViewController != tredecim) {
        [self setRootViewController:tredecim];
        hasLoaded = TRUE;
    }
}
%end

%hook SBIconView
-(void)_updateAccessoryViewWithAnimation:(BOOL)arg1 {
    %orig;
    [collectionView reloadData];
}
%end