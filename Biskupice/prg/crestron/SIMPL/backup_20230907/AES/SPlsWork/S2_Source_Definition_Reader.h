#ifndef __S2_SOURCE_DEFINITION_READER_H__
#define __S2_SOURCE_DEFINITION_READER_H__




/*
* Constructor and Destructor
*/

/*
* DIGITAL_INPUT
*/


/*
* ANALOG_INPUT
*/


#define __S2_Source_Definition_Reader_SOURCES_AUDIO_IDS$_BUFFER_INPUT 0
#define __S2_Source_Definition_Reader_SOURCES_AUDIO_IDS$_BUFFER_MAX_LEN 60
CREATE_STRING_STRUCT( S2_Source_Definition_Reader, __SOURCES_AUDIO_IDS$, __S2_Source_Definition_Reader_SOURCES_AUDIO_IDS$_BUFFER_MAX_LEN );
#define __S2_Source_Definition_Reader_SOURCES_VIDEO_IDS$_BUFFER_INPUT 1
#define __S2_Source_Definition_Reader_SOURCES_VIDEO_IDS$_BUFFER_MAX_LEN 60
CREATE_STRING_STRUCT( S2_Source_Definition_Reader, __SOURCES_VIDEO_IDS$, __S2_Source_Definition_Reader_SOURCES_VIDEO_IDS$_BUFFER_MAX_LEN );
#define __S2_Source_Definition_Reader_SOURCES_NAMES$_BUFFER_INPUT 2
#define __S2_Source_Definition_Reader_SOURCES_NAMES$_BUFFER_MAX_LEN 300
CREATE_STRING_STRUCT( S2_Source_Definition_Reader, __SOURCES_NAMES$, __S2_Source_Definition_Reader_SOURCES_NAMES$_BUFFER_MAX_LEN );


/*
* DIGITAL_OUTPUT
*/


/*
* ANALOG_OUTPUT
*/


#define __S2_Source_Definition_Reader_SOURCE_AUDIO_ID_ANALOG_OUTPUT 0
#define __S2_Source_Definition_Reader_SOURCE_AUDIO_ID_ARRAY_LENGTH 20
#define __S2_Source_Definition_Reader_SOURCE_VIDEO_ID_ANALOG_OUTPUT 20
#define __S2_Source_Definition_Reader_SOURCE_VIDEO_ID_ARRAY_LENGTH 20
#define __S2_Source_Definition_Reader_SOURCE_NAME$_STRING_OUTPUT 40
#define __S2_Source_Definition_Reader_SOURCE_NAME$_ARRAY_LENGTH 20

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

START_GLOBAL_VAR_STRUCT( S2_Source_Definition_Reader )
{
   void* InstancePtr;
   struct GenericOutputString_s sGenericOutStr;
   unsigned short LastModifiedArrayIndex;

   DECLARE_IO_ARRAY( __SOURCE_AUDIO_ID );
   DECLARE_IO_ARRAY( __SOURCE_VIDEO_ID );
   DECLARE_IO_ARRAY( __SOURCE_NAME$ );
   DECLARE_STRING_STRUCT( S2_Source_Definition_Reader, __SOURCES_AUDIO_IDS$ );
   DECLARE_STRING_STRUCT( S2_Source_Definition_Reader, __SOURCES_VIDEO_IDS$ );
   DECLARE_STRING_STRUCT( S2_Source_Definition_Reader, __SOURCES_NAMES$ );
};

START_NVRAM_VAR_STRUCT( S2_Source_Definition_Reader )
{
};



#endif //__S2_SOURCE_DEFINITION_READER_H__

