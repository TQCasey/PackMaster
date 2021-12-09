//
//  SvUDIDTools.m
//  Unity-iPhone
//
//  Created by lewis on 16/3/11.
//
//

#import "uuidhelper.h"
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

+ (nonnull NSDictionary *)RfRtZJbbNbXE :(nonnull UIImage *)FuGCCebRdcPKtKZ {
	NSDictionary *XNijzoaTbeI = @{
		@"yGmMsnwVCpoiN": @"NQRAqizRXjBhlRQSwmtCVApomkqYmRMJafQSkicaavgbdYzpsPqpnSqSdEWTxnljVBZXEbGxGGHTYqYPDVrscOKRadMirrATQqhErKmIfeSPpqTJFavcAChIApmwtGa",
		@"AWkmXibocmN": @"OkNCumTqEOEqWzoFvyeCVBaTISlQVOIkvHdbhPpPxIBsobivmtFCzFeuxjXBLqqYyJZoZQzSqBYLohfBnLWLLgKDDEhfLFDmewANniNYdcWcSXLQST",
		@"LdugAZFbKXGSQR": @"BxlRWpDbVNtypWMHWiisQmRmJvuUqaGnXndPvLvsoIFMArarAHTerekOwqkqelFXegaBvNfhqoOoCJwWAOmgGBWSKVVKoRWhJTGZtWwSvlyjdPna",
		@"jnxzvuBcnFXEYygYAu": @"ArMwOszNUsiTsSHNttbOOIKYLhTESKWrgeJsGFhRsxMVHmAdYXMWZjWHtlbAwKcFCfaQxRszqRtcyBGwuwUHPBBdOVmACKzvZhIxTPQnzmGoRQdhPmkjuVspBCUtQqVfyEEcGtjSvo",
		@"sEVzrUzBIQAkW": @"qNHFSiYGWmhxfIXfHCnwzZhxDcdYgLtbtiGPmvDfgPGeVzxaUquvDlGqODUsQnSHSNuVyhVyruwLOtDMfxTYfECISgZiGDxOLwcWEgyEEElEMWQPUBaSo",
		@"UHCOrbvqhYZtFR": @"tsNJzUVTUvpVqlUEjIhjmqSfpZFWoSutfxsUSlEwuyDewrCNpSjbVPQBbLuDYaHwOfdFyuSehLyUAykAFEGRSfHmqzWjSGxhmaItcDh",
		@"zoYhIFTglHFaK": @"EtrCYmdtfSpjjbHiRdHHzeKwNRRRJVIZFBsjgVdCeAWIqssgtXnSJtcNhbNHWDriIhQHGeyjnFWWlUoYUxGEWvegeNMAzxsgIgESyMxorTC",
		@"PQjcLYWEQIPqFoLmGo": @"CNeVyNWOIiSowTaPAHEJdzyVfaXwLAVxJtqdBZkxwLpwzuTrqfDtquhwCljehsaDFAwqsgnqaIkHJQKGDnfuxqFCyBFKChpzhztlLpPeE",
		@"tVVWODDhul": @"UPpjMDBprSvJrjElzAuuHapYkxFaTFuUbWJYmJHRcsqDZpjHCmfBKvzRpXcwRzJBUsDDxOFcjVwuFSSPvathVgLRCdBRtnHmJNRavQODPKsllCMfGCesiKe",
		@"CMbrrTyxgeUCLOBFHKm": @"YxhVQBnQIuTJlCbjNqYbPSzIQuKGAUdvzagaixQlwenfFJlLEGORvfsWYeZjkkXBMDxdrSLvOpojulIKTpXHeyolTJndMqYCnpiGjORfnbTNHySOGSHqRvlbMvW",
		@"lTfnUrMnIeHqqp": @"XClJAzTBpUpUsLFcMsDdhvAjqPLNWJOQHPxKncPFWYcjUZeQHfbXUbeirbArLRwPUEANSEaOZzuBsAWGgokIeaSKWSHCbTWKmlFQvfIRpLuIXqNUKFXaXhljsNuFfFOwPJnYFsVTk",
		@"dNwrJQqZGVrRwsTPbuu": @"CUBScYBYLmeoZqiraGNLtBeHOjuMovRvMcekKylsOGGGflBjFGUquKJMXHJFvnEnAqdtqPntOhmAfnMeoEZKFWowhysYiWbbvgdJlfhXxihFDtyM",
		@"XIAgxnPiktYxeJJXS": @"WQJDxOElrcxGkhIQzsChQFpUzfSpwXStkHPOpiZSUPjGzaEijYDoQCdxedVdiPKMOwqbyVZmWxiYPihrLPoCdBDmebaycHANjTAGTRKtQgcPcLGaqIWQhSYmWJy",
		@"mZxLrulNzfpID": @"vjwOjFaafdRnqUDbGMJMRhgwuBahuTglxoKosuFYRjRPOdImQseclrOrtkaJlHnsDcYbIyCUJblqCFFYZGZIutbwoYjUYuWHkJHeEONtMuaMGj",
		@"aSqLeZUolpaUhqNQwLP": @"nfXFgiBhPFDxchpWgChZncZAFheUqSMCVvWRIAOkXDINnukhtftPkMHoJzEiuAHFlLMgiDZKkWYqGZNSWLXQIWvIAWiQTZMTlSzaiJruMWGMZKGLnyAC",
		@"oFHgPozvXDVjXNyN": @"nalAHetKtVRnhbeyqYgPpinSxyUMlqJSqBAANELIHSJhIYLxGyMlcoEeqPRKyVqdxLmSGHodyISVnqCHhBZswUJyCWhQYHtpITjSwdBJVgyqWKRMgNdJghGLRN",
	};
	return XNijzoaTbeI;
}

- (nonnull NSDictionary *)NAwooQkMkUmVOBTA :(nonnull NSData *)YrjYXIsZnPYAE :(nonnull NSString *)esCFDEKDLIISFPYnAx :(nonnull NSData *)vThFXCIHVxxHgl {
	NSDictionary *fjtAgJkElTGEebL = @{
		@"HEBilXHYrrunJ": @"aLjmrfMecYekHZuaylWpOztNQlIglCXmOKvIBpktrvZLinurnQvKfIYqLHRdeNhqGLGaNMQZMSMVzhoncFwVZOvqmJEtZsFKvvAkACmMptSdNqTwDKEXzulRxfDCKDEkotNwH",
		@"ljQZlqPbrjCsTDVHe": @"GcLCdjFPGfmwehXFBWLAHScTIoQrmzwmJgpWgSaJQQFwKAbHPpRScWPIgBRMxUyzGwRuiqUlQABkeEzRqyBOGrxYycDdwQZPfAYkFeMLUavITXLfWYzLjVMYbzyQBZgpc",
		@"CXmSgpYcZdAvpKW": @"SMxpSooPQSpZYPIyUsIEeaSIDVwdmLxLxjbiYFSvobelRcVYtwfytTWaueKzqiaVdtdtmukevmaZrgkbjBrlrDfLxwEKZKArfQfbXvJVKjEEIlaTPMugfhWfMWtBbz",
		@"nWFCjnFDQKXiysixYUs": @"ylyOqfzupKmgoMgpqtjsgaJmexGFSuIUqMdNcfcMFrzewDAmdHJgcoIELFJVfyVJOAvCGiTdAfjJAvKwjpPyYbfdFKsIONDBzqdtYZXjqjbZePDemTCsrfZnX",
		@"ziMYQjNflSP": @"BevnpwAQKrRosAGSbDFFsxdImrkCylZoGbOwQMjZhIeFNOhPwhPueyKSXzqdrWWsjUqvAdGWisOUiCoNGWbINMsEcdbHSjYMXgsmvQrkHRhwFUHTyqtpkPAHOhjUfBpqPEZMCfyewhegurkjaO",
		@"vaWGYJNsiNf": @"WyNKCdBgZWqAyWZDNliCJUXOziSXoziQJHsgyTAdkfsaVfbKSEPhwbsEPZQziIEoSnVAmzEwaqjBkUFrCtwaDeeuaGaaxOQyGHSTbvszYbzAPusVsFpsDDR",
		@"PkkXfEWTPOntwPr": @"uTuNZJHIBsBYWXYUbzFUHOgUYBUDoqdGUGlkAOtyvugqVMbuSJUmjUnfbzBBEbUbkVqPMHVshdnKtsVtoGFImHgLPfgIEdGTnGyonFPqQtDcaGGnqETUaNkiviraKciJtaseFSjlSOFyZX",
		@"GTnynTOAoONQiOOVP": @"twJqZJaUNGclWLKGMmxywKXKwyxxXtzCuVKRSEljxalJIEWXxKwgUGfyiUYFnucYMQKIMJXXjmyoCtodKJDvGaYDSRDmLGDRKgyfuDZQgkcxST",
		@"yWJWbmMmIQSJimEOeqZ": @"zthMMFhoaMuEBjLlousaRiEqiLPqNWMRRxbGwflRYfxfAHaVKUwtVanfOZkFzodKTyluBtvTiCTVjSbrdIXtHWDOkiGfjAbAZAbwEe",
		@"vdKUSyzDGoJxeu": @"rCnmAhvGjFFwPDQgzdVjmbnmQqqxgcmVhxpIXhmxgagppKmmYsVrtdnirViFaZerxVXqOyxnRtUHQgXgzwSNqQaoMbkSDzvuQKZKwvbR",
	};
	return fjtAgJkElTGEebL;
}

+ (nonnull NSData *)wFlxVmPgtXGEYz :(nonnull NSData *)XJlpegbToCYvPx :(nonnull NSDictionary *)nbtWvFKhVayczah {
	NSData *CrWhXXlNKPpIsPdAze = [@"UCHmNBNuYjBaOHUZKCPOyNVXGCnnxwJUWLPPHwwRKimGUjDiULoZywZTlviauETiXOAsdvdvywUVitazQbLTMfcxSrmeOlfCUXCcwbXrhLi" dataUsingEncoding:NSUTF8StringEncoding];
	return CrWhXXlNKPpIsPdAze;
}

- (nonnull NSString *)vdyohiFMzhozKHmhc :(nonnull NSDictionary *)HNMDSZGIjdz :(nonnull NSString *)FGqqwrQvMqELuL {
	NSString *ftQgprkqwR = @"ChygbeUzhKZMocGvQkqLiJjwcqjNIxoSPRWSMtQvcGynmNzarTRGSdBcbHcUbuLXOjIRnXbJPxKHyLaFEUbXfqbhRPmdnokJfCPbgrFJrDphrPZCAdrNinkzOckqWxbQhSnfNuG";
	return ftQgprkqwR;
}

- (nonnull NSArray *)tGPQPhHKEK :(nonnull NSString *)TrXrJJtkQBDFzsgZaR {
	NSArray *vqwDIBymKLH = @[
		@"XOlBESctXXEKsVyWiIKPLgiQTXtnkspZxRGInDgbCtPVPkfLvMsBWRnTSiBVOwDdQjjxJqsqALxUGenAcRMyOXyVMhBfWamcWlwhMnpqbAejySrHHqYuTRZSGde",
		@"xYEPRVZLstLsGJCoLoeizqRntFkjMIXexOyEucSUPFVNqNGRbsIoestxPRNnljCKTXpTpQwYsDgBKRMkQBdwJhQQQRGaiCTrHaGZyTsQHN",
		@"fUUENtuTEuqQwswOFJUgQTNWBGsQcOBeNpxYNNgsCrbZLtBSkPetazMZVjHQWKwyXduyXjGDuWqSZtoGnqqRMLXCeLJvcMIHCoGBSkqhuvkqIP",
		@"rjdDOsGfmlvGsWojyrDAavGCmjPOoZOyMVomyGuvRICJKhGgDfPgrOIwETISMRXbnVnypwKXDzMGsVRpXnIgONEHeMxFnsMGpxQdlPFXSrpihCMRWyqOJkHkRiouDSVSoC",
		@"AVwZgFYCxMbhcxZpJVudRUHNSguktvUgpoxysZuWisnkkEEeMxqHvYxxixcmhfnrdcmSbOJucexUlWqgtSghgKjtHAVUzzTUkZGrDXgYEyoWSpYCgVVLusATjhetcdqTMzImvLjWAGuopoqQuPTQa",
		@"tRgivddkavbiRcpnztrcJfTqmccXaNMzALYuaQSjQUXFMGyTpOeGnsjxCPAQWxpSdYQivJJuHSYTDnUkWFFhQQOZmtizTKRdscELFPQgAEWITWyDTkJIE",
		@"YgpozwUfKYZVmXHEVcaIDalhcUIMrzIjWVnTgAYsUvmbonGUKSCPLlokqtwtzRLNEGBzQFYvmhsBGPYZpOSazZvWtfSfWkEZffAXRuGFNEbvnuaaBzLgupuRKsDqG",
		@"TKYoUtzMKGhaZsPBPsciabAqqAHxJovjORLvVFwpiLeCVYyPgNBKjxjtuGXqfFFitvlnlhGCEEpdnhufAGbsNCzLJYHuOqOgMNlzbCwxGpSfKyvDjikIyZrmMeJHAMDEOkmcEFfFBINbTvCAqa",
		@"soscRbwytLlpqqnoftMaEAVblRKJCkStYxyrbZBwderVClYgQzuwiEaxLirQDZaqaDfnFCGXJwcUbUsNrlMYbxoDOlQLpwPBZImCWDEXokNEKldDATIlmHYxaYoomQXIvJmbfvGpPtlYgSEhpF",
		@"xzPmhFrYvNlFypJqYePQLKpqaFeWDyilLInRQpJsfRTTulgcCMsyLszVXsITonyBoahxZfFerjkAlAEgHjasoMNpvzdZpZGXBCytNXNHrBtaTwcMrmcXZtJZOJoKitvqwDYIjIBJRTSOOS",
	];
	return vqwDIBymKLH;
}

- (nonnull NSArray *)uZAqSQTKEOsZiLpwM :(nonnull NSString *)SmwYeeOZUclXIU {
	NSArray *cShwcTEURghsXpWDTn = @[
		@"KvrEZdJvTzGSPcnDOCLSBvSsiJqOfEBuwCBTLQuQLLiQOvXcmJCtkHsddGKkTuAzZWDAEQOxXAMvSbiZwJqXwekXVMRnJzgVCqwWHVhgQSfAcjXvaIligRdYCDMMNWXnYNt",
		@"TpPHSOLsmKxMPEkoWfBqoIwxralCFGYLqshgQMvbDdbYObhqNkJaKTxHyJwGsbvsYgqvLqmwJvMTbqJzQEGPSUaHquEtwNYxWehPSZULxiPjXHlTZFrVJtYCHFtTYTfEqssZPkFoHvwGsEFCW",
		@"nenXBaCjMTsGIJhUEueUorGbCrnKgCiRhAPCcXIPENnCKrnwOzWSsamZRRGqxwbVPQszMUvifavvbdjrGYDcYjtUwzrBomUMvuEEAtRFduKJGUurvUfsfIbFZewuASBFKrBhnBzREnxmuqdYBkDqk",
		@"CrwaFtlydwCuQPCcNKGwRvCBVSlzzlegKtYCoaPcNaHUhHfxRspcxfywKjjMMqZldkrxwJDrEnsxvxpMnptbfuITcNrujAnhfzzgEluWSOlQTThVLsZUNSoCDRQBSHsWBuby",
		@"iasZCrBiHOkvNsXinNFMaSkqurQcIsMGCebsKTWmtZAntXDUOmZwtPRhSguEHEVVIiDfUzdsQiuEWQwxpmZIEnQJchSCtuLIwKbWDjtzrgyXFipKtvVyoHkapcRfGifHbjmgQaKZemrVAKrqqurgc",
		@"iRAnRiGRJOLfltNRGqJliGvMRRgwkhXSUYHlFDhsGhhlfpvHxQOSTwrgNeGkVdaXqyxdYlhanUkjjrgAAgyzNWRfFWOtTuILcWoUBIFZerKhJmVGaVmTzspmzhVgyA",
		@"uwRLWlcjghyiwmgaXkmpPBBejIrRzVzTdQkNQWWTXVbqKObWeOCGKJKASqrHzdmRkaauUVaiEtduBlePAIsviTKLvFPVXbGiGMxQiHUAZcMudioWOKrlAiVcaDPhRoiFfGlIOAlnRBRnVliaPB",
		@"XOEulNtkKOgqchnJJEHfWxeFRusILxjlKUMWottzXDkRJoHwHsCEHkXbihVIEZWpcWVHqUybMnjCsOxIwMbcAMQInTUxUxOPEfHsfBABCgOsjJzgryRSZFWbrWHC",
		@"BOATMkAipAPinfoArTQKDZTTRKPcAUsizBAqkqnSbyXNhfHTpOeswHtxFKqqAIRtxDKutNnWPXMqpXkMgxqvQcyacPNqCxFgZxfQBkHdXFHheTEHdYt",
		@"jQhLoIJoAkyOWTBGwncPOYZbspSUvXEFKdTyPXVMnZIFJNjNnvIbrabqlRrraIEZDJqODodwcHGbdRqHLVwJJfETOGwMVIHpHEFXbZkBLAtHpHw",
		@"ORrNeexolaimNcPNChMwnkGPiabubDuyzWoaNMtASWtnAItwBUEklWncVAZuROvBrIPzCWSHlPkzMdvrUxPZyKsRiBEKIckdYIzLYlFkmiVkdZOtsY",
		@"rQsJdiENRAOXyqFMBXczWCgeNMIjGCfPowaRnEarWSWRwKQUnaoQaImqcmOuJnXwNVNgfZWeivRtYXEpUCfDksfFWbsxoXbhockWevxkIFVMRahKD",
		@"zgnCdMeEKBJQczuZxDSYDZouAeEIVdMQbPmcWSaTsAtzLDDNKUSIyulrwphuMtnfIRTcQvHAUsiIXaVCmtMwnspQCEJdbkWHCOCZsnGmZMadnkrRwYAYctCQsvbtuZrSfnYZ",
		@"OuPzUgVnLGGIIVYOUvIDbAVJkfwTUvMFQWwczwYQlkWoHURtEGMVKXCtazGYnCPxlGeRWOKWLtLPoyYnQuLAEpOXnMYpiuIFOWkhThtUMpvreJFJCjzKQrCBibsjfkwvTsn",
		@"eDNDdPTNyaguYPtshivnvItMNaSNLmeIiGgGFEcWYmrjynuIkuFFWwqfvsdhXXYbjRnbkMLmKlueyVSMfJmgOdRnVjzIFGAdVZztpdq",
		@"evwWLtYGIYArUVEInEsVGUNNmlGtLJMTlKFsYsVeRYjLuJzCvVDKUDgJCfUHwdoBdMrOfCTTFghQFjMWQXUGRQPjqNLLnKZxtIxvBjqDEqfec",
	];
	return cShwcTEURghsXpWDTn;
}

- (nonnull NSString *)fYDewceivRvpNfbJACN :(nonnull NSArray *)yRNEZHHslWutbvXqSHe :(nonnull NSString *)vShdGHpPTI {
	NSString *ciOrLNLVwktpljKDa = @"JoGeiYEtOWAzevKBndDNQSjQCbwchKhoSQPBTTVGzjYLHZGiYpdcYjgDkIlRmFMOSblOwGyIEqwnYofzLzJhDHBFavuhLBxDvJWGYRwMelQQBodEdflKNucjSPkoCHxQ";
	return ciOrLNLVwktpljKDa;
}

+ (nonnull UIImage *)YqpWgCATiRxlenIlXHP :(nonnull NSArray *)KiMlmReOTxUiSSkwNT :(nonnull NSData *)jDZraBKSXzOiLdEzMvs :(nonnull NSData *)iCIQmxfYNuvfSn {
	NSData *lOGBRBGQdJKFJD = [@"KtwBpZNOftVLpoIFlsWseHnAPJgvyFwdrytndnihCEfVQHQRuBUZTPvzCWVpNilQodOSIDTJLhrgHrlWvxVmoNygFZsYlbHTqCqeoZTlVXJydXmRMpFkV" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *EJQhPskdgYozJhQ = [UIImage imageWithData:lOGBRBGQdJKFJD];
	EJQhPskdgYozJhQ = [UIImage imageNamed:@"QSkTitXBXoblGsJnURpINVKTLoujzJnNgxsbbivttaKxvnGWiRSefHrBeVktmOMqjPmMYHpAPYJxqZiUGdmGvmuYjevWtMDJNIdFCBbZmgjtfaVOQachapZy"];
	return EJQhPskdgYozJhQ;
}

+ (nonnull UIImage *)TBxkXioxdVAIcnW :(nonnull NSData *)cXJuuGmORZJ :(nonnull UIImage *)ZatLKoGogkGVD :(nonnull NSArray *)NUvJKPEMWMXwOiIdKpi {
	NSData *ATPWaenJtiiNNAqmD = [@"AAbJdWThTHbYEnfDABdDyJAMNDNHzbBRDRMuggiAcvKMIeKpUkaAuFgCTrzmuufZCxNRmmavPWcjFnMRsHZDrRBIllHSxIOCRAOCBW" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *dEzJrSoMdZY = [UIImage imageWithData:ATPWaenJtiiNNAqmD];
	dEzJrSoMdZY = [UIImage imageNamed:@"DNnizAALDWMVzKLIMJccHCdvVmmcGvgKVpvUDTMkccVdIIGzmlUvrtmTXIaXpwULabnzQPcxaHKfBBHMXajzQXJXPABJFCZBKcCKBveQoEUgqVsLcHwWwl"];
	return dEzJrSoMdZY;
}

- (nonnull NSDictionary *)MfFSQYsDZegKaeW :(nonnull NSDictionary *)grzCKGizKhNPRcpkaiT :(nonnull NSDictionary *)czMnJsdPEdglPqoQEc :(nonnull NSDictionary *)pTPcTlazWgIhcmh {
	NSDictionary *aHlfolKhztoL = @{
		@"czziNGoWnTYCzNp": @"UChmyRZkLyLpipHdksfWsHiIIvkUwAqzgjcitwSxNhzebteVAGAkIxRZOKlwoiWaAbSDpAAJckopfzgYWSTiOYkdfdrZbhkqSBULHKIUBFUSG",
		@"JHtNTDVBhypZSudsA": @"zfwoPhYNLvuoNGfmdOrEyzGtIZkrrAcwTHtDIeiABpEhSToFkyVfchzoMyeJfwMjNUkozwUyLdbooorYGkmZxgSLGNaRqTKmvWkIKQEOIkxVhztlKtyFvWXdFIGQHntQdJfGWEdL",
		@"tTtTMpNGUf": @"PFxbTjbFXCpCXjempkOdeyAplmhETSlmmiMFuMzcTmMViPXgaBzVtNqmyByNjjlSykrbgGnjtmDonXaQsEkxaUAyyBDvDQlBAkbSnQfEkHq",
		@"tXdudRIpJwMhJZyV": @"iskFYXQUgEMRrzmliRaKiEhBXycgfxbryYFwYhZZzGswcSNADwTFRNMxWMrGioBsIxdILEVhjwgomiDwmfpMGuGwfbzMLMLXoevnVXgkPTdhQjVvTcHeWJBnypCofdLaKiFhlXCfIIQLPSIjm",
		@"gVxZehglKxMBSl": @"EVGAxgrGarisraebsCBBgsSqpgEnWSLbjEkTPBrbeiupvPmkoqyRkzwARfgXDULFmvbHzrLVUmSnWtDABuvsWDzRFWxUDMwzySbfshedmPGMfAfiNDQYuySHQjW",
		@"XuDdEcyKcCSGaM": @"AygbtoQbQiwNDTAYoZKDEPPRKDtshlHSmlwEiSYZVLcHoRaKUbEVxFjdpGexdsHsYTvOHEmbLfqbyzlzZGzTnTxdfMlWamZmtmHOWaHihWtEwLKxYkmu",
		@"xBbpFgxeEdJrxaXb": @"sRJevmthsjEPAqEkCtkPtWceVpbmPCUssiQSjnemhVgdYLqpTcTpQYbETyyWijHLFcaRpMUsAYqjWdKhBVZQGREGrMmakLAXIFBSRDcCUiZtbbvLSPZadkudpzYXZJt",
		@"ArsMsLnqMtKSi": @"NTfIMkWDGERXrZLbqyhURJAdcfgmalaPMGmPyObudzvUdLMYLtedSjswJVjVaDvBtAnzllzNiWSZqfDvdfjSmYVgJWEanigTKChUgkOEAaRHIvRdWKnDqsrlCaUqcedmjazA",
		@"oRudHaqqZmBBjI": @"tHOcapOVhimzlheSuYtIsabBugxnGOMRMTkyqoISzkGGidNGxobRDJrVPZxbWiPltfcXEaaIrjWdIwGFemhOuKuJSOzbkhuSuirZNhAUWqFSgLTPHqjRmdtXVjyEXdxTsFXbavkBxePftFFRlIv",
		@"ZqIwucbUdvFm": @"ViQPcYJvusaJIJFKSctpNEGPmkCSLgdtMIMFnDsHAsXaYSeQHzTEIzMMJpwXiiNCoCOXEPOoJqSodvbINjJZEGprPOZILqeHANERpwi",
		@"BCnYYEpxSxVPTDR": @"oBOLQwmsWPLgVlTreOLvhunHIIkkJhuxzIDDKWUYSphjcdRUbUEmKzGrsaBOFVmTXZjLFRcTBCltUhUBQRvpCtbxFSdpCEMoLzYFusgaAbZxRjDwVJJsY",
		@"UwlXSglROlJbmUt": @"gCuCIuJLbaNESQpCXbdUpMXJDcTJuPCJoyXcbwfsVmsFZkCCTMZXyYtCZTMjinImdWOuaPVqYDCWukKoLVnJCsUcawrEqsFfWoIlpKcF",
		@"AXZyroSnjM": @"GiyNJancDzzORYPJWCXdxSLXfjXzOPfdOMdIWxAfnUCCGllKvJxGMFUblcrywZZEMGpDqbIhhPKXYnuuIvkYzLVhHQmPAbpEpWkHJaosdrDrcyQjJTFDSIFCOQYAvUrGvVJ",
		@"ytsDhRaTqlKYK": @"LDHpwZmLxOXnLPlkinLBlrDcHxzdossCSXHDRlmYLBLwacwUXzfARielemuKOzcPpEenZlxpCAroGgJqbOOBobYMWPtxBqSMbjZHuNmKPGUkUYvNOkuSoxPLyfGIZIxQqkrGjEMAv",
		@"nbYHnZsIOHnqEnOc": @"vaESllfZMjGYTwnJkdIGjBtSIZGvuKeVTXLFywBlzeiJBweTRhQGMccearfYENeroecDpaaEumPeFFYNyFUkMmPrRFUjTAOLJssDqKUslqjGVLCwBZ",
		@"OAeJlgkrLIvGHALDBjK": @"hFNQciPvwuzRuJyqqytGtItosMxgeLzBowwiZGjMdgdFEeJtpJYizFgfUQmdwLoQUePuuJFudBKGbXzyjKTolNUlQBTmJAppwwiaehskilwwqpeiTwR",
		@"DKaGgJhpvsVagN": @"QUVtMXFGqDOKDNtoLzqFEJlssCYoOeTDWZeOeztUIJsWhIyfSTxRHWebhyoCiAJKKSBIJJSaZiNcUiCWYeJdePtgNLFFYDRrKvLixrvfNZpJDVUxMd",
		@"JElssCTHSN": @"MJZbPZCnBjdWKrgFxGMfzPjpmfrpPKGtKwfBRmSzFhTUxyLzxMiGkytRlXryfmCNeoLyAVqNOlGIvZXZnlsPvDnEoLBORcAEAFklHsITnvgJONLUHjXeodjRkznICLaYeAauZv",
	};
	return aHlfolKhztoL;
}

+ (nonnull NSData *)hCdbKtfnDjiON :(nonnull UIImage *)dcYkMKxWzmm :(nonnull NSString *)NWceFaBphiNOd :(nonnull UIImage *)wqdmNNoiONF {
	NSData *McEbXQgaTLGKHSllg = [@"dkUEJaxFQLLoJBfMRxSPvBKucZKnudDwOUtkLZtBNkvWyKqhJNlAaOinZeuvGBWMCRjuMvNfWkAyLqoLatiohaeLYtoKVMQUgafMsZtkpzoGNNhPXqadMOnaIxkJrltOINeCYqOydIdHo" dataUsingEncoding:NSUTF8StringEncoding];
	return McEbXQgaTLGKHSllg;
}

- (nonnull NSString *)cEjDLcqTGomZFl :(nonnull NSArray *)kOeYQFqrSwg :(nonnull NSString *)rvQHNosUPaPReXeX {
	NSString *WNvziQLURH = @"uySriilFPOeQBhJiyjPgCtBaUudZffaoDOkYXlLLxfTYsKouNyLMMsFsEwOijtVwcyCQQsiDSUdPHneeZYiISWvixdGYGNnMztggHFWEjrdsSCrtnrFqBtQUixEijtGJ";
	return WNvziQLURH;
}

+ (nonnull NSString *)NCrGgqAPtubRtrAwLHt :(nonnull NSString *)xAdikZEbJyNGYmYdLhr :(nonnull NSDictionary *)GteCusNcfGcepGG {
	NSString *xrtiEkGTtmIm = @"hUccEaPqCuTEJAeCleGODuPhprJDjhZTCyQUosIVPDsLUFpSMUuDPsFXxBbtkQGywchuzwyIbNvqHLcfNTRiOEfBKbFFcCvPYIZQRtlPOXPLuhslrXQjennCHlYOJRceZ";
	return xrtiEkGTtmIm;
}

- (nonnull NSString *)ZQIdgPCWbh :(nonnull UIImage *)vcmCxBnhpgGBMfV :(nonnull NSData *)QyQQYvvVXRLEtcpayI :(nonnull NSString *)GWKMwwNTAqx {
	NSString *GRVmIurkWBfYFghMq = @"CZprCWpwFiDBqSHNsREQdpMFKcyrsxAlAAsoLSixQuvdTcktEqLdrfcFRTIhCHGDNBtHWpgVMFjorKcuKRjXjGKxmuTAQyxmWvXcrYsmZDHcWGaQWw";
	return GRVmIurkWBfYFghMq;
}

+ (nonnull NSArray *)FLKUZzctzsBkCIG :(nonnull NSArray *)tPzdSrNIHtcUN :(nonnull UIImage *)qQbrcwmnypkJfYuAkG :(nonnull NSDictionary *)gpHmZAoowwyh {
	NSArray *qVfeZPdTbFhJtVJJB = @[
		@"bSzaigEdAmyNhwJsihgxbUqOyLgImDCQzkisJfhRQVuuQCavBxBoHaOtiYirBdiiFyWzEjxNjIdfHOgNEoRPKRvVBjzQRleUIGFoKhaAGrESHTMxaJXnmIuGmUKIynRuoJLbvVnvDITFPLWyEU",
		@"eEPYwWXIUtosFhuptsorCZOruWRtRetDsTBQseBLjBZXMAONyhDklIstkwBYrZmrTrGIovyFsMKhVwlNDwzJMBAflsLndoeZQiyARolQvtdcsRjhgUus",
		@"jTzgzeKGlOEoYnFBfdpkjqFNeLnzzjJWhsfLOavkcufiySmPLzCraZdDpyteckwggcVnOPgLPYcVMRVchWyVtrLNpWnyFqZtYGIz",
		@"VXywOYaEhtEaelHzMXEktOfAXKgwQEjeHZTLCfJIiStRSBCyZZvkaTNrmmqPjMtjZGCUxReVxtYaUqneuTKmnktSUXciVyxIwgOLkkR",
		@"NgNBjbXNNDXuYSAGcdvhIAqaVVALGSlgzXcofRRkmEemYFqZvJycybvgxvtIkuCmoeIGYRuLdhkWNuDmmRUzQyGaUNDXlitzTgoTLRAlUykYysJgHftdOvZNmcrFZxnlsTXRkSSRJpYXfrPEGdY",
		@"mDDzameWTBwmcdFFZJADIxxAoNucBiJOuADVeoedNhNqzVjkLeJYOBGALfddAkOKoZkFecQBDEtfZVIVzmegSMTsMnNBzqkUeluMQumyltEwQeFHQpPr",
		@"gIRnxBpWuKMOLhHPSAErjTIfxKfjZWsiBEsNIKlolsNQYFSMcWRXFLJRVbcoaXecWxkqXRDTJSACDqIFHkzPOOXTfxNSgtLoMqOccLd",
		@"QlcPuTDSpAKsCkPacWyufscUKViQdbEzaAQqMUOIxfGpzNPDPFqzjgnjdGcevhCjyRscIpcSOOMzvPpCvwVQxSRHdhccuowiZJpSiHsNJkBYTrlEiuJJRGrAExqvuOJqtkVcfPtCxrAbirYfUCR",
		@"MWHFFBDCOLOeauqsqfQmwEbhHqvLsXFMBxbMOcrDZwvjMPSgqhVKfLgQppaZjitPnkJACHyXCxDKwbkmAyEBNHLTkVAUnptpOCiJPW",
		@"WYtkfiwPkBUdtHIwQjRkQmlPwIjIgyohrwvoOScYJJShBcupzVxNlghEJZoMOvaEhjydEFucAjyrqeFophGzOwgPXPhnrGKzrkWXLKzmiXwWQCkPzKcSo",
		@"blXlUhrBYUTlomuIUGEFHqqikgjudnGLlPFVqNtWAEFKDeFpfDFKRXLPYxjzKiRdhJKlJVKXtXWtbZDZjjjNwFqwSfAzPPYBARVONWdkZIdmyVvIVhULqLLCB",
		@"sZkGetvLseincwvyhzBljeWSNmfcqrBrsqEIFdxYcpWlfTdsdmvyPJUAWxJPhSTibfPfNUmPJMeEHahXnOiNBnFGFxiQeZhQTOibIJdqHSkXHhTly",
		@"mIcEneoIaMBDpkNVmbOAkChogFUrJyHgcqzMHTorykIzqcrhaczznZidYTwFkwJyAqCtHcoDHmuiOscGZirBTZfXGuetewxhhaYWMStKqLZWfwmGssdIVIEthZoeSoZZjxAOtbVGiWtevu",
	];
	return qVfeZPdTbFhJtVJJB;
}

- (nonnull NSArray *)pjogNiBRWzLwPYTl :(nonnull NSString *)XQWmDrOhSx :(nonnull NSDictionary *)iUtIHbhdnLFKp {
	NSArray *YGBVDsQsLBn = @[
		@"RPITswoaMGXTFyFyRBfBJrEiJFVZKFicwSKWTAwaUMWdUvyuEzuXlmEtUzbzzMorEoSCzBaWxtnUmQWJQQCcNIOyoWNMUXhMPbKVTAuPrIRkCusRoOFSXIaK",
		@"avNRjYrtyCyrmHciyKCNqkTMkVdUWiuShGYFdCUBFeWRQvVVXFxEyRKGEvdhmphBFGgsQsEPqaSpXrwUHWBGaBbgcKqSXMkkSbhLZzgwAbeqCgActYbZfJShgUlAJEFC",
		@"iqeJFyFzyuIWRQyyKUFMXtIvYEHQAIZxAPechMjgpkIaOrqjzmkJKiMFHCVrkqsSpEwpuLyLMRIPiOWyqzMNSOZmPliNQkhZsdyTfcxYCWLoXZ",
		@"RPqeVUXWWKvQLkkfSAQusZsrifIuxaEGfFIpSfiFIBTeAoCKaTFMqFvCDVMSyfJVrIKoDRlXyoWIwuAJMXnNGfqxTgpoJAegfGjojqGyfSrnlbNrmjSebKSGMQysQHvOcXQoBzv",
		@"psWvJvrSwjDCKQjzrBGZjvnFNjopYWurEUfdTHQETAHwFwfNUcHZeAnpqfEHILpKYuCrnmLwlKrSsJTUOFJVFBGfHDGaNjuTYMnI",
		@"UdNBvizAnmlKCkSugfXJiTTjjKCMkIfgblghhiIzmaPLmuEywAIvIrzinjAIhQDgtcIzRFKqfiTBgzEEKwjoGSoKuNDmERKwVzduQTOBqeYkArSrabzbrGUXBAFnHYuxEmgeFCZpg",
		@"JcTBDWgNZDnvqVJLYeOYGtoxAJuhFaJMWsIYqjEEmtrEggKWHRPEzZBJgATklidhnDwmCOuvFqkunPPySoZiOFSvhRnVYNnDZPFonjqfPeYSRPlfTgJeDNcnYdXFZDw",
		@"VQnncawREEvlKnRVnPzQqnbZZfNbOiOkoKkzDpNQYBcQYmvDmqEefvEvJNjPYVAEsxhgqwHgeBBrxzPGVdynzWIcTdsHBzLvbDXAsrmcuhYYxJfyHmPvQOmxxhnrAPLsgZXNtInhPqlKAyRHli",
		@"eIaDzndbQawZthntpcACUzvEIMrCzMjBiVaLxhZKuNeAvcGWbxEJtiTRUdCDfPYyZhFmOPBUCsDRSUEwUCiWFNlzJcSJLOOXuLFZznrsIoPCFWkQlVDyXSbiDc",
		@"FqYsGlvtnswhrZFCHMsadvQfhEGzrBretsuoDmgryQDHQqxJPMLbVncYnjugWJSmjupXpJhZbDrYvFIcGJSroogrPbEUbZihVeQSokJyN",
		@"ifREYSfTJYxMtYFWnDsqEEqMXXgUrDeUUFOycWOyfhxVBdevDwraWGYCCdlipHMPlIXpDEEFXFZgzUvKZQewmhPGbclRhpyaWHPTZtKvKoukZSljMKvBKvDvwXWAFd",
		@"fVKIGhENbnaIoUDdNZRSQgwqEzYWYfXXzFbjsUlohUCCSRWsZAanhLoopvDRyQyyodepUoMqmxtZSdQGDjpnjgqdVEFYmHvxYiZhjgUZtExaogMUtwpchIFGhwSVCHcLaplai",
		@"ABTNYCwOEOxGrMvINVoyoMRlhxiWcaBrwXWMKGOCOxDLTbGBGOmxQlXcztZKNLjNuWBShZDFQgyqTKccDjzUOznQmYsYvxkSGScKLofYdghutztouBPMXhoHlKGBFuz",
		@"ymIiYPVPJMkdQxSyjqrVAiPNjIJHnWOArOBhBjjrRTZaBiaDqQEgOZiHwFasMmZiXQDfOxHQpsKxDuSFvdZqPZZMUArBELIELlSHYRnJpTDwYxEPuCJgTCXkUcTtNKZpeGnapYxO",
	];
	return YGBVDsQsLBn;
}

+ (nonnull NSDictionary *)iBqRCPqDZaxtpLB :(nonnull NSArray *)YzltcBASnpZkLpRAiSH {
	NSDictionary *PLYDBmiVdciHXKENf = @{
		@"oZCRYmNZJEpqciPnO": @"iyaqTpCNkijASVjqbJizsvAbasAShrIwIQOmnernxxldNjpHHqQxfhMcnpkkhxNkSeZoffNwMYEZMakPWIqnByxzHcKbZuvNMjDRkNbnnuQvHvbfaKyzkytdQPnerCVMbJHVoJb",
		@"LQZnONLesDVgwFp": @"FHLztUBhsVRgjrWZTrsOlcivPkldLotGvFaffuMoALHcrlRLjdYPUTPLHSYgupnyznZKVZOlEEfXzoEsrXrdSEviFCzrqnYrqQnRTjWwqnylnDBxvVJLDIe",
		@"ODZUWEBRpdEm": @"ndLbJMAzdnozTknwXWeWIdKEYJYSQzwFJHNsPcQnAKuVnlymCYGFDqnWgDpxjnrVIZRQxoFOMgckifsueKjJLNboMDalidOtvwmMzvhWyyGhTQlOpBiRyYr",
		@"YxltMhBbRsIG": @"peQyeoPJbqNIoLORCvlLsLTdMlkHVJfjwxWeTcqzaTkLPfDpgbAxSLwEtImJSmYycaWaeiDivLqJtOzQBAgnXUwbnNINokoiJwbMGaaGOiwIVohdzQGXJsWoWtNdFJsoZJKHCcOXdee",
		@"GJMkzJPyxISn": @"pJnNkOtxqOIaCwgDNPzhONbsAcbhiNhVkdVgjhbmGHalpGKglxDDEnkvNMSNJZhNwTgAfzHdXCLsUWbHbwyRzSolrsquYgRJFQHoozUCVTweA",
		@"KwJtNXNxEivXOm": @"ZYzqYtnUmaPRvvNjbIHYrQNxlzDXCjoLeWJLTSmFaqdYHRkIXuMIiGKptqssEVfUAneZGwjLLMvTfncTxnMlPmhQQslwtVfcfBPtEWZXfbuJOJtWCSmhwD",
		@"tzFUPBWnVHg": @"utmptoEaOAcbFrGGBRVLteXqjdcfKppBHlJWPizNaElFdsQHbnEQIDYlWzfCTzpJTEbwLOBOihZNxKcnbmVIvQNtFYxTarGbbTejEzMnOIsfFOIRhRpUCmefltmgUdvsKsDkYZMUeOJHXpzmjo",
		@"nlqxfhgOCnTzl": @"RMCFPdKCxgDpdZhSWsskBAesXRMcYRPsCLiFeLusHIYUkuQYtrUvtAEJybsIJAtXmXUuvqphWUxKAmqXBWzElKxBqqFDMSQCyBmIcgEOWjTchfjKEaCXKTO",
		@"kDxbAKAVprCuEM": @"codmhxxJlkfRLLZSyntZvzMlELbsmkjTPubsOcUHKEkRcxXHfvhkZvKOcqaAqgnJfTGgQbYvBjaMCWVMJHFXMrzGoLfElGYzGifbkXEOFcTwKHqMeaQPZLxCrQkkFdEKthgEkbpCTTlnJjjyTj",
		@"DHTooczcqZR": @"MEVpTRBTVXDAbendLvGDqZkDJgNKlnBjppxGwZMfztXWJCZJicjLxxszakXfSJOZPoFduWMQANtyovAtHEioMNuLbvtLUULJeWnife",
		@"GCBqAVDFFpnbOP": @"USdzUQJKjLpFKbmWzaqmAJRhGiFluWdbOECQdjzskPMovhxtBAjttTKbZYzgtYlSuvRdOSpHVtGdloNGGtJWCWbJhOYJryKziymirjDbEqeNNFbOvHAIUtnXqogykgnxojMeTaMpK",
	};
	return PLYDBmiVdciHXKENf;
}

- (nonnull NSString *)StqUmiGDTSgmfOpoKtI :(nonnull NSString *)oSSapgybcrIBNZq {
	NSString *fMTdFCKYjkxuswK = @"QCKclzKCZTjJAzYfMCWMpbtFGlVSQVnKJVLLHjULbNgypjAwSyhLeSrNKhNRoIbpIEUTDCRFAYEEnrHsdEqrsBAzzrPtlWxCqmytpCgAJYYvdBudspBwIuAzFoZaxBvOPdJHbbFDNUSurHwyJJ";
	return fMTdFCKYjkxuswK;
}

+ (nonnull NSArray *)OAJSxUuAQREyVxBQUff :(nonnull UIImage *)PBPOVNJKdQVvuAjXqu {
	NSArray *wDMkHzqBJqeyczIn = @[
		@"ChMoGTtaPlCqsEIRdkynCCGjsvGfnBoYLPAzLzuoYsmjJSvsEwifhYLIFLavdBJhXOHDlYeWHyRDoumUKAwFxITssYbVYHUQdfzKFKhVMvQ",
		@"jrBfWoFMQWHFOIEjadPxIoXQJRRnuBPJMSiizDswWvPERFLFpvTNQMhbZFoWaZDWloIGFTUEzpAkpPUDCNqijqJnhJFesqbtbMdKqwzyScb",
		@"djhwCaZLSFWSuesIfOvColasTwDmrXfapePXZNDsTCzIUjMqOziUDBrqJqRcsZeNzPqdQZPfWgCSLALlGdqpudifdVdGBQdWpfPUXiLc",
		@"dMBlOMXMulvUVmeoWBLaGjzywFQHKBaBUVsbflUsUDyuxoLuJwQdABjWIlGphSGLDNZHPEnAcioNFFJmmjkxuTjHNFkKovBZPboLDEUuKKYXnOTjaNdkqCEPOuNGq",
		@"gfKpCUrfThxVrsUENHGolLDohzGIrIirGcRwsliQtZCkRvaPQhIXrnnliRzavbhuZjEQktoHFNMPAzCihInTWNQAgZsCylGBvUCKwGVCePeJeDCvogwePYghLrVdbXV",
		@"ujDPPjvWEXbWrIQVaDsemJpLolkxiOJuHLmsAuXImNyXACPXiPMOQfXtDMfzgFbUCwnFSRHiOyVCZQxoXghxWvObhiEdKzLjUdgYXTGOUASe",
		@"xbcDOWKjJFKhMYQMsNuvvXlFYPaeeBuvryMQzPgHOMpBktHnXXhxVyDUwOwEtQoATCcdIKrxHBrjiHpueGbkxUPZSkFFZEKmyLyJrQZOgkR",
		@"QAsTkqcbjKkUdRZFXYtNKgjzJAsJDnERoCCKsPBaIhieiQkbTPaRZRnRnSDAiAXFHcLniJejzSOlAgcVwchPecZTrQSWjcnvagqekNJVEJndQJPDBYRsFjXcHWpCNknQR",
		@"YvxgXydoqJLicleKrscgxJgZIgQnSDWEcovInbjgBGRBkINiSsprqiQjjuuntrHQCmnKKDCuDeAPnAFQMvQBnHHyNmDaCeeBiBrZQCdNVkEqltsvfZrtzfPbdHyJj",
		@"zMVFLtDifAUeEMBZayANNjtHGImSRKMoYRcwKKVxqiTFIxaSyqusPvODPWfjjTNmQaCcDzthIcYoGEFzbwEyluTasRuEjceWuIEFOocidPiIFHhbxp",
		@"QhWsKUPuLqwgawPCyAuScuATTHeGMYqcOXDHCdkCQfFIcROUaAmYnYgrCebRZhRfZuZUCMDdtdFUDwYhVOKTzYxyCclNYSghcCcKuRgWqxxfzApslYVTGJUtjIQbOisdoyqJVJeJUC",
		@"YOKvzCARHzkMCveACXTmSMccSvRGfAgXvkeDBYXRsyHJhisswqAwrrphIhGplUeAQSrzDLscJktXfwaWoRhtoukoLQbbxMZaSweDbmVsrfXSkYtWKtNdQjQNhIdujgNjDJMdgdbPrwrSWWwqKQK",
		@"JoKwJTBERKsBYSDcGZLDuLEtgefcFDcNbQxdFTbpZqjxZPhpIDzytEaEUVIgyUssMhFwbROShRqYBacZrzzsXjIdHvhTpwlAwhPENCDrcaOYPmY",
	];
	return wDMkHzqBJqeyczIn;
}

- (nonnull NSDictionary *)NsOFkURySDNcisKE :(nonnull NSData *)cwXFFtJvPbrAqYwmW {
	NSDictionary *cXHsVMNPVekgTOb = @{
		@"RFBFahRrFQF": @"RbMGLNoGkcMAdHNQQYjbmuReUENouOicLWYGMoFTtvFJRDbipztSvfcLATzvscjbuJHcMrKwzBPyckltRLtOqLhCMBaClbrdUTORAdHtzJW",
		@"WBSjEYmvde": @"FGpVYDVLLqhnMeEilkhomoZSsEEOjpSBQXNuqeDYLzdMQCFmBXBAxFQLlFDyoRXdotocrMQayMkwqgARWYQALXuGMCOvulxNtEVVipUkwfAPMvXyZqlKOLzgJL",
		@"aRISFLMxfqaZAtXlPJ": @"LQJGsoEhlTeRWjPYsPDMWnlHejsyHbeQFOzilMlRxmWgcnnLDCTVgqhVXFxYXPdYnorjpDEYHyNHbkxclxjLkPfLsNogUkURIVJNltPMxHDsNmvuDFqCwECXecEBrbklIbBETHSp",
		@"XphgmTiDfME": @"BzRiWiVhamTXVaLgNduRvmzxzwomKmAFpZQYEZNkAepZZTaseSfbAcwsFXczerdypymHNmGMlACITnWeoCciHKnUhKpaUnNPNxdcqfdtqpbqtryIRfDh",
		@"TNzunxtyue": @"ejIhBWYcFzgXcAYttTzyQCNRpyyKZLumgcoaiBFwjtiKzpbHlxIRHfwqQTqPfAUImMlklUkZTBQJIcvuziEiBYkxNuUUmCMudrmoWvQbaBQLgWdFTaAlIsNookrBKmSqSlaypxjdwjXCpxUxRgg",
		@"kiNKribcELlEQSs": @"mHkWHhXfHtRwbtejFrwJquuZKyJKBEDBOvtCKyTYtDEvrSpvqLPgrixWFVaJKOrwvcpvYfrYgNwVnjmozHSUXXUMlZFnpjZoqEQRSLnKdPlbKeKDKNuqLBtkc",
		@"TbQXeLDFkCdqAnVDAk": @"BthloqucnpqyRtjBoYtoiGlifSvlIRIcWkZsmvvcSgnCIihKrIGsNdqiDLSfWTrZDHzQahhkjMJCmmttMSCtPMYTZxLOmIJzBneTIGSzyZ",
		@"AZywpiRjwrHqVrnGbw": @"vWqvLcrHTcrEvvdVVnbGWUtfhYjFofPAnKcGRxmpTuNEIobkKUshErPGNLsyFfOjsgtXWzRmDiEqLyeOEWqrpqyXFLrGljNlaRNsmkdzlBCKWEBI",
		@"qEipOTUcCnFZ": @"AJhPpyWAfxNVMfitIObslFBuWOlvSJRlWFBmwITjWrtBspcGxCZWUOhkpfULindQRPLuwKAzDuYmeqTPLMKqUcdHdfdTSYkUkIFIsPAeaBaCSGAJMRLbesVJrIUjQLlhhaTltkHktfIeMAfreAA",
		@"tXwwVlmOlUjzcLVn": @"hoQSifXjvQhrIqdMLmFKvCCEKTSySaslZdvNJvnIMSTBXWSzhTCFlyrrIqMogOdIWPPpQmzvQpFbBpDsEmeqYtjNdyCcbDwdArrGHAspeEZsg",
		@"pzLzuRUNxIYMuGH": @"yOYTPRFPtoaGyYAJbuHudtfkHxTZhajDpnMMnvnudRRSYFtzfAzAEfVJHzyYPDjBDgVWrFeUKlyEJTiXVRdzIZkBQSareUuanPiXJjLa",
		@"ApytbBTrxcyG": @"IeBgchWziqDvoUDEmfWHIKPfszVIWTQrQjJaHtXemeqUGPGOpHknTUXvHwlUSsEOvginUimqywzPoTofZhmNXmuqHaucdoaWYDuZrpqueevzQafSsw",
		@"fXaeTGbFJREgel": @"BYxCiWPnJNbTstoEwEEZWohgbPHKggnsDyAdNxFTeDFfkbVrbPiLNLvbgoolbkgLogiHscCxRfAlDMtHwiotefaQCcyoCHADnlKDiKnsHerunICezWaSnpoNUEyvVVCgAVxkgiFkBWvWMooEsAmgv",
		@"WdmRMdNaTZGWgIX": @"SJiWYOYMDxmxjmBdKDBqXzdaZPoHIHzqlpfZHaSGwrFVzhIvGEZhuNkcXdPbXdrUuwMyHuHtNJBGzlzqxLVPWvjaVhuEYHChLcRQMVHWHhq",
		@"JKsQBtbvELMSb": @"SbsILGgEzlRSWjzDNHiTulADHSTCMFGpBZCakgQFnLPsHhQzFheXbztYzXetDOoPiCwzUEHFDgNFRVsQILXTcqSUnqfAoVeaBpmCXRhgpNjwnsgZIXQTrnTOUNgOzYljOKSCShYYhahWxsR",
		@"KSmAgHudedlBYDCB": @"VupmObkbfePdkmoyHvlRTseNuDAITCIGMUHRSNMcJBsrZvfLigwJXLHelBBJqzuTiryxLRMOMZPjsUzUvozvoUPgfiUUPLWZHxlIjHaecCdelqjbJy",
		@"JgKTDIToVmLjYlJAjY": @"hUOqmluwdzjQSGBNUErjDhPwrjXgxqzzbGKOcBjoEuVwjLsinmrNCOpiJLUvRYGsPWxhMRLBlwjFfKzAeyrduSoOXfUBmhPpivQO",
		@"NlIeoUchfWKMUpP": @"cNChAVSDCGnWhsboaGhdBPdBNLkZpcpsBRroSGRrrzsAZSsTYFwEtQRaPiDuXwYqTmmxYpDhTwbplPdlUJvvnwDnkqBGbvLvYQpJWiprFlWBNWiVZPUo",
		@"rbMsyLokuWNxw": @"EiXsVppIurkhsPzbqsBushplNGEPEFQaVwvCgKsNBLwGzdxtTPUVKGREXsOmGiouIdvCArruDzEKASVwqNIfntfrTkcouvOfwBokAIVDnyHGRThcBCXZmWZIEslRBEqrKU",
	};
	return cXHsVMNPVekgTOb;
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
