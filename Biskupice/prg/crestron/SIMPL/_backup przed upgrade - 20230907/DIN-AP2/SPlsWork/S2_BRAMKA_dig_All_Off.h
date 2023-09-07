#ifndef __S2_BRAMKA_DIG_ALL_OFF_H__
#define __S2_BRAMKA_DIG_ALL_OFF_H__




/*
* Constructor and Destructor
*/

/*
* DIGITAL_INPUT
*/
#define __S2_BRAMKA_dig_All_Off_DIG_RES_DIG_INPUT 0


/*
* ANALOG_INPUT
*/




/*
* DIGITAL_OUTPUT
*/


/*
* ANALOG_OUTPUT
*/

#define __S2_BRAMKA_dig_All_Off_STR_OUT_STRING_OUTPUT 0


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
#define __S2_BRAMKA_dig_All_Off_JOIN_INTEGER_PARAMETER 10
#define __S2_BRAMKA_dig_All_Off_JOIN_ARRAY_LENGTH 10
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

START_GLOBAL_VAR_STRUCT( S2_BRAMKA_dig_All_Off )
{
   void* InstancePtr;
   struct GenericOutputString_s sGenericOutStr;
   unsigned short LastModifiedArrayIndex;

   DECLARE_IO_ARRAY( __JOIN );
};

START_NVRAM_VAR_STRUCT( S2_BRAMKA_dig_All_Off )
{
   unsigned short __MX;
};



#endif //__S2_BRAMKA_DIG_ALL_OFF_H__

