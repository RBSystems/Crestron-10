using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public delegate void EmptyActionDelegate();
    public delegate void IntegerActionDelegate(ushort _value);
    public delegate void StringActionDelegate(SimplSharpString _message);
}