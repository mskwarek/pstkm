from amplComponent import *
from Utils import *


class Param(AmplComponent):
    def parse_component_data(self, component_data):
        self.name = get_component_name(component_data)
        self.data = get_component_value(component_data)

