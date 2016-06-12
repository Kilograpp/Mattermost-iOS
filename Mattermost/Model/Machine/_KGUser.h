// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGUser.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "KGManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class KGChannel;
@class KGPost;

@interface KGUserID : NSManagedObjectID {}
@end

@interface _KGUser : KGManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGUserID *objectID;

@property (nonatomic, strong, nullable) NSString* email;

@property (nonatomic, strong, nullable) NSString* firstName;

@property (nonatomic, strong, nullable) NSString* identifier;

@property (nonatomic, strong, nullable) NSString* lastName;

@property (nonatomic, strong, nullable) NSString* nickname;

@property (nonatomic, strong, nullable) NSString* username;

@property (nonatomic, strong, nullable) KGChannel *channels;

@property (nonatomic, strong, nullable) NSSet<KGPost*> *posts;
- (nullable NSMutableSet<KGPost*>*)postsSet;

@end

@interface _KGUser (PostsCoreDataGeneratedAccessors)
- (void)addPosts:(NSSet<KGPost*>*)value_;
- (void)removePosts:(NSSet<KGPost*>*)value_;
- (void)addPostsObject:(KGPost*)value_;
- (void)removePostsObject:(KGPost*)value_;

@end

@interface _KGUser (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;

- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;

- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;

- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;

- (NSString*)primitiveNickname;
- (void)setPrimitiveNickname:(NSString*)value;

- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;

- (KGChannel*)primitiveChannels;
- (void)setPrimitiveChannels:(KGChannel*)value;

- (NSMutableSet<KGPost*>*)primitivePosts;
- (void)setPrimitivePosts:(NSMutableSet<KGPost*>*)value;

@end

@interface KGUserAttributes: NSObject 
+ (NSString *)email;
+ (NSString *)firstName;
+ (NSString *)identifier;
+ (NSString *)lastName;
+ (NSString *)nickname;
+ (NSString *)username;
@end

@interface KGUserRelationships: NSObject
+ (NSString *)channels;
+ (NSString *)posts;
@end

NS_ASSUME_NONNULL_END
