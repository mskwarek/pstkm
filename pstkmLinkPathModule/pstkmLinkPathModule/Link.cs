using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace pstkmLinkPathModule
{
    class Link : NodeToNodeConnection
    {
        private Node start_node;
        private Node end_node;

        public Link(Node start, Node end)
        {
            this.start_node = start;
            this.end_node = end;
        }
    }
}
