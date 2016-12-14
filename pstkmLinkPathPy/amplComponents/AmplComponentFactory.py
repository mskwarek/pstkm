from amplComponents import Param
from amplComponents import Set



class AmplComponentFactory(object):

    @staticmethod
    def get_component(name):
        if 'param' in name:
            return Param()
        elif 'set' in name:
            return Set()
        raise TypeError('Unknown component.')


