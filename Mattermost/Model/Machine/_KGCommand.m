// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGCommand.m instead.

#import "_KGCommand.h"

@implementation KGCommandID
@end

@implementation _KGCommand

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Command" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Command";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Command" inManagedObjectContext:moc_];
}

- (KGCommandID*)objectID {
	return (KGCommandID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic hint;

@dynamic message;

@dynamic name;

@dynamic trigger;

@end

@implementation KGCommandAttributes 
+ (NSString *)hint {
	return @"hint";
}
+ (NSString *)message {
	return @"message";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)trigger {
	return @"trigger";
}
@end

