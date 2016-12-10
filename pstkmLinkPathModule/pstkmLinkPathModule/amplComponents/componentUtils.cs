using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace pstkmLinkPathModule.amplComponents
{
    static class componentUtils
    {
        private static string getComponentSubdataByIndex(string componentData, int index)
        {
            string data = "";
            try
            {
                data = componentData.Split(' ')[index];
            }
            catch
            {
                data = "Unknown_component_data";
            }
            return data;
        }
        public static string getComponentName(string componentData)
        {
            return getComponentSubdataByIndex(componentData, 1);
        }
        public static string getComponentValues(string componentData)
        {
            return getComponentSubdataByIndex(componentData, 2);
        }
    }
}
