// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGUser.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "KGBaseEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface KGUserID : KGBaseEntityID {}
@end

@interface _KGUser : KGBaseEntity
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

- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;

- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;

@end

@interface KGUserAttributes: NSObject 
+ (NSString *)currentUser;
+ (NSString *)email;
+ (NSString *)firstName;
+ (NSString *)lastName;
+ (NSString *)username;
@end

NS_ASSUME_NONNULL_END
