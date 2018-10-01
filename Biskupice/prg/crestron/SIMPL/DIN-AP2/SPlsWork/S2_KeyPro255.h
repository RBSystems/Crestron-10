#ifndef __S2_KEYPRO255_H__
#define __S2_KEYPRO255_H__




/*
* Constructor and Destructor
*/

/*
* DIGITAL_INPUT
*/
#define __S2_KeyPro255_KEYBOARDGO_DIG_INPUT 0
#define __S2_KeyPro255_CLEAR_DIG_INPUT 1
#define __S2_KeyPro255_BACK_DIG_INPUT 2


/*
* ANALOG_INPUT
*/
#define __S2_KeyPro255_MAXCHARACTERS_ANALOG_INPUT 0
#define __S2_KeyPro255_KEYBOARDAN_ANALOG_INPUT 1

#define __S2_KeyPro255_TEXTIN$_STRING_INPUT 2
#define __S2_KeyPro255_TEXTIN$_STRING_MAX_LEN 255
CREATE_STRING_STRUCT( S2_KeyPro255, __TEXTIN$, __S2_KeyPro255_TEXTIN$_STRING_MAX_LEN );



/*
* DIGITAL_OUTPUT
*/


/*
* ANALOG_OUTPUT
*/

#define __S2_KeyPro255_TEXT$_STRING_OUTPUT 0


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

START_GLOBAL_VAR_STRUCT( S2_KeyPro255 )
{
   void* InstancePtr;
   struct GenericOutputString_s sGenericOutStr;
   unsigned short LastModifiedArrayIndex;

   DECLARE_STRING_STRUCT( S2_KeyPro255, __TEXTIN$ );
};

START_NVRAM_VAR_STRUCT( S2_KeyPro255 )
{
};



#endif //__S2_KEYPRO255_H__

