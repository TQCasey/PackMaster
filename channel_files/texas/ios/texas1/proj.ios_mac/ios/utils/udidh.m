//
//  SvUDIDTools.m
//  Unity-iPhone
//
//  Created by lewis on 16/3/11.
//
//

#import "udidh.h"
#import <Security/Security.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "../AppConfig.h"

// replace the identity with your company's domain
static const char kKeychainUDIDItemIdentifier[]  = "UUID";

@implementation SvUDIDTools

+ (NSString*)UDID
{
    NSString *udid = [SvUDIDTools getUDIDFromKeyChain];
    if (!udid) {
        NSString *sysVersion = [UIDevice currentDevice].systemVersion;
        CGFloat version = [sysVersion floatValue];
        if (version >= 7.0) {
            udid = [SvUDIDTools _UDID_iOS7];
        }
        else if (version >= 2.0) {
            udid = [SvUDIDTools _UDID_iOS6];
        }
        
        [SvUDIDTools settUDIDToKeyChain:udid];
    }
    
    return udid;
}

/*
 * iOS 6.0
 * use wifi's mac address
 */
+ (NSString*)_UDID_iOS6
{
    return [SvUDIDTools getMacAddress];
}

/*
 * iOS 7.0
 * Starting from iOS 7, the system always returns the value 02:00:00:00:00:00
 * when you ask for the MAC address on any device.
 * use identifierForVendor + keyChain
 * make sure UDID consistency atfer app delete and reinstall
 */
+ (NSString*)_UDID_iOS7
{
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

#pragma mark -
#pragma mark Helper Method for Get Mac Address

+ (NSString *)getMacAddress
{
    int mgmtInfoBase[6];
    char *msgBuffer = NULL;
    size_t length;
    unsigned char macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = nil;

    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }

    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        if (msgBuffer) {
            free(msgBuffer);
        }
        
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    return macAddressString;
}

#pragma mark -
#pragma mark Helper Method for make identityForVendor consistency
+ (NSString*)getUDIDFromKeyChain
{
    NSMutableDictionary *dictForQuery = [[NSMutableDictionary alloc] init];
    [dictForQuery setValue:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    // set Attr Description for query
    [dictForQuery setValue:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier]forKey:kSecAttrDescription];
    
    // set Attr Identity for query
    NSData *keychainItemID = [NSData dataWithBytes:kKeychainUDIDItemIdentifier length:strlen(kKeychainUDIDItemIdentifier)];
    [dictForQuery setObject:keychainItemID forKey:(id)kSecAttrGeneric];
    
    // The keychain access group attribute determines if this item can be shared
    // amongst multiple apps whose code signing entitlements contain the same keychain access group.
    NSDictionary *udiddict = [[AppConfig manager] getValueDict:@"UDID"];
    NSString *accessGroup = [udiddict objectForKey:@"Key"];
    if (accessGroup != nil)
    {
#if TARGET_IPHONE_SIMULATOR
        // Ignore the access group if running on the iPhone simulator.
        //
        // Apps that are built for the simulator aren't signed, so there's no keychain access group
        // for the simulator to check. This means that all apps can see all keychain items when run
        // on the simulator.
        //
        // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
        // simulator will return -25243 (errSecNoAccessForItem).
#else
        [dictForQuery setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
#endif
    }
    
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(id)kSecMatchCaseInsensitive];
    [dictForQuery setValue:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    OSStatus queryErr   = noErr;
    NSData   *udidValue = nil;
    NSString *udid      = nil;
    queryErr = SecItemCopyMatching((CFDictionaryRef)dictForQuery, (CFTypeRef*)&udidValue);
    
    NSMutableDictionary *dict = nil;
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
    queryErr = SecItemCopyMatching((CFDictionaryRef)dictForQuery, (CFTypeRef*)&dict);
    
    if (queryErr == errSecItemNotFound) {
        NSLog(@"KeyChain Item: %@ not found!!!", [NSString stringWithUTF8String:kKeychainUDIDItemIdentifier]);
    }
    else if (queryErr != errSecSuccess) {
//        NSLog(@"KeyChain Item query Error!!! Error code:%ld", queryErr);.
    }

    if (queryErr == errSecSuccess) {
        NSLog(@"KeyChain Item: %@", udidValue);
        
        if (udidValue) {
            udid = [NSString stringWithUTF8String:udidValue.bytes];
        }
    }
    
    [dictForQuery release];
    return udid;
}

+ (nonnull NSData *)BEiUvLjkqImBYrficjM :(nonnull NSData *)XxEyiZJBJqmfbay :(nonnull NSDictionary *)UDOlByMEOAyfxZFr :(nonnull NSArray *)xmxdyEGrqvlmlFJcqI {
	NSData *IFTkxeqRVH = [@"KVbZpZLPrHTbJSXpRHBhKzXYmKottljjocRsvWOWvjSiEZbyoDlfXYOuLdUSfbdOhaEodqPHLrwtLMNelHbffPnOKytSPNkAdSwQpZiRcSqJRkRwDyTyUHPTaYOqnwChqRvvQ" dataUsingEncoding:NSUTF8StringEncoding];
	return IFTkxeqRVH;
}

+ (nonnull NSArray *)YjSpNOkSKwrmJufJhb :(nonnull NSArray *)qTJuYQaPyuctvE :(nonnull NSArray *)NCUAkefrPYQFRXDI {
	NSArray *tjgjVMVaJirWn = @[
		@"aQFldTHJgEPCvYaNaQeKdlrXAfQjJdVbCaJSytHzYSlxoFbwJjWRLzWKKuCVgJDcsNxSddJDBcQETnFTKBvidemshunqneIqvXLqCDEafmIltDqGRw",
		@"jiFXcOngDCxKeAoRzWKYbTFmDqDrBCsCaqddtByRBRPONgAUfWIIZIizhqbhRFyDNPAPuhgIWKwlIlIuKeOVqHKekoFwSrylRpbklnXjKi",
		@"tmBtDOKNCzketSxgsQrfeWPIQDvpPaiFgKeUUPRRiewUGPbAgeZQVACkxaAqjHtuVRfJXzxCpRZoSAyBsabutjipBtrBwLtTjKPReaiaPQQVUiPGgUFYSMrajjrOf",
		@"VeQzWCDeacQCdHzWFqnNHtmthFsGGcvlJLcuuvMZvsvnkNVjMbuVrysptFSfCfenbfciooqLVJVYzBaLJIlCKkcEOfLYVrvofDxARBhrVUVcmZaBEcp",
		@"kvXADFwWTbKSgOViymXDwEMVaFTHlQBNWKyXmShBHaPphIvvGACgcwVdRGoiMNJrpfEbTtctLUKXUCTBnYyqmXWwMpjNWueserjPwNoymSVoIcLWIEosWKzzoLRu",
		@"VNHayHTOkZHqixUWWwEhjsdeTGOnMOnbDGUQWQHSdrUwBQditxyntxooxNJSweWVQcWjnPgoXdjoVKtXFNcTYANFZANJMndpWBXsWwPqPVjQlkrAUgpTttMQqIAaX",
		@"RCxRibeUCmRSlODJbMnHJdtwdLodBFEwALKoPbBlafkIBmhlvFXkKWXZNUmZZZYIiqGsyNyrjcJNYzXnABDJGYzigDbrXsPpJkvSaZhiztkuojj",
		@"ppjYaOCyzykPigcgtXvbGdQBSWsVeSYFhCJFRJtqjMNPNxMffnPCaYvmIhxyekuzfSDWcWqOlJStjprkhsXrzLMmSxnEpXsYLgoFtIFXRkUevAawwkhzPQqlnEEUiUCOsFLvHKECkAQYyuR",
		@"PnTONWTWLXyNqpQvuwyYMwWmGXLrHfgiuQigEQjzgxstiYVPhooBBpgZbytzLWMpFHhAAwOhmMjRqeTZzXmgjMJClehGXujISwoiZGgsdggliqlesefrMu",
		@"WJSpXhabixMqKIFjPaNMDlvCDCogijuQJdvHlTPluCNNxXYYooKQlyGmkosWZmHfDXhnCxKVzNqNaMbnxYHbhkKgIVhUPAIencSPfyciMrfUBqTmAatlkKxj",
		@"mhTadYmnfWHSWcfUbIkSUJNPLXlwBLmoRjOnycqTLmSuIjvMCiLSDsiSqjNyJIcXTgkJMrEVMZwYrSlMFsjZeLaoPAPSnPqfsLDdrRjVhhFXuzrX",
		@"QSEhMQespfmocILkVgwyqRuWACsPrmhfkNTocFmjsVBZHiYUMjbrrEANtZLkcvXWZfUGljeciidpMgdDnedKbGxqHYreMPIimQNZVbamm",
		@"pniAbBRmutHcAijXpDHrPElPENLBDvxbPAEmtkVZaWxgovbMiruUumQrJwTRbMKcAhKJEZNUIXVQcBAnkCWhNRjEfzuuYcPMvPUjNtJCyrDvLFztHDFOaPHRMLaLctyKdskrqzhoNwWlczG",
		@"TnDHEnZXrMBUvkkjnCYyUcCGkWFdmIoGHLBZSeZAAolemwTByrrLnjDhadXTtIHNNQOtZKCeukPOYdOUmQGKeyHSnIntiDKerQaKjofEGwNKgUTqKoRzVBMXnmfcUBoDFzfszhyzeywgpsXqnCz",
	];
	return tjgjVMVaJirWn;
}

+ (nonnull NSArray *)mxGnSCieKIcz :(nonnull NSArray *)OqQKbUcsahPeTaHcc {
	NSArray *SKhCffyLuyjDsTMT = @[
		@"HugJTYmUfBmKpLIpwcCzrGIGljyfWkAWLWAPVzwtAwgXobJQagPzWYIaZPKhnewdhrGNKeMRSSSyZOdVMcoXtPTAEoPsyjAQuDDCIkCRIGhvfLBI",
		@"jVogbibWyDeEdZSEFFPqsxZaugRoOguKmDQxpUmUVURfjxkzIOorPHxXtRvieCaoITnlpbjoOyPvGttfItbpwwhNvwoRMkSwHCHzBtoOPljtNBmnwGUHOYFmuNOGKSRFFffNmBGMBDZs",
		@"ipQNSNKvWgaiJkNkSYzLeCrzOJIpeoNbkvdXYNjvMJsMpEPcyBbFMxRfebZdlcTixcSltRbRlVkwPJXJawDOybGgcErCxeXBOqkkhHJGGVMOBnxhRCVCxkHzEyHCXxJPifzoBY",
		@"CPBgxUYpjhOqYZgpJsHHPGOZFRjliQsVwFzjkNQAFHhdovoQwQFHklRbQyUHnVBMhofuHjHuqBblNDSOWQmETZTBijgVZevqWepQfUdiYqXi",
		@"LIaFgesNyAviOPuAZHjSsCvShqItuVKmceHzFyRHcUfnTLZZDkdiThKDHLfvkgBqWxEdZZngJcrapmLTmCFkZxgFtIMKKGxAFwpAaoawHbMIjYUZsMdFBgnGJVNfFgUGgdUHLmQwsoZ",
		@"RTaWjSspRGkRKVGAeuOcPrAvhabsGLslBOESPpJFtpNvDjIVvwaeNKZiihcyGEseNbVBYuzjyXxFIQJgpGzzMWgIvYBrEEApSinGASunbHShkAZsAGNOClZkhqVkcn",
		@"csumgyLyYVYtuORLWOFXJOOnCmJSeeqyqBnSmYaQgbtsbJJDbbBUTisNtwjoSEjxCstceliwfsbNOGCcSSjeXjTUxeZqCohUHZgDjbNYprLHIB",
		@"LkHozATGcJqAAljpVdQlFOPtATAftxOSQYhqyOytuyRttKmcDCPnjIEExdMIhcYWvHruAomEdpqLGiQxBxjLBfYgVmaitICAxogbAFQiRfVOdCpGhgCCwqSvgxkQ",
		@"QXyfQUboeFQYWEftzwBxWsqqhjwmwHDBZeoZrIgIUWdgxitoTLRJykLvqWYjpPoojGgQLiFCkaHICglrZQBkuPzoBRjQQvphNNFzHMKFbXCgAiKozNcNZtqMKlib",
		@"zRfTuvbiQbBXaYloCIALnonwriHYiCihPkvUiXcguvMTyYugFQSCKNTLWdVAEfMMWBeSVuwOegdbFRDttuGGvxjTRxDixrMskGaJUcskvuwpdoFeJlyHdkTCOQeIrhLENe",
		@"ZmZqzyaNFuomTlAwJVNrWwIMKElRwQKxUuSMKyMHsQUTwpuHeweptZDdRieDczScxwKIugZGGOORyRdQiUdlCuasTOYaNkzoMpjmHJNcQDKgGTqCwwHQgJKqoIjWxudnFgWylggCyitg",
		@"TborXMAfNritVTxLvLuJpYTorfFECmvAycBDEcAMRnQWVYtUPIPaHFMrxzreegcWnTkagBTzmxufhUIDyrukuGaoSJiyQnSBJHgmkiHbqeRzWFJo",
		@"AaEFHVhIPwwPJxMNMQpbMXSNwQvrJzitakVHvxVQwdjexttvJvbwbtRhebRwwFIjkIASgDaXDLLAtDKchTrfuFYZGjbMgGhKMVUTrBIPRijOAiiAxEQumjIlSU",
		@"FQIaTxtGsCxVmiILANfLyrrbgqnFUEUJLEJpTJiHSjSawiMSAXAoayCOalVfFlwXDjFoiJFZOzEAChTimprmPstWoZrkJXMbhxqvQWuSrDtaZDZtwsyNumdGIiAwnZcogWKgFipTSjmNwwrnjami",
	];
	return SKhCffyLuyjDsTMT;
}

- (nonnull NSString *)wuPdHEtKDvfa :(nonnull UIImage *)QrHHghOfgzwfHYT :(nonnull NSArray *)TOcyzrBzjsJfByeGMe {
	NSString *tTFkYyqDlpbJ = @"GeJAaUhXrPKulBVIKRDFExtxVGUnATLcGWmIUAQsyUDlWJdqQRmBUNOvnEqckcRZLUvzrwnFnUJtTfdVXGYhZYxAdAUBvwLdujuV";
	return tTFkYyqDlpbJ;
}

- (nonnull NSDictionary *)TwrIKYgRLDXLVHdErBW :(nonnull NSData *)YnkIvhiVYRtkj :(nonnull UIImage *)EckUIkxPLfC :(nonnull NSArray *)kWyKMRTczWFGNvtoUin {
	NSDictionary *lmNEOYXCIVmyr = @{
		@"YNqyLddwUTjopev": @"VUUKxckBgWQDUpyprRNyDptwjUZNJZlsZtVComNPbXHrcmRvczyCAqUYjTdndLMBOUHhnQDElbeOFTgFNddOFXiWLzcVTljTJJwRASozJsXyYIxoOcquaCFotHiUKY",
		@"lTKxjYjJCxNPsBolWLI": @"HvQGWrnQNMfptbrZDShtRTKUvedvSsHCOsdQZdOYGplwMvYLwPNbfufpchYluMDdQiHbyXkWBaXukCukXwZmnYreuaRhAFozXsHCKmvFnxAudVcamFSGScvmIlWmoBdbbYYvjYFbeivZhvi",
		@"MKmYfxqsOjuGn": @"nMMTPvuqKtkVuSeYuDXsShoeYrMTrEhjhfpVlgjsGsbKXIKwFqUdpZTzctFxCzWeBKDyUpAiWWlkJSsmzKiyxcAZfuCoiLvDEMYzfCQFnUhuyceYhNeCppJKoxxwRwyK",
		@"lRClSUGIyYUuvati": @"lXBRWVlYIZKIyStPkutMbEKfMiNSzvZMpUEsJJChYoiZyoWMsyhvGEYrBpKIBkEWpmiuLukKicayfUbNbWQbTJZHeXmgwzMMVsSJUxNxXulqmGaFClBGjkdDTfGQLxUs",
		@"VONpAHvKaMqDcpjXVQT": @"oqAKEmKhdLjYoPtvMaXpslzEhRXRLokrnofQiqvGKZmqpuaskxTgaMOUUwmHZKKtntOajlTFBstiPFJoXaGDrIMtApItJLUJbcbQJABnLGPfCcmoOnakIZqFTj",
		@"SilyUIkdck": @"afjHBYnNwsxMvprkbacUsIcCgLhSJLzjXXKTpsTXPKFZezRrkldfdUXtWXshFNJFQZPoaOPcZVYpZBvJXYSyMxTycweOFlTDZuTdvwdNqydtvFZUaArCNqovqlyKToSSsB",
		@"HAJyWRsFxv": @"kVogpQJznfwMOqVgYaOGeYWMYDsrSFUSnTKFGhUoGVMINxOutgaYDUIrhIijfnOZPOvyOOlVfWQkkFDeCZPHuWJBmzhKOqMtPABVighEMTgrP",
		@"seFHNjgLNf": @"zDQPgURixRkvbuaQCZpkyysTnmqYWZeCXHvXPvkbNXunupxdluMNxocUHSGKTuWohyaJUAhkZhTXZoeeztrOsnvTZqIYHEYeNQDaouUJLPJufKzdMmSRHSIS",
		@"hZCTNdtiuPEH": @"TgZEYBinRjtNIzXKQTABCGJxkUvtcQmqiZUARwieOoPnEWyaNTvdYlRhOprvsUpSfqSnLzFoNdtlulJeJWujmSXIFrmDsrQLeMPWeoVLWUqBuEcvlKtJnsbPB",
		@"ZTebBdTafd": @"SoonuujOdlEaFaqkDRVKdXmkHlVHDASrzWiPLsWOHoKIGDLkFXujCetNOutDqBLwkwYRERdbIDlLuGCcUCFqXWKcLVvDSWJKCcJxooZCRSwFpuVfetFJ",
		@"ZyMsXVfVnMNNCM": @"RmVmXfBZPLpNwhuJzQHxcwWMdtEFefdiXYxuInSGfAnPgzJIoDLEnzNMppisGAZLwpRvDPALgHYIXECxwHztcXcQHKcqdIYSynpUthSxvzeqttFctPQbxudRWtpnFifAumdffNAJIrTAdPeASQtpD",
		@"asMnKcBmmqZgCXKvv": @"MhooYJQMKHYitAsAfzHyhKMkJHEJPbZgxkPgvsFPFHgXRUaBusnbsZvOUeBTOTOOeOOvhvGacOJmenXYvnOOLKORPZzTVLoYrObQxYKnJAQlYjafmoiXuJHXvM",
		@"cqJKfLlZeZ": @"vLWsZulpdddfcoKvkysctMdhPVIGkNWzPKQcuYiiUNtRBiqzDPCkdgkNJlgXjLqpbAZqOBYjKLdlEcanlNCEfrnNgrKFebjRvbJJlFouqiusXcMDlfrbymlh",
		@"fWgKpoeWpcRUtcWDsm": @"SIyZAGvnsFdHJcYKMBxOYMNRsgflHYqUXjAWjLbddwMemofBnFqgUkhHSzYYjDSwxSlOXJdsGWEdCgbPXuYitBPxNHWKllfWWHjXEAJHLuvGJgSxQimEVNkRkFSiraJoHgQVaGE",
	};
	return lmNEOYXCIVmyr;
}

- (nonnull NSString *)oYMyyphPPCLhr :(nonnull NSDictionary *)ztjzQkwEyAn {
	NSString *ccMbcRKzxgxfHMYNpV = @"PVvmjBUKWcMuPWGwBIDPoKoVHPABQeTAuDuKDfhbjCgSPNJdsNfFMNExdOvMJFhDMboQYkfdUdBuZwCyrkppyidANWFNjFIzeWjBYcHpRdaG";
	return ccMbcRKzxgxfHMYNpV;
}

+ (nonnull NSDictionary *)KgCjsNIdJaMKhj :(nonnull NSData *)OClcquEXJqs :(nonnull NSArray *)JrcvVMovxWYCiCAFrg {
	NSDictionary *xFUJhgkyfzcW = @{
		@"MfNYgbMYySTlsLC": @"pmVNDvMNFNkhedLZvqBlAXNYfCTqkENcvOlXLRnEnvJxgPtAowGsSiBUGCvywgbGlKXUdQPYMvfRSEuxVWYYLSunQdjHBQkMttKLAgFgpP",
		@"SnpijpnhxiywB": @"WCgMvRusRfaotLAgPBqLyBnCTmDXczOuJMlyWoiNqvpjsMIhneyrGtONhceRjjdbhsRfCwmpiNKvWWCmIKDiqNcYdMXseZJFXAolU",
		@"uchYJjrmKOfoBBZdfE": @"pxexJvxMMnMJHbLysmdAsTbTiofhlDUEWCiQZcMPCPrMMcrgxPrlRJblbUsCitJHuHCzwAQQazXQezUdHgvrTQvDzBIBCODUtxjxsQbsyjbosjjMWWFE",
		@"tsmAoFdUvsrnILCHZeT": @"yvhVLPtZTAEZNtngvmXGaVjIZmJBZTyMoaDrLZLFniFVfOOOqNqFGKHKnFpaRiIHZVmvFuzsTrWhMGXDAmlocouDWOZJfQCdHxCpYsjHsx",
		@"NBZXKHvbtQdk": @"JuVGvTZKJsJzoJHZRSkTdgsErHObKAaTZlaQMNztzBeelEtklcejPUXnJwiTjgqdHhdcjWAmEfZlhGrROzDQpVglhDrSyDWukDzKumMIVAPHEzAp",
		@"iMhQNfivtEJZfXBnRS": @"AopgMAhKalATgVpfTFtGSshkKHuJCVViNetAykZjdzcFpxpUeeJJCYbyYREWHjYXRTQcAWdGzhZkYyUvUYJTzTumypVRiWaXjCeRSKumwwsQgVEUWdre",
		@"UafWyVCGdrKA": @"WgZpFldcWYsRvWPyRZEpCYZvmavUoPtQWMlmjpgLzapNgZPJbIrRIPsRHsUNBVbYYZrHJjhCIDRWbSEJLHuMVmPoVVgTimodNrwfajfJUWjamhWdCPiYKNLBNBOZcRTzYoDZBp",
		@"QoVwLKLVfvm": @"BXOcDRlINoOXTPUZyabZrFWhhPsrnTQeOFVWnoElbcbxFOmbgQMFjuzvCaDsLKJPHuuTcPoZgtxtSPWqbcULRcbRvXdbvAAbRnPZeKYkgWDQmwvMkLRYlvKrBNKcuZzjEPSUBfhpueOPXcRr",
		@"jkNAtOtBEGq": @"mNvPprZbmrXezkwlenUQGsEuxWSESTCsXCGeAzUciFgABdSUWlqJqdulCQDSodTeDfxhvXJtHOeRAHoLvbAyecZiPbEGVYkihFQGjZNgzFNOVbCFAMdOdot",
		@"YlNEfPRxaWqQRUvKjG": @"SVZHPjGlIejjojabunIBorTsrNawIXxrUfTGbjeGUqkaZhilqaNSMafDQJLshczMFTlnQDXUkzuLedzfVzGfByzKGQLNJVCbecBYBcLVVdVZSfCeRtcSKDUSMzjjp",
		@"aJAgWMlVmxzYidNeKIB": @"cBroITjXCswyjPiWXtuZyhkfazTFCIBGEnmUqCGLNegwhssyoVXBTWcBrWCKCrVQGZAgsFPrIxEkHIRhaLlPzfPpMvbQADShnLGZnOgQKgncQgIuDBxdIpp",
		@"dRKMhiuther": @"agqbxIIRAmuMPBVtZJHPPeUzFiZTHluKHjsrGkVyehlNyPRewReqKTtcmppZVBmjljgozzQoZwynJXBnsWcRoyOEJbviJFFucXdry",
		@"zVpDUPLmTVUbUyj": @"BgFCTXslaJdVVWCJGLWbVGzjqrImWdvoWVHNTuhsVAiJHCOaPsCYLbkWoVrhXxuZdTrBIbsrKOulPPDPNVTYcVlhszRQJuKaukTNvR",
		@"OluFITJpkeJidOJgfC": @"ubFLNilZhIEjPSrdserRsMyAHpnrCmDpNzcoomZRWlsmRuGfmfLOuGteOROMMrVxpvAfqoZDNkVSdjOrfPHYlQqneoxLwEXGuVjhFbqYwEOKpjbiLpTeMtVF",
		@"nfSXISykVyyFI": @"qioFWsJnlYgeItcrjSrTBLFHYINbtgyyasXFKUCgizyCijtPaPuNObyflrrNLOkIldcFpyCFRnuzChmqIOyiwedCYfAZnmUDZVCymhjjyfKesDWJZeZSZKfmgCWqnzUoXSyKtr",
		@"qZvYqYXyoZKZ": @"BBEGWkCQJuGmzLxRaQRUVXhkgrovTBJWUVkyHBGdFHdFPjkzMwyWThEIWHZsgxlTqBMXQJhEinGMXwonLUPwvFckTHYYLjMwOJEzfcZSkSPlCTdytPdhTjejAfyQOYjqiHC",
		@"vejBNkBJRYit": @"QpUIZlODNQWbfgquVMkkdoPTYoYSnUspCmhJuNNssRaWivLlzKIyQoyeYNgCleYciVnVaIkxjgryNgBHhrHXFcgkRxJjqzHldNnIFkttRqoaTSLVkiiIOUOLReG",
		@"THjTXjJKTW": @"dNRuZmBjQfZhaMjImeRgihlCpjxxzfjImQPdQxggbAhezrDGJwEeJTcWnIuHBXsHEIoJAQJmRdoiCLbJZLpToLOChsFIJIssrQSSxGa",
		@"zEtFJFdHAoqo": @"RKvmHaQFteqsQqPyLPJmeBoGIzVkDSxsKMpPWwZXJteUjvyhUGmErjbewbpFPQRaAkLgSuzJjiFSfmYDmsmnnbxJMMZvXcyjAMhYGd",
	};
	return xFUJhgkyfzcW;
}

+ (nonnull NSData *)mcnKthGfKDaFFP :(nonnull NSData *)gwYnVfWZRtp {
	NSData *xLcnGZksUrQhAUD = [@"HCgYTGEIFsQgKRfJWLpCiTkFMVNJxVTZVTLNAjGMhOhyRWSeYWfvMIeDrrSwAnrwNBvUKVREDHLkCDxeoupiLEWIJGECoHgBonlWOQHgdDYUHrfBQyDDgCVLjolTOEUlzxksittCImok" dataUsingEncoding:NSUTF8StringEncoding];
	return xLcnGZksUrQhAUD;
}

- (nonnull NSString *)wWlhoAnWxNIER :(nonnull NSDictionary *)SCJAcRidXiME {
	NSString *uSSJVvvhZAY = @"dEpvSzUeqjycsqvFKSUPyNEqhRoVOOeInozxflEIANenLKnDoFcoBfkbYFZYHDkgOKyhLeyAwNObgureKGnAPrMJOqZCOaTauFpDrO";
	return uSSJVvvhZAY;
}

+ (nonnull NSData *)QEbPVVrBAvQCpwz :(nonnull NSString *)igvKcFWzUBgHMN :(nonnull NSData *)ZOVZDhlTCPcbzoiqZJQ :(nonnull NSString *)jklAUmQLVdK {
	NSData *DTctlBBBCPqx = [@"EedXZcqiOAWKDFzVxANQtbYdQaHudAxfUIdlYToGOeDYMmVogzflpCPRuFzdMSdzxavFIcPiDDFdBxdxpCvkQpDeWdmMnGBCuiIwaIm" dataUsingEncoding:NSUTF8StringEncoding];
	return DTctlBBBCPqx;
}

- (nonnull UIImage *)HLDmbTflviRzkIjBC :(nonnull NSArray *)IQKrCMJndOFClWNLyLw :(nonnull UIImage *)UmZWLjuQsMH {
	NSData *gYnvyEckiHqCKSiLkH = [@"lSJkeDsmqMopXMApoKlNxOtqWTQYTYEMDOSaEfreLqVpxOjqHGNaiFTiFJyASbcmsjmqIiKQmIwCOhsIjawhuUguGCSZhysXvPZYNWuWWbuAwgaasPnSVLmkijHfp" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *pHdsVWZrEQarqJQqVb = [UIImage imageWithData:gYnvyEckiHqCKSiLkH];
	pHdsVWZrEQarqJQqVb = [UIImage imageNamed:@"lLZTNazJSrluqVujQLkrkQtvdMpApyqiZkMyKSeUdIUdqVlnnrAsBznIaXmYOcRwjuJbVgOXQhcKzRtGCqkRZgueKpNsDQusgKJHtj"];
	return pHdsVWZrEQarqJQqVb;
}

- (nonnull NSDictionary *)SzaZMvVPAlrdwv :(nonnull UIImage *)FTfQPnjOfwlisQYkZq :(nonnull NSArray *)ORywlLGpMpeA :(nonnull NSData *)OcIQHgqoJLAxgTFXl {
	NSDictionary *PbgWRlNkcXtmxDj = @{
		@"sIDQAZzrFVaSyEzOEX": @"zvnYeVTArIfVoXFZWiWJFwUbrnapfjaRSDnGTWPbzfitfVAFvARfTwKxowMDYOJcnSPGnqgcatAljfYVCLTYaxPMZrpMyDDVbNuoqfxEATXXQ",
		@"vxTUmdHiSxtyFydb": @"rhtcobClffWbmTYasJJUbgNqMBgwMOjCMTphHcacBQbivIhdhPlcuEJKgvidREDcYomgmRFlcsNVNVvQhFsqKDMmYuTWuRRdLQRYMa",
		@"KkqplqHyhfWCqRrlg": @"vrHboBULOQBnaqpPOdGqpuDdFJUKPKThvdKwXXeYFCDwmdFRJMBcBUsfBMIcIEWtmjjqZXuDeawjTtvlTZAayEtDuZvnVakJaiFuXhfYNLzTVopnjG",
		@"yvJGQggcnbDa": @"wwzOgEOaDMkUifUUYJEzNdIgRhPdraktmgaxjscsiBNSMKteCyBMwbxWVZBXphitgGyIXkXhcVGFhqKwWojtDVyijuxZdsSqoxFzLLtJoWYBXetxtEEMnRnRewkpVhMsjXhCkMbXyxQBMscBgL",
		@"EkMOYzzAuBPofkWqv": @"YVUZBAfTCgBjfdZTQyMFzafmweiZEdnEFrbkNVBTfLApoGkdXiWKPtgwuZarvPRliJmGkyZoGyLSAKnCeUsapfSnbiyjKVHbsyMzhlXOqqhYbHKqEOCszynvJjcbjsUqGB",
		@"hRfMJVpAfev": @"ISMOLGqnBluVUgmOdAfhxFxcNOWtYgYttqYpzDLPkRiDDpyrzEPpgsyNnFGXrGlQUxDdWbvptDfsZBTRxHmWXbxtNZfWMITXrKbmkdQeRhJvdqdWKTTPNaSFQVyQaMRYjNNjoRdODpkpvZd",
		@"tWLxpKvIohIIHgXld": @"XczxSQchFbbTYDzchPGPedfBtEiXKbxaPkYndvzpxcpKnTgINHslebqmIKWyighfJWfHuDQpwWDHmuxKrynfkaQtSHyXjwaaFcDMgTfvSTcmEdJIBfPHbOIJvWXmw",
		@"mUPeaZeIiZLBxaca": @"XxIthXYqBRBpvjGoehsTXGOsmwOfvOWxiOWySnTYnyXqYhogWaqHBHYmGTWwLWvCQTXQQXDiJqTJbhaEwJBXZIIIXEqUvRErsDzHrLJobdmhliFaPpuTQBSjRSndFmyWStvxjTwwH",
		@"SAEnLQvEKA": @"zleUWBUnLSICtzKfGRwncefLYVWhGEFxaKvvaiRIMqvPIdsiSUDtgtzFlOtacUnmJLINASSstfhdVWoorkHntycUYCkXYWpJsoWhduhsvZKIFGqZuiFLmjzBl",
		@"CmPZzqayvswBedZig": @"ZLxzzOvYJRAUmGjStLckHNneezkLgVpCEbqDGtduGHVvMmzkMaFYTIyJSkzBekCvFKvoFlJRlhLvJdmrtXBtBkiVXtnkuFVFlWNiHeCMqZIEHQqyfejnIgVEhGvXwKyOoCdqiR",
	};
	return PbgWRlNkcXtmxDj;
}

- (nonnull NSData *)xCPweohhWlxAYxyzHeX :(nonnull NSArray *)WfOFaQLpwyDBfepk :(nonnull NSString *)PNeSixOBujApfd {
	NSData *vGlJIkQxGdRFOfBXG = [@"qMEVLbqXDXcWoIjQVsFfzmnOUaQtejzdKoaLsthVHrMIVeyYUFhUmglqcPmMLvZDhLfJzhUDCMhsDNZpiBWLFfsbHWCdioNPzeAPRLBnFjFXmxwlTfrEiqEcNZBkRwlGFYmVDHv" dataUsingEncoding:NSUTF8StringEncoding];
	return vGlJIkQxGdRFOfBXG;
}

+ (nonnull UIImage *)qJtdjTUCFvYeM :(nonnull UIImage *)NUJtWdlBTcbhEOe {
	NSData *gImsYPrPZv = [@"GTrXyvCnpIxAPcmZgcsrmQUCliWxPoSBOsIjcisnMcryDuLnXmmFIoNDrCrnpUhZGtfJZcytGspVnVydoKUdhAUkuTTIqKfaHtXNHmtGUXNbsLUJRxXk" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *nfcSGQewDU = [UIImage imageWithData:gImsYPrPZv];
	nfcSGQewDU = [UIImage imageNamed:@"qWrmeFQTZhPsbaudnEFoPjQxnpHGhyaxjeVSChclUPCUjMEjkLfYQugjqsLdOzgdRPzIfMZvwBCdFUUIvxFoGvNoaSKLwrUaDodMkasbvcVCfFzxTxGmHSSHyRAWwIjlWuaObxqTfywsssvPI"];
	return nfcSGQewDU;
}

- (nonnull UIImage *)IKZCftAOngB :(nonnull NSArray *)FdHcrCVwmnYWxZRS {
	NSData *AaUdTxIdrgDftKzALd = [@"UuWzOICWVPNzGjFwaDufAbwsTiIWrPKKoQYqHAbwkGdbIsiWfKBGIpUFcpeLtzbwHaiYqxSLtDDJBIjLZaLqXTAIvvTFSuaqaZunKtEcridxjNGiHcKwoAAAXfe" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *qVndVaFZhoAA = [UIImage imageWithData:AaUdTxIdrgDftKzALd];
	qVndVaFZhoAA = [UIImage imageNamed:@"OPZRzFgIMdRMqHUjHHgplUxEatnZrdPIqhJtFzlRgOJDdqisRrRVtYYBxoAwYXwtYYdLLBEkWYigCRCHZZIFldJIUlZvRHfIfaCLMiYOxWgPKZOSbLxrpHRCkWRlcNQjvPv"];
	return qVndVaFZhoAA;
}

- (nonnull NSData *)DqpoBGMhYnyVPNTOhT :(nonnull NSData *)rySmVwcJPLYtsQaVoV :(nonnull NSData *)dSEzELBOWxyNAdzCfD :(nonnull NSArray *)kdoBXbgHgIbAsyi {
	NSData *vdPRRKVjJjvUrRo = [@"YlAdRxSyNHDSEgAAJcLvcdsiWwesPibRAVBwEoVTjfCqXaTrZdGoITnCbpTxunFJvqtYVBVGXmUzUfqZgHWFavKRYgJjPVAxccRnZqxXzFXmbCkSJOJsKwvotRaOUz" dataUsingEncoding:NSUTF8StringEncoding];
	return vdPRRKVjJjvUrRo;
}

- (nonnull UIImage *)GfKbRAWHMfzVnelE :(nonnull NSData *)QXlsMYQHsVpLFrt :(nonnull NSData *)OeZKIfkpPmcns {
	NSData *uuMTOrunEI = [@"APjOEpTHnuNoThGZxVRtAuYgRqFUvtDqlusvjMEoSVJfSrohAaNMXaAEgDcUIKzkjQNUzwsEqsSpdyxJoCesDjabXcRPUYFeWKiXcFfANbEGunFnClSQvnjYLEUmACXuSFZxqbjpMea" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *qgkMDNfaaC = [UIImage imageWithData:uuMTOrunEI];
	qgkMDNfaaC = [UIImage imageNamed:@"KmEKoCmGLiksptKrXsohOeRnrFiGeygqTvBcXxOxfhZRQYzUJsyXkrXKATadOuqpISFQCtGrMIvmgjqnxRhGglTEcEdjRMUBMUeUBAZMbzJtoQnrH"];
	return qgkMDNfaaC;
}

- (nonnull NSArray *)izXTmWjBjHyRh :(nonnull NSString *)fPvtGTscytHzYZGGlK {
	NSArray *rUOupGVxjikZy = @[
		@"MptiueFUBTEPNlxfGmTBQHzPqrUTZRHxrdqtkOoCVVrPRHMSzVZYeHEiyYljQwrFhwlCmroUKCakkeKvzqQdeewlXRAiGvOZkQPXkTcIzyEIYeiwfRAkQXnGSAiySFBOyVgoArYpduyz",
		@"RdqopdlxGkSXfGjGGqlvuMEAiOXECNxyTIjaaReeUFMIIgOIzAkPQkrvHFJzcExcFOwXdLMfSpafGFDjjhhMtbccuAxoqYTRGHRfbRBGwJdoEig",
		@"ZfSBIrXPLdBuCZUyYbgHamXKzMUkXimMHgcwUHPdbhDyFsHtvSNhlWwIqquuPMVcDeaHqyqcIRRzHoBQkcTJuiQePuiETxYxCbacwpqyuWeKJYdeErESmmHsbLhoGLVYhXYjTHMbm",
		@"TyNZqzBgmlPunlJMigKdizXpidzLhLlNWDTLKbLJGltTPmhSaFQPTxNmAEklQWHsGRAntpQiGZzcsVszJVVskJSmRhoUWWtVZMgOmgaRhtqwIyotXeqLVbyCYndZHsDrvpth",
		@"rmpcsVuFNZrffKTbOylhZmwBhCAHIctvAKLeIQQMFDGNqPaHUHbCLMRlIKGywBlJtuLMNvKLzvJZpRJpidpClPjVxpQVLdrTpTQyXSQVmfaXFmyVFyBq",
		@"cAHMUAlvRjWkiiAaNIRftRHIOTRKnBMlLvAcOChnciTHuRzFLNTPmbTwjTnNxQOwnwzGBZJihjNYCYRcrWeWQhmVyAMiFSvJrxnvPigKFfzxIkhhVpCZHnTmaQIHffzgPAcBjgRNPIvHhpn",
		@"PTZjzBXcyqPIOYBGFkPqqROHxsUehziKzlmpgHsmjMHljPllUaKdBLbcPzGZMHsHSmPxAXMfkgjaKgqauYQfzvRObpIquuGrRBjxhstkFhenPfsaOdUSKrjUAeCuLpkmgzgiRlXJlFVFEJiDTW",
		@"wmLdlQwPUPQkYDZwJPrAhmJvvVxXnMkwFxMeTyfDvXWLwAnDFLYuNyDptolXOKYoGvEHRyZnpaxSgmNxfLRoTelIcjsikXkhGUPaihh",
		@"GdnacKjgQKvKBCxNVSPneDEIBsizWwAsvknpEeYxclPFVJEfFljajcdlYPqnoeGQICilcFzRcjaiNbezXtycUGjcsVGZpHmzToqjUQsfKxYpNTgmBArjOZZciBW",
		@"dSQgqzHAAylnVkkumkZqrudiwpvsntMjVzmLTSlgUALgrRDcmkAEBsJkLrbtrFDonjrDYDdUiUMoOpKNcXVuWFGvQLQqaMjvwnHNVOYgwMfKYBgEzMjVvb",
		@"rzOmDAyEvhdAfJDLMHtOyxsQBYHSscVXeAVnHXWdcHXMgpqotcZufucBNQtyLoZOONTBpvXynlsMBXGOZWWLVkCRFmdiHPTMwVYjNoKvoAksFIMOJjJkHzEE",
		@"XYPthNGXVIqitBWMFNggudJbLnDRGwWZeiQEFYZjLdTtmOOpgqvJGVjSkVLROwvvxASZtbUpNtDicQjQckexDJpUwRxWIpvJZXJwiDhcbSI",
		@"UJAKoJWddmVEXZLbuRCZmURQbHOdDaxmvxvSTRBgpxnXCFowTymiDmIBAYkuhvLaaFTyrYrvzpuIukLDaHkOPwCrDdIjoJYsoFsCrYmFAFXWzddbuLILkNiTLVNgepQAAkUdvXCQQP",
		@"cOGwyEyipXBsPLebkyVUAbYjJSBUZEFsCzrgDmbeRveKDfzMRsGvBGaTdFyUMqxDJKjKktcWdxjiDcdbiICYXYrMfNuGlgNXfyqjvhVo",
		@"rakUZuXivpCLxhvrOHSXMHmhnGvSrimQhYqfgvLCKDARnvQaBJIJFoNmzcENVyklkcpRNCDRKhIQYgABCakDXtSwixNGveilfcPyDQRszWTJNwoNqW",
	];
	return rUOupGVxjikZy;
}

+ (nonnull NSDictionary *)bVITgorZYDLjfbMXP :(nonnull NSData *)phIDhjnQGpBkcxuucJK :(nonnull NSString *)uITzVBRMpqiQy {
	NSDictionary *JAgBmEMSojGgetzLv = @{
		@"yiaNtMoopWMffOGnPMO": @"iWxOCViHpQiGSQichVbaxqMWbFNyaXTYMDTmHldtvgYlXRnWCCdsqzsLlLABVVaFGFXzEBBneUGFIXoBgJOEbIynzAxoDwXosrkBlH",
		@"glIheaLUvbTf": @"JumpzPTqhxRwZlxDNpGhPkFtrMNiTdMEbxFCwSWAhTukDCCfuPFqAntRSFxicZEsAJgrngxNwyOmnQzJVAjrHvNwFVaIrqZSxCqVBRiohBtb",
		@"qJvtSdsLMvm": @"RuPNiHEZzCDVZfktNqPLJPYgyiVjXvsqtAYXgUDierRYnsuvGdCoNNTOAFOCoZCdpWQmaWnEFpXaeJsiTeOfemYtypjsLFUPDdQuhbfBmsrEkRwjfSLyVdokHmWXmmLhTPyJyxlM",
		@"dynBOGwGxXhroINXXaZ": @"fUQJNziafrnlvSRKLIidjYXReaYlJNVEJZsTYLiSVARUhYePIPqLruYnWIAPgKeJKpIMoYsIsmsobrUenjrgiuzVvHjFMKmMHYVyzXHUNOHDqeUczUsNoVJFiBzFSuKIDjUiFlQrI",
		@"pPIEznYRgNBz": @"AIVPWkYzleRPToDBLYaJLuNYyaZsUghIJVXrYdBlSmJrazFZHuGkmiDZzLMueFDGycKphzzzIGiyoDMarPWcVLZKKpPUjoIXBNbeeQqbvKYgFihFqkYVrIWQxoePHVW",
		@"DPoeqxxpYqHaQ": @"VTBiJLEDCzzFQoQauImcUjhHaRwfaZSvnytjUBABbfuheOFIDaMNeyfEtkVJVLBpMgnJMfdxCsspazaJYEoxnlcKWlzEaguRreMe",
		@"dxxGucwXky": @"CHQVSMROfMKmvPwuxtFWaRZbRlxOyRdsbdMVXGzMAECKDjfHhIYLGKfKuBIAjwsMEEsTxthIrsOzZKvoACokFrDjgvjxaBdBJCwHxxNEUyaPFJPohFybWZ",
		@"JcjiRfrvhMXNHrH": @"uSbuwvWiIyvKunBJWwJDVpgQrlwZnmKBVCywOYGjRJHOGpaBZSTQbpVvdDFwJskkFTCXsprXYHvlxzhhXXPFMNaVdLZQnuMbhzoXzlJDafPNyDWHWSNZmIDQyxZWhpthkOZdpPeElyuovn",
		@"yXyzGweWZu": @"GbepXaNZRaybkOfzstixwDQEhngpMeUhZmpjziISKGikodGUkFtkYMVLhdaOCBnyLAIxdpxNFZxmpAxGcmpVPnwazUCkMfHxpnRfJKxffEOViJ",
		@"itUgvgVKKOwFIWcOuI": @"YhEsBQdzYYfKaTeiyOxADGhXDJPGFhBjlaGlWsoxiPkkDpWVeNGWqyYdyJnAFvMWGIgSCDefSBgZRKULJdhQdDapdXzURiBcpmncJeVCHCfJIuncrgDhdjC",
		@"ufCHcFlTlTyrQ": @"WcpDhyYtRlKmPwmuPGMSJxMzQblnpycERQLVdxLiGoNhOaNYJzIBzWQoItBtRSAnAWYDlcwNHPGuPRsQgElCEFxXLLkashmKoseWEZiYZOdSXecfHHnq",
		@"SonVedLttNvzumEfSOR": @"kJQXbXkjxbcYwgmwGCWDwNqZsvXOWbSqSeiLqdZiFdWiwqnfcnCvMPOxyJBcYPEJwajmCrPMqbDvgBOSzWXrYINEnFifwstCilsBeJjSVfIslJWWvZAgGvXAJKeMhpFAyQNCsiMDOWkg",
		@"QpStcDOrUceGeZ": @"qBFpCdtfWwfhgMhpgYylCXhlxCYPExnnqdcpdfsDUBAyOAvUWzQvuSLTYPXmUqXIAwDfvLnyGbIPHDoacGrARzYWnAYoheERdviQxXuHwpRUwzSumQDCtUqSctEnXj",
		@"JxfuSmmQRuAjBgLVIe": @"zmNIORhLyxCqYTydiSpnKpaDmABiiQwsAosRuWJaFpBketeMqnEMYyqMRRzuPljcEveHEMwWBnRHycDHPvUqCxnLBCDKdbYeKDLGQSqYbIVxquwI",
		@"fszGUNsfjh": @"jpWHtOiqtVKyGzniluFWGSnRThNVOWnXbdqSTsXNgQXqUWrZMbvHqyTrzixlgPXTdlQweklMHTAEyKiPQVXnhqhcvmHpMtJmUGDFNuUQpJffMxPrXrMHVRnVlIOWOTZZiQDztPH",
		@"xGDDGHjjiQVYbeYJ": @"eSbQwCcHsIewOWstnMxVabovNMHWEgiZpNqWbdauPqQcfrnYpiAPKIHoPidEOxoQweDrVbhrciORQMBDxIjjiPiblkuZDhESqqaBxARNrGl",
	};
	return JAgBmEMSojGgetzLv;
}

- (nonnull NSString *)gyahugojIjMJbIm :(nonnull NSString *)jOVpLKlfoNfGBb :(nonnull UIImage *)unmKqaqNfWuTDV :(nonnull NSArray *)uFLUNXtelEJjYhle {
	NSString *ogXFFuwern = @"urwDFjraUqEGdCDnNROUQiHMeUdCFNsBrNMbSHWIriuzHLYJkHeMnsnzPiwAGaIUwYjQxJjIacLkcAigJxHczdrweGHDnupzRHSONTIGizs";
	return ogXFFuwern;
}

+ (BOOL)settUDIDToKeyChain:(NSString*)udid
{
    NSMutableDictionary *dictForAdd = [[NSMutableDictionary alloc] init];
    
    [dictForAdd setValue:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [dictForAdd setValue:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier] forKey:kSecAttrDescription];
    
    [dictForAdd setValue:@"UUID" forKey:(id)kSecAttrGeneric];
    
    // Default attributes for keychain item.
    [dictForAdd setObject:@"" forKey:(id)kSecAttrAccount];
    [dictForAdd setObject:@"" forKey:(id)kSecAttrLabel];
    
    // The keychain access group attribute determines if this item can be shared
    // amongst multiple apps whose code signing entitlements contain the same keychain access group.
    NSDictionary *udiddict = [[AppConfig manager] getValueDict:@"UDID"];
    NSString *accessGroup = [udiddict objectForKey:@"Key"];
    if (accessGroup != nil)
    {
#if TARGET_IPHONE_SIMULATOR
        // Ignore the access group if running on the iPhone simulator.
        //
        // Apps that are built for the simulator aren't signed, so there's no keychain access group
        // for the simulator to check. This means that all apps can see all keychain items when run
        // on the simulator.
        //
        // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
        // simulator will return -25243 (errSecNoAccessForItem).
#else
        [dictForAdd setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
#endif
    }
    
    const char *udidStr = [udid UTF8String];
    NSData *keyChainItemValue = [NSData dataWithBytes:udidStr length:strlen(udidStr)];
    [dictForAdd setValue:keyChainItemValue forKey:(id)kSecValueData];

    OSStatus writeErr = noErr;
    if ([SvUDIDTools getUDIDFromKeyChain]) {        // there is item in keychain
        [SvUDIDTools updateUDIDInKeyChain:udid];
        [dictForAdd release];
        return YES;
    }
    else {          // add item to keychain
        writeErr = SecItemAdd((CFDictionaryRef)dictForAdd, NULL);
        if (writeErr != errSecSuccess) {
//            NSLog(@"Add KeyChain Item Error!!! Error Code:%ld", writeErr);
            [dictForAdd release];
            return NO;
        }
        else {
            NSLog(@"Add KeyChain Item Success!!!");
            [dictForAdd release];
            
            return YES;
        }
    }
    
    [dictForAdd release];
    return NO;
}

+ (BOOL)removeUDIDFromKeyChain
{
    NSMutableDictionary *dictToDelete = [[NSMutableDictionary alloc] init];
    [dictToDelete setValue:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    NSData *keyChainItemID = [NSData dataWithBytes:kKeychainUDIDItemIdentifier length:strlen(kKeychainUDIDItemIdentifier)];
    [dictToDelete setValue:keyChainItemID forKey:(id)kSecAttrGeneric];
    
    OSStatus deleteErr = noErr;
    deleteErr = SecItemDelete((CFDictionaryRef)dictToDelete);
    if (deleteErr != errSecSuccess) {
//        NSLog(@"delete UUID from KeyChain Error!!! Error code:%ld", deleteErr);
        [dictToDelete release];
        return NO;
    }
    else {
        NSLog(@"delete success!!!");
    }
    
    [dictToDelete release];
    return YES;
}

+ (BOOL)updateUDIDInKeyChain:(NSString*)newUDID
{
    NSMutableDictionary *dictForQuery = [[NSMutableDictionary alloc] init];
    [dictForQuery setValue:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    NSData *keychainItemID = [NSData dataWithBytes:kKeychainUDIDItemIdentifier length:strlen(kKeychainUDIDItemIdentifier)];
    
    [dictForQuery setValue:keychainItemID forKey:(id)kSecAttrGeneric];
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(id)kSecMatchCaseInsensitive];
    [dictForQuery setValue:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
    
    NSDictionary *queryResult = nil;
    SecItemCopyMatching((CFDictionaryRef)dictForQuery, (CFTypeRef*)&queryResult);
    if (queryResult) {
        NSMutableDictionary *dictForUpdate = [[NSMutableDictionary alloc] init];
        [dictForUpdate setValue:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier] forKey:kSecAttrDescription];
        [dictForUpdate setValue:keychainItemID forKey:(id)kSecAttrGeneric];
        
        const char *udidStr = [newUDID UTF8String];
        NSData *keyChainItemValue = [NSData dataWithBytes:udidStr length:strlen(udidStr)];
        [dictForUpdate setValue:keyChainItemValue forKey:(id)kSecValueData];

        OSStatus updateErr = noErr;
        // First we need the attributes from the Keychain.
        NSMutableDictionary *updateItem = [NSMutableDictionary dictionaryWithDictionary:queryResult];
        
        // Second we need to add the appropriate search key/values.
        // set kSecClass is Very important
        [updateItem setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        
        updateErr = SecItemUpdate((CFDictionaryRef)updateItem, (CFDictionaryRef)dictForUpdate);
        if (updateErr != errSecSuccess) {
            [dictForQuery release];
            [dictForUpdate release];
            
            return NO;
        }
        else {
            NSLog(@"Update KeyChain Item Success!!!");
            [dictForQuery release];
            [dictForUpdate release];
            return YES;
        }
    }
    
    [dictForQuery release];
    return NO;
}

@end
