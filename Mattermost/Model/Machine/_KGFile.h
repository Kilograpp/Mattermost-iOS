// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGFile.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "KGManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class KGPost;

@interface KGFileID : NSManagedObjectID {}
@end

@interface _KGFile : KGManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGFileID *objectID;

@property (nonatomic, strong, nullable) NSString* backendLink;

@property (nonatomic, strong, nullable) NSString* backendMimeType;

@property (nonatomic, strong, nullable) NSString* extension;

@property (nonatomic, strong, nullable) NSNumber* hasPreviewImage;

@property (atomic) BOOL hasPreviewImageValue;
- (BOOL)hasPreviewImageValue;
- (void)setHasPreviewImageValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSNumber* size;

@property (atomic) int32_t sizeValue;
- (int32_t)sizeValue;
- (void)setSizeValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSString* tempId;

@property (nonatomic, strong, nullable) KGPost *post;

@end

@interface _KGFile (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveBackendLink;
- (void)setPrimitiveBackendLink:(NSString*)value;

- (NSString*)primitiveBackendMimeType;
- (void)setPrimitiveBackendMimeType:(NSString*)value;

- (NSString*)primitiveExtension;
- (void)setPrimitiveExtension:(NSString*)value;

- (NSNumber*)primitiveHasPreviewImage;
- (void)setPrimitiveHasPreviewImage:(NSNumber*)value;

- (BOOL)primitiveHasPreviewImageValue;
- (void)setPrimitiveHasPreviewImageValue:(BOOL)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveSize;
- (void)setPrimitiveSize:(NSNumber*)value;

- (int32_t)primitiveSizeValue;
- (void)setPrimitiveSizeValue:(int32_t)value_;

- (NSString*)primitiveTempId;
- (void)setPrimitiveTempId:(NSString*)value;

- (KGPost*)primitivePost;
- (void)setPrimitivePost:(KGPost*)value;

@end

@interface KGFileAttributes: NSObject 
+ (NSString *)backendLink;
+ (NSString *)backendMimeType;
+ (NSString *)extension;
+ (NSString *)hasPreviewImage;
+ (NSString *)name;
+ (NSString *)size;
+ (NSString *)tempId;
@end

@interface KGFileRelationships: NSObject
+ (NSString *)post;
@end

NS_ASSUME_NONNULL_END
