using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;
using Crestron.SimplSharp.CrestronIO;
using Crestron.SimplSharp.CrestronXml.Serialization;

namespace ssl_AVSystem
{
    public static class CXMLSerialization
    {
       
        public static void WriteToXMLFile<T>(string filePath, T objectToWrite)
        {
            using (Stream stream = File.Open(filePath, FileMode.Create))
            {
                CrestronXMLSerialization.SerializeObject(stream, objectToWrite);
            }
        }
     

        public static T ReadFromXMLFile<T>(string filePath)
        {
            using (Stream stream = File.Open(filePath, FileMode.Open))
            {
                return CrestronXMLSerialization.DeSerializeObject<T>(stream);
            }
        }
    }
}