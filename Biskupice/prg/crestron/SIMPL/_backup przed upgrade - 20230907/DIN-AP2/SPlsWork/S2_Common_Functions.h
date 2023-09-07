#ifndef __S2_COMMON_FUNCTIONS_H__
#define __S2_COMMON_FUNCTIONS_H__


#include "S2_Common_Functions.h"



/*
* DIGITAL_INPUT
*/


/*
* ANALOG_INPUT
*/




/*
* DIGITAL_OUTPUT
*/


/*
* ANALOG_OUTPUT
*/



/*
* Direct Socket Variables
*/




/*
* INTEGER_PARAMETER
*/
/*
* SIGNED_INTEGER_PARAMETER
*/
/*
* LONG_INTEGER_PARAMETER
*/
/*
* SIGNED_LONG_INTEGER_PARAMETER
*/
/*
* INTEGER_PARAMETER
*/
/*
* SIGNED_INTEGER_PARAMETER
*/
/*
* LONG_INTEGER_PARAMETER
*/
/*
* SIGNED_LONG_INTEGER_PARAMETER
*/
/*
* STRING_PARAMETER
*/


/*
* INTEGER
*/


/*
* LONG_INTEGER
*/


/*
* SIGNED_INTEGER
*/


/*
* SIGNED_LONG_INTEGER
*/


/*
* STRING
*/

/*
* STRUCTURE
*/

START_GLOBAL_VAR_STRUCT( S2_Common_Functions )
{
   void* InstancePtr;
   struct GenericOutputString_s sGenericOutStr;
   unsigned short LastModifiedArrayIndex;

};

START_NVRAM_VAR_STRUCT( S2_Common_Functions )
{
};


struct StringHdr_s* S2_Common_Functions__TRIM ( struct StringHdr_s*  __FN_DSTRET_STR__  , struct StringHdr_s* __IN$ ) ;
struct StringHdr_s* S2_Common_Functions__REMOVEDOUBLEQUOTESANDWHITESPACE ( struct StringHdr_s*  __FN_DSTRET_STR__  , struct StringHdr_s* __IN$ ) ;
struct StringHdr_s* S2_Common_Functions__CONVERTTOTIME ( struct StringHdr_s*  __FN_DSTRET_STR__  , unsigned short __NUMBEROFSECONDS ) ;
struct StringHdr_s* S2_Common_Functions__ROUND ( struct StringHdr_s*  __FN_DSTRET_STR__  , struct StringHdr_s* __NUMBER , unsigned short __N ) ;
unsigned short S2_Common_Functions__ISEVEN ( unsigned short __I ) ;
unsigned short S2_Common_Functions__CONVERTUTF8TOASCII ( unsigned short __HIGHBYTE , unsigned short __LOWBYTE ) ;

#endif //__S2_XBMC_BROWSE_H__

