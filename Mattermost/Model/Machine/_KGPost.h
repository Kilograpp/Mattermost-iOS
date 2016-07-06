// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGPost.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "KGManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class KGUser;
@class KGChannel;
@class KGFile;

@class NSObject;

@interface KGPostID : NSManagedObjectID {}
@end

@interface _KGPost : KGManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGPostID *objectID;

@property (nonatomic, strong, nullable) id attributedMessage;

@property (nonatomic, strong, nullable) NSString* backendPendingId;

@property (nonatomic, strong, nullable) NSString* channelId;

@property (nonatomic, strong, nullable) NSDate* createdAt;

@property (nonatomic, strong, nullable) NSDate* creationDay;

@property (nonatomic, strong, nullable) NSDate* deletedAt;

@property (nonatomic, strong, nullable) NSNumber* error;

@property (atomic) BOOL errorValue;
- (BOOL)errorValue;
- (void)setErrorValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber* height;

@property (atomic) int16_t heightValue;
- (int16_t)heightValue;
- (void)setHeightValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSString* identifier;

@property (nonatomic, strong, nullable) NSString* message;

@property (nonatomic, strong, nullable) NSString* type;

@property (nonatomic, strong, nullable) NSDate* updatedAt;

@property (nonatomic, strong, nullable) NSString* userId;

@property (nonatomic, strong, nullable) KGUser *author;

@property (nonatomic, strong, nullable) KGChannel *channel;

@property (nonatomic, strong, nullable) NSSet<KGFile*> *files;
- (nullable NSMutableSet<KGFile*>*)filesSet;

@end

@interface _KGPost (FilesCoreDataGeneratedAccessors)
- (void)addFiles:(NSSet<KGFile*>*)value_;
- (void)removeFiles:(NSSet<KGFile*>*)value_;
- (void)addFilesObject:(KGFile*)value_;
- (void)removeFilesObject:(KGFile*)value_;

@end

@interface _KGPost (CoreDataGeneratedPrimitiveAccessors)

- (id)primitiveAttributedMessage;
- (void)setPrimitiveAttributedMessage:(id)value;

- (NSString*)primitiveBackendPendingId;
- (void)setPrimitiveBackendPendingId:(NSString*)value;

- (NSString*)primitiveChannelId;
- (void)setPrimitiveChannelId:(NSString*)value;

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;

- (NSDate*)primitiveCreationDay;
- (void)setPrimitiveCreationDay:(NSDate*)value;

- (NSDate*)primitiveDeletedAt;
- (void)setPrimitiveDeletedAt:(NSDate*)value;

- (NSNumber*)primitiveError;
- (void)setPrimitiveError:(NSNumber*)value;

- (BOOL)primitiveErrorValue;
- (void)setPrimitiveErrorValue:(BOOL)value_;

- (NSNumber*)primitiveHeight;
- (void)setPrimitiveHeight:(NSNumber*)value;

- (int16_t)primitiveHeightValue;
- (void)setPrimitiveHeightValue:(int16_t)value_;

- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;

- (NSString*)primitiveMessage;
- (void)setPrimitiveMessage:(NSString*)value;

- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;

- (NSString*)primitiveUserId;
- (void)setPrimitiveUserId:(NSString*)value;

- (KGUser*)primitiveAuthor;
- (void)setPrimitiveAuthor:(KGUser*)value;

- (KGChannel*)primitiveChannel;
- (void)setPrimitiveChannel:(KGChannel*)value;

- (NSMutableSet<KGFile*>*)primitiveFiles;
- (void)setPrimitiveFiles:(NSMutableSet<KGFile*>*)value;

@end

@interface KGPostAttributes: NSObject 
+ (NSString *)attributedMessage;
+ (NSString *)backendPendingId;
+ (NSString *)channelId;
+ (NSString *)createdAt;
+ (NSString *)creationDay;
+ (NSString *)deletedAt;
+ (NSString *)error;
+ (NSString *)height;
+ (NSString *)identifier;
+ (NSString *)message;
+ (NSString *)type;
+ (NSString *)updatedAt;
+ (NSString *)userId;
@end

@interface KGPostRelationships: NSObject
+ (NSString *)author;
+ (NSString *)channel;
+ (NSString *)files;
@end

NS_ASSUME_NONNULL_END
