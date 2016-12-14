import networkx as nx
import matplotlib.pyplot as plt
from amplParser import AmplParser
from ksp import YenKSP

class Graph:

    def __init__(self):
        self.graph = nx.Graph()
        self.amplParser = AmplParser()
        self.transport_nodes = None
        self.central_node = None
        self.demands = None
        self.edges = None
        self.amplParser.transform_ampl_data_to_py('data/trivial.dat')


    def get_nodes(self):
        self.transport_nodes = self.amplParser.get('TRANSPORT_NODE')
        self.central_node = self.amplParser.get('CENTRAL')

    def get_demands(self):
        self.demands = self.amplParser.get('DEMAND')

    def get_edges(self):
        self.edges = self.amplParser.get_edges()

    def generate_graph(self):
        self.get_nodes()
        self.get_edges()
        self.get_demands()
        self.graph.add_edges_from(self.edges)

    def draw(self):
        self.generate_graph()
        nx.draw(self.graph, with_labels=True)
        plt.show()

    def add_nodes(self, nodes, color):
        for n in nodes:
            self.graph.add_node(n, node_color = color)

if __name__ == '__main__':
    graph = Graph()
    graph.draw()


