using pstkmLinkPathModule.amplComponents;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace pstkmLinkPathModule
{
    static class amplComponentFactory
    {
        static amplComponent getComponentFromConfig(string component_key_word)
        {
            switch (component_key_word)
            {
                case "set":
                    return new Set();
                case "param":
                    return new Param();
                default:
                    return new unknownComponent();
            }
    }
}
