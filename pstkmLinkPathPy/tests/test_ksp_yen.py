import unittest
import ksp


class TestKsp_yen(unittest.TestCase):
    G = ksp.DiGraph("net7")

    # Get the painting object and set its properties.
    paint = G.painter()
    paint.set_source_sink("C", "H")
    paint.set_rank_same(['C', 'D', 'F'])
    paint.set_rank_same(['E', 'G', 'H'])

    # Generate the graph using the painter we configured.
    G.export(False, paint)

    # Get 30 shortest paths from the graph.
    items = ksp.YenKSP.ksp_yen(G, "C", "H", 30)
    for path in items:
        print "Cost:%s\t%s" % (path['cost'], "->".join(path['path']))
