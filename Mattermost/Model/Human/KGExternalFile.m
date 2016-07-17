#import "KGExternalFile.h"

@interface KGExternalFile ()

// Private interface goes here.

@end

@implementation KGExternalFile

- (NSURL *)thumbLink {
    return [self downloadLink];
}

- (NSURL *)downloadLink {
    return [NSURL URLWithString:self.link];
}

@end
