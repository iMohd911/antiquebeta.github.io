#import "../headers.h"

@interface Label : UILabel
@property (nonatomic, strong) NSString *url;
-(void) interactWithURL:(NSURL *)URL;
@end


@interface Card : UICollectionViewCell {
    MTMaterialView *blurView;
}

@property (nonatomic, strong) SBApplication *app;

@property (nonatomic, strong) SBIconImageView *iconImageView;

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *versionLabel;

@property (nonatomic, strong) UITextView *badgeTextView;
@property (nonatomic, strong) UITextView *runningTextView;
@property (nonatomic, strong) Label *updateLabel;
@end