#ifndef __S2_ANALOGTOSERIAL_H__
#define __S2_ANALOGTOSERIAL_H__




/*
* Constructor and Destructor
*/

/*
* DIGITAL_INPUT
*/


/*
* ANALOG_INPUT
*/
#define __S2_AnalogToSerial_A_ANALOG_INPUT 0




/*
* DIGITAL_OUTPUT
*/


/*
* ANALOG_OUTPUT
*/

#define __S2_AnalogToSerial_STR_STRING_OUTPUT 0


/*
* Direct Socket Variables
*/




/*
* INTEGER_PARAMETER
*/
#define __S2_AnalogToSerial_OUTMAXVAL_INTEGER_PARAMETER 10
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
#define __S2_AnalogToSerial_PREF_STRING_PARAMETER 11
#define __S2_AnalogToSerial_SUF_STRING_PARAMETER 12
#define __S2_AnalogToSerial_PREF_PARAM_MAX_LEN 10
CREATE_STRING_STRUCT( S2_AnalogToSerial, __PREF, __S2_AnalogToSerial_PREF_PARAM_MAX_LEN );
#define __S2_AnalogToSerial_SUF_PARAM_MAX_LEN 10
CREATE_STRING_STRUCT( S2_AnalogToSerial, __SUF, __S2_AnalogToSerial_SUF_PARAM_MAX_LEN );


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

START_GLOBAL_VAR_STRUCT( S2_AnalogToSerial )
{
   void* InstancePtr;
   struct GenericOutputString_s sGenericOutStr;
   unsigned short LastModifiedArrayIndex;

   DECLARE_STRING_STRUCT( S2_AnalogToSerial, __PREF );
   DECLARE_STRING_STRUCT( S2_AnalogToSerial, __SUF );
};

START_NVRAM_VAR_STRUCT( S2_AnalogToSerial )
{
};



#endif //__S2_ANALOGTOSERIAL_H__

