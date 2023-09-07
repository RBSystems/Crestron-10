#ifndef __S2_SOURCE_DEFINITION_WRITER_H__
#define __S2_SOURCE_DEFINITION_WRITER_H__




/*
* Constructor and Destructor
*/

/*
* DIGITAL_INPUT
*/
#define __S2_Source_Definition_Writer_ENABLE_DIG_INPUT 0


/*
* ANALOG_INPUT
*/




/*
* DIGITAL_OUTPUT
*/


/*
* ANALOG_OUTPUT
*/

#define __S2_Source_Definition_Writer_SOURCES_AUDIO_IDS$_STRING_OUTPUT 0
#define __S2_Source_Definition_Writer_SOURCES_VIDEO_IDS$_STRING_OUTPUT 1
#define __S2_Source_Definition_Writer_SOURCES_NAMES$_STRING_OUTPUT 2


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
#define __S2_Source_Definition_Writer_SOURCE_AUDIO_ID_INTEGER_PARAMETER 10
#define __S2_Source_Definition_Writer_SOURCE_AUDIO_ID_ARRAY_LENGTH 20
#define __S2_Source_Definition_Writer_SOURCE_VIDEO_ID_INTEGER_PARAMETER 30
#define __S2_Source_Definition_Writer_SOURCE_VIDEO_ID_ARRAY_LENGTH 20
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
#define __S2_Source_Definition_Writer_SOURCE_NAME_STRING_PARAMETER 50
#define __S2_Source_Definition_Writer_SOURCE_NAME_ARRAY_NUM_ELEMS 20
#define __S2_Source_Definition_Writer_SOURCE_NAME_ARRAY_NUM_CHARS 15
CREATE_STRING_ARRAY( S2_Source_Definition_Writer, __SOURCE_NAME, __S2_Source_Definition_Writer_SOURCE_NAME_ARRAY_NUM_ELEMS, __S2_Source_Definition_Writer_SOURCE_NAME_ARRAY_NUM_CHARS );


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

START_GLOBAL_VAR_STRUCT( S2_Source_Definition_Writer )
{
   void* InstancePtr;
   struct GenericOutputString_s sGenericOutStr;
   unsigned short LastModifiedArrayIndex;

   DECLARE_IO_ARRAY( __SOURCE_AUDIO_ID );
   DECLARE_IO_ARRAY( __SOURCE_VIDEO_ID );
   DECLARE_STRING_ARRAY( S2_Source_Definition_Writer, __SOURCE_NAME );
};

START_NVRAM_VAR_STRUCT( S2_Source_Definition_Writer )
{
};



#endif //__S2_SOURCE_DEFINITION_WRITER_H__

