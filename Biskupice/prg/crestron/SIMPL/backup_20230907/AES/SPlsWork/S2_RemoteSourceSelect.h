#ifndef __S2_REMOTESOURCESELECT_H__
#define __S2_REMOTESOURCESELECT_H__




/*
* Constructor and Destructor
*/

/*
* DIGITAL_INPUT
*/


/*
* ANALOG_INPUT
*/
#define __S2_RemoteSourceSelect_AUDIO_SOURCE_ANALOG_INPUT 0
#define __S2_RemoteSourceSelect_AUDIO_SOURCE_FB_ANALOG_INPUT 1
#define __S2_RemoteSourceSelect_VIDEO_SOURCE_ANALOG_INPUT 2
#define __S2_RemoteSourceSelect_VIDEO_SOURCE_FB_ANALOG_INPUT 3



#define __S2_RemoteSourceSelect_SOURCE_AUDIO_ID_ANALOG_INPUT 4
#define __S2_RemoteSourceSelect_SOURCE_AUDIO_ID_ARRAY_LENGTH 20
#define __S2_RemoteSourceSelect_SOURCE_VIDEO_ID_ANALOG_INPUT 24
#define __S2_RemoteSourceSelect_SOURCE_VIDEO_ID_ARRAY_LENGTH 20

/*
* DIGITAL_OUTPUT
*/
#define __S2_RemoteSourceSelect_REMOTEOFF_DIG_OUTPUT 0

#define __S2_RemoteSourceSelect_REMOTESOURCE_DIG_OUTPUT 1
#define __S2_RemoteSourceSelect_REMOTESOURCE_ARRAY_LENGTH 20

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

START_GLOBAL_VAR_STRUCT( S2_RemoteSourceSelect )
{
   void* InstancePtr;
   struct GenericOutputString_s sGenericOutStr;
   unsigned short LastModifiedArrayIndex;

   DECLARE_IO_ARRAY( __REMOTESOURCE );
   DECLARE_IO_ARRAY( __SOURCE_AUDIO_ID );
   DECLARE_IO_ARRAY( __SOURCE_VIDEO_ID );
};

START_NVRAM_VAR_STRUCT( S2_RemoteSourceSelect )
{
   unsigned short __NOAUDIOFLAG;
   unsigned short __NOVIDEOFLAG;
};



#endif //__S2_REMOTESOURCESELECT_H__

