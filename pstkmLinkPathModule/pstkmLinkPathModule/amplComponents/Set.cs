using pstkmLinkPathModule.amplComponents;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace pstkmLinkPathModule
{
    class Set : amplComponent
    {
        private string name;
        public string Name { get; }
        public void parseComponentData(string componentData)
        {
            name = componentUtils.getComponentName(componentData);
        }
    }
}
