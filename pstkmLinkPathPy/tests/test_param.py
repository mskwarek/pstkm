import unittest
from amplComponents import Param


class TestParam(unittest.TestCase):
    def test_parse_component_data(self):
        test_param = Param()
        test_param.parse_component_data("param TEST := test param")
        self.assertEqual("TEST", test_param.name, "Param name is NOK")
        self.assertEqual("test param", test_param.data, "Param data is NOK")

