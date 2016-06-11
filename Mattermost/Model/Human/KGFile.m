#import "KGFile.h"
#import "KGBusinessLogic.h"
#import "KGBusinessLogic+File.h"
#import "NSStringUtils.h"
#import <RestKit.h>

@interface KGFile ()

// Private interface goes here.

@end

@implementation KGFile

#pragma mark - Response Mapping

- (BOOL)isImage {
    return [self.backendMimeType hasPrefix:@"image/"];
}

- (NSString*)noExtensionBackendLink {
    return [self.backendLink stringByDeletingPathExtension];
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


+ (RKEntityMapping *)simpleEntityMapping {
    RKEntityMapping *mapping = [super emptyEntityMapping];
    [mapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"backendLink"]];
    [mapping setIdentificationAttributes:@[@"backendLink"]];
    return mapping;
}

+ (RKEntityMapping *)entityMapping {
    RKEntityMapping *mapping = [super emptyEntityMapping];
    [mapping setIdentificationAttributes:@[@"name"]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"filename" : @"name",
            @"mime_type" : @"backendMimeType",
            @"has_preview_image" : @"hasPreviewImage"
    }];
    [mapping addAttributeMappingsFromArray:@[@"size",@"extension"]];
    return mapping;
}

#pragma mark - Path Patterns

+ (NSString*)simplifiedUpdatePathPattern {
    return @"teams/:a/files/get_info/:b/:c/:d/:e";
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
                                                   pathPattern:[self simplifiedUpdatePathPattern]
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

#pragma mark - Core Data



#warning Kostyl Detected
- (void)willSave {
    if ([NSStringUtils isStringEmpty:self.name]) {
        NSArray *fileComponents = [self.backendLink componentsSeparatedByString:@"/"];
        NSString * fileIdentifier = fileComponents[fileComponents.count - 2];
        NSString * fileName = [fileComponents.lastObject stringByRemovingPercentEncoding];
        self.name = [fileIdentifier stringByAppendingPathComponent:fileName];
    }
};


@end
