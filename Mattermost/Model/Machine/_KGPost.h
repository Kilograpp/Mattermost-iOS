// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGPost.h instead.

@import CoreData;
#import "KGManagedObject.h"

extern const struct KGPostAttributes {
	__unsafe_unretained NSString *channelId;
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *deletedAt;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *message;
	__unsafe_unretained NSString *type;
	__unsafe_unretained NSString *updatedAt;
	__unsafe_unretained NSString *userId;
} KGPostAttributes;

extern const struct KGPostRelationships {
	__unsafe_unretained NSString *author;
	__unsafe_unretained NSString *channel;
} KGPostRelationships;

@class KGUser;
@class KGChannel;

@interface KGPostID : NSManagedObjectID {}
@end

@interface _KGPost : KGManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGPostID* objectID;

@property (nonatomic, strong) NSString* channelId;

//- (BOOL)validateChannelId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* createdAt;

//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* deletedAt;

//- (BOOL)validateDeletedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* identifier;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* message;

//- (BOOL)validateMessage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* updatedAt;

//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userId;

//- (BOOL)validateUserId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) KGUser *author;

//- (BOOL)validateAuthor:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) KGChannel *channel;

//- (BOOL)validateChannel:(id*)value_ error:(NSError**)error_;

@end

@interface _KGPost (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveChannelId;
- (void)setPrimitiveChannelId:(NSString*)value;

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;

- (NSDate*)primitiveDeletedAt;
- (void)setPrimitiveDeletedAt:(NSDate*)value;

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

@end
