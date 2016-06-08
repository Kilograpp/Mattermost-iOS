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

@interface KGUserID : NSManagedObjectID {}
@end

@interface _KGUser : KGManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGUserID *objectID;

@property (nonatomic, strong, nullable) NSNumber* currentUser;

@property (atomic) BOOL currentUserValue;
- (BOOL)currentUserValue;
- (void)setCurrentUserValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString* email;

@property (nonatomic, strong, nullable) NSString* firstName;

@property (nonatomic, strong, nullable) NSNumber* identifier;

@property (atomic) int64_t identifierValue;
- (int64_t)identifierValue;
- (void)setIdentifierValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSString* lastName;

@property (nonatomic, strong, nullable) NSString* username;

@end

@interface _KGUser (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveCurrentUser;
- (void)setPrimitiveCurrentUser:(NSNumber*)value;

- (BOOL)primitiveCurrentUserValue;
- (void)setPrimitiveCurrentUserValue:(BOOL)value_;

- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;

- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;

- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int64_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int64_t)value_;

- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;

- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;

@end

@interface KGUserAttributes: NSObject 
+ (NSString *)currentUser;
+ (NSString *)email;
+ (NSString *)firstName;
+ (NSString *)identifier;
+ (NSString *)lastName;
+ (NSString *)username;
@end

NS_ASSUME_NONNULL_END
