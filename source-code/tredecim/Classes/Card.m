#import "Card.h"


@implementation Label
-(id) initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapGesture];
    } return self;
}


-(void) handleTap:(UIGestureRecognizer *)recognizer {
    [self interactWithURL:[NSURL URLWithString:self.url]];
}

-(void) interactWithURL:(NSURL *)URL {
    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
}
@end


@implementation Card
@synthesize iconImageView;
@synthesize textLabel, updateLabel;
@synthesize badgeTextView, runningTextView;
-(id) initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        iconImageView = [[NSClassFromString(@"SBIconImageView") alloc] init];
        [iconImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:iconImageView];

        [self addConstraintToItem:self attribute:NSLayoutAttributeTop relation:NSLayoutRelationEqual toItem:iconImageView attribute:NSLayoutAttributeTop multiplier:1 constant:-12];
        [self addConstraintToItem:self attribute:NSLayoutAttributeLeading relation:NSLayoutRelationEqual toItem:iconImageView attribute:NSLayoutAttributeLeading multiplier:1 constant:-16];
        [self addConstraintToItem:self attribute:NSLayoutAttributeBottom relation:NSLayoutRelationEqual toItem:iconImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:12];
        [self addConstraintToItem:iconImageView attribute:NSLayoutAttributeWidth relation:NSLayoutRelationEqual toItem:iconImageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];


        UIView *labelView = [[UIView alloc] init];
        [labelView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:labelView];

        [self addConstraintToItem:self attribute:NSLayoutAttributeCenterY relation:NSLayoutRelationEqual toItem:labelView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self addConstraintToItem:iconImageView attribute:NSLayoutAttributeTrailing relation:NSLayoutRelationEqual toItem:labelView attribute:NSLayoutAttributeLeading multiplier:1 constant:-12];



        textLabel = [[UILabel alloc] init];
        [textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [textLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightSemibold]];
        [textLabel.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [textLabel.layer setShadowOffset:CGSizeZero];
        [textLabel.layer setShadowRadius:8.0];
        [textLabel.layer setShadowOpacity:0.3];
        [labelView addSubview:textLabel];

        [self addConstraintToItem:labelView attribute:NSLayoutAttributeLeading relation:NSLayoutRelationEqual toItem:textLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        [self addConstraintToItem:labelView attribute:NSLayoutAttributeTop relation:NSLayoutRelationEqual toItem:textLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0];


        updateLabel = [[Label alloc] init];
        [updateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [updateLabel setFont:[UIFont systemFontOfSize:11.5 weight:UIFontWeightMedium]];
        [updateLabel setTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3]];
        [self addSubview:updateLabel];

        [self addConstraintToItem:textLabel attribute:NSLayoutAttributeBottom relation:NSLayoutRelationEqual toItem:updateLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self addConstraintToItem:labelView attribute:NSLayoutAttributeLeading relation:NSLayoutRelationEqual toItem:updateLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        [self addConstraintToItem:updateLabel attribute:NSLayoutAttributeBottom relation:NSLayoutRelationEqual toItem:labelView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];


        badgeTextView = [[UITextView alloc] init];
        [badgeTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [badgeTextView setFont:[UIFont systemFontOfSize:11.5 weight:UIFontWeightMedium]];
        [badgeTextView setBackgroundColor:[UIColor systemRedColor]];
        [badgeTextView setTextContainerInset:UIEdgeInsetsMake(2, 0.5, 2.5, 0.5)];
        [badgeTextView setScrollEnabled:NO];
        [badgeTextView setUserInteractionEnabled:NO];
        [badgeTextView setTextAlignment:NSTextAlignmentCenter];
        [badgeTextView setTextColor:[UIColor whiteColor]];
        [self addSubview:badgeTextView];

        [self addConstraintToItem:iconImageView attribute:NSLayoutAttributeCenterY relation:NSLayoutRelationEqual toItem:badgeTextView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self addConstraintToItem:self attribute:NSLayoutAttributeTrailing relation:NSLayoutRelationEqual toItem:badgeTextView attribute:NSLayoutAttributeTrailing multiplier:1 constant:16];
        [self addConstraintToItem:badgeTextView attribute:NSLayoutAttributeWidth relation:NSLayoutRelationGreaterThanOrEqual toItem:badgeTextView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];


        runningTextView = [[UITextView alloc] init];
        [runningTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [runningTextView setBackgroundColor:[UIColor systemGreenColor]];
        [runningTextView setScrollEnabled:NO];
        [runningTextView setUserInteractionEnabled:NO];
        [runningTextView.layer setMasksToBounds:NO];
        [runningTextView.layer setCornerRadius:4];
        [runningTextView.layer setBorderWidth:1.5];
        [runningTextView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self addSubview:runningTextView];

        [self addConstraintToItem:iconImageView attribute:NSLayoutAttributeBottom relation:NSLayoutRelationEqual toItem: runningTextView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self addConstraintToItem:iconImageView attribute:NSLayoutAttributeCenterX relation:NSLayoutRelationEqual toItem:runningTextView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [self addConstraintToItem:runningTextView attribute:NSLayoutAttributeWidth relation:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:8];
        [self addConstraintToItem:runningTextView attribute:NSLayoutAttributeHeight relation:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:8];
    } return self;
}


-(void) layoutSubviews {
    [super layoutSubviews];

    [textLabel setTextColor:[UIColor whiteColor]];

    [self createMaskForView:self cornerRadius:18];
    [self createMaskForView:iconImageView cornerRadius:10];
    [self createMaskForView:badgeTextView cornerRadius:badgeTextView.frame.size.height / 2];

    if(![blurView isDescendantOfView:self]) {
        [self createBlurView];
    }
}


-(void) createMaskForView:(UIView *)view cornerRadius:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *mask = [CAShapeLayer layer];
    [mask setPath:[path CGPath]];
    [view.layer setMask:mask];
}

-(void) createBlurView {
    blurView = [NSClassFromString(@"MTMaterialView") materialViewWithRecipe:2 configuration:1];
    [blurView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:blurView];
    [self sendSubviewToBack:blurView];

    [self addConstraintToItem:self attribute:NSLayoutAttributeTop relation:NSLayoutRelationEqual toItem:blurView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self addConstraintToItem:self attribute:NSLayoutAttributeLeading relation:NSLayoutRelationEqual toItem:blurView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    [self addConstraintToItem:self attribute:NSLayoutAttributeBottom relation:NSLayoutRelationEqual toItem:blurView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self addConstraintToItem:self attribute:NSLayoutAttributeTrailing relation:NSLayoutRelationEqual toItem:blurView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
}



-(void) addConstraintToItem:(UIView *)firstItem attribute:(NSLayoutAttribute)firstAttribute relation:(NSLayoutRelation)relation toItem:(UIView *)secondItem attribute:(NSLayoutAttribute)secondAttribute multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:firstItem attribute:firstAttribute relatedBy:relation toItem:secondItem attribute:secondAttribute multiplier:multiplier constant:constant]];
}
@end