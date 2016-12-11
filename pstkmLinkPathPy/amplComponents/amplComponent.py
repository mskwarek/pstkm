class AmplComponent(object):
    def __init__(self):
        self.name = ""
        self.data = ""

    def parse_component_data(self, component_data):
        raise NotImplementedError()
