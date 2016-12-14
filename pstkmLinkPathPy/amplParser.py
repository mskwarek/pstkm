import os
from amplComponents import Set, Param, Utils, AmplComponentFactory


class AmplParser:

    def __init__(self):
        self.file = None
        self.data = list()
        self.ampl_component = list()

    '''
    Return void

    Transform raw data to python format.
    '''
    def transform_ampl_data_to_py(self, file_path):
        raw_data = self.read_raw_data(file_path)
        self.clean_raw_data(raw_data)
        for s in self.data:
            self.parse_data(s)

    '''
    Return list of read data

    Read raw data from *.dat file.
    '''
    def read_raw_data(self, file_path):
        data = list()
        if os.path.exists(file_path):
            with open(file_path, 'rb') as self.file:
                try:
                    for line in self.file:
                        data.append(line)
                    return data
                except :
                    print 'Error during reading file'


    '''
    Return void

    Clean data read from file - remove blank lines and group lines related to each variable (set or param).
    '''
    def clean_raw_data(self, data):
        d = ''
        for r in data:
            if r != '\n' and r != '\n\n':
                r = Utils.remove_tabs_from_string(r)
                d += r
                if ';' in d:
                    self.data.append(d)
                    d = ''


    '''
    Return void

    Parse raw data and create adequate classes which describe its content.
    '''
    def parse_data(self, data):
        component = AmplComponentFactory.get_component(data)
        component.parse_component_data(data)
        self.ampl_component.append(component)

    def get(self, name):
        for i in range(len(self.ampl_component)):
            if name in self.ampl_component[i].name:
                return self.ampl_component[i].data.split(' ')

    def get_edges(self):
        for i in range(len(self.ampl_component)):
            if 'EDGE' in self.ampl_component[i].name:
                return self.parse_edges(self.ampl_component[i].data)


    def parse_edges(self, raw_edges):
        raw_edges = raw_edges.replace(') (', '), (')
        tmp = raw_edges.split(',')
        edges = list()
        for t in tmp:
            s = t.split(', ')
            s[0] = s[0].replace('(', '')
            s[1] = s[1].replace(')', '')
            edges.append(tuple(str(s[0]), str(s[1])))
        return edges
