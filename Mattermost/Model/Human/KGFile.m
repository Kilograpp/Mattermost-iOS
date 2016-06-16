#import "KGFile.h"
#import "KGBusinessLogic.h"
#import "KGBusinessLogic+File.h"
#import "NSStringUtils.h"
#import <RestKit.h>
#import <SDWebImage/SDImageCache.h>

@interface KGFile ()

// Private interface goes here.

@end

@implementation KGFile
#pragma mark - Interface Methods

- (BOOL)isImage {
    return  [self.backendMimeType hasPrefix:@"image/"] ||
            [[self.name pathExtension] caseInsensitiveCompare:@"png"] == NSOrderedSame ||
            [[self.name pathExtension] caseInsensitiveCompare:@"jpg"] == NSOrderedSame;
}

- (NSURL *)downloadLink {
    return [[KGBusinessLogic sharedInstance] downloadLinkForFile:self];
}

- (NSURL *)thumbLink {
    if (self.hasPreviewImageValue){
        return [[KGBusinessLogic sharedInstance] thumbLinkForFile:self];
    } else {
        return nil;
    }
}


#pragma mark - Response Mapping

+ (RKEntityMapping *)simpleEntityMapping {
    RKEntityMapping *mapping = [super emptyEntityMapping];
    [mapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:[KGFileAttributes backendLink]]];
    [mapping setIdentificationAttributes:@[[KGFileAttributes backendLink]]];
    return mapping;
}


+ (RKEntityMapping *)entityMapping {
    RKEntityMapping *mapping = [super emptyEntityMapping];
    [mapping setIdentificationAttributes:@[[KGFileAttributes name]]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"filename" : [KGFileAttributes name],
            @"mime_type" : [KGFileAttributes backendMimeType],
            @"has_preview_image" : [KGFileAttributes hasPreviewImage]
    }];
    [mapping addAttributeMappingsFromArray:@[[KGFileAttributes size],[KGFileAttributes extension]]];
    return mapping;
}

#pragma mark - Path Patterns

+ (NSString*)uploadFilePathPattern {
    return @"teams/:identifier/files/upload";
}

+ (NSString*)unifiedUpdatePathPattern {
    return @"teams/:path/files/get_info/:path/:path/:path/:path";
}

+ (NSString*)updatePathPattern {
    return @"teams/:post.channel.team.identifier/files/get_info:backendLink";
}

+ (NSString*)downloadLinkPathPattern {
    return @"teams/:post.channel.team.identifier/files/get:backendLink";
}

+ (NSString*)thumbLinkPathPattern {
    return @"teams/:post.channel.team.identifier/files/get:thumbPostfix.jpg";
}

#pragma mark - Response Descriptors

+ (RKResponseDescriptor*)updateResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self entityMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self unifiedUpdatePathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}


+ (RKResponseDescriptor*)uploadResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self emptyResponseMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:[self uploadFilePathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}


#pragma mark - Support


- (NSString*)thumbPostfix {
    return [self.noExtensionBackendLink stringByAppendingString:@"_thumb"];
}

- (NSString*)previewPosfix {
    return [self.noExtensionBackendLink stringByAppendingString:@"preview"];
}

- (NSString*)noExtensionBackendLink {
    return [self.backendLink stringByDeletingPathExtension];
}

- (void)fillNameFromBackendLink {
    NSArray *fileComponents = [self.backendLink componentsSeparatedByString:@"/"];
    NSString * fileIdentifier = fileComponents[fileComponents.count - 2];
    NSString * fileName = [fileComponents.lastObject stringByRemovingPercentEncoding];
    self.name = [fileIdentifier stringByAppendingPathComponent:fileName];
}

#pragma mark - Core Data

- (void)willSave {
    if ([NSStringUtils isStringEmpty:self.name] && ![NSStringUtils isStringEmpty:self.backendLink]) {
        [self fillNameFromBackendLink];
    }
};

- (void)prepareForDeletion {
    [[SDImageCache sharedImageCache] removeImageForKey:self.backendLink];
}

@end
