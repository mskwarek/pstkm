def get_component_element_by_index(component_data, index):
    return component_data.split(":=")[index]


def get_component_info(component_data):
    return get_component_element_by_index(component_data, 0)


def get_component_value(component_data):
    return get_component_element_by_index(component_data, 1).strip()


def get_component_name(component_data):
    return get_component_info(component_data).split(' ')[1]


def get_component_type(component_data):
    return get_component_info(component_data).split(' ')[0]


