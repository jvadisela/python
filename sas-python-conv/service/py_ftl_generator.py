import os
import re

import numpy as numpy
from pathlib import Path
from core.utils import read_yaml, root_dir

def test_regular_expr():
    sas_macro_variables = ['@default_one.']
    xx = "drop table sasptmp.&t_name._DRIVER_FILE_TY_S;"
    sas_macro_variables = sas_macro_variables + re.findall(r'[&]\S*[.]', xx, re.MULTILINE)
    print(sas_macro_variables)


def convert_to_python_sql_ftl(sas_sql_template_filename: str):
    ftl_name = _generate_ftl_name(sas_sql_template_filename)
    sas_macro_variables = _extract_macros_from_file(sas_sql_template_filename)
    subsitutions_dict = _create_py_macro_variables(sas_macro_variables)
    print(subsitutions_dict)
    _generate_py_sql_ftl(sas_sql_template_filename, subsitutions_dict)


def _generate_py_sql_ftl(sas_sql_template_filename: str, subsitutions_dict: dict):
    # Creating an output file in writing mode
    output_file = open(_generate_ftl_name(sas_sql_template_filename), "w")
    # Opening input file and scanning each line
    # from input file and writing in output file
    with open(sas_sql_template_filename, "r") as scan:
        input_lines: list[str] = scan.readlines()
        output_lines: list[str] = list()

        for line in input_lines:
            for f_key, f_value in subsitutions_dict.items():
                if f_key in line:
                    line = line.replace(f_key, f_value)
            if is_valid_line(line.strip()):
                # output_file.write(line)
                output_lines.append(line)

    output_file.writelines(output_lines)
    # Closing the output file
    output_file.close()


def is_valid_line(line: str):
    if line == 'proc sql;' or line == 'quit;' or line.startswith('connect to teradata as'):
        return False
    return True


def _create_py_macro_variables(sas_macro_variables: list[str]):
    subsitutions_dict = {}
    for sas_macro_var in sas_macro_variables:
        py_macro_var = "${" + sas_macro_var[1:len(sas_macro_var) - 1] + "}"
        subsitutions_dict[sas_macro_var] = py_macro_var
    return subsitutions_dict


def _extract_macros_from_file(sql_template_filename: str):
    sas_macro_variables = []
    file = open(sql_template_filename, 'r')
    # extract macro variables in each line
    for line in file.readlines():
        sas_macro_variables = sas_macro_variables + _extract_macros(line)
    # remove duplicates
    sas_macro_variables = numpy.unique(sas_macro_variables)
    # trim extra spaces if any
    sas_macro_variables = [x.strip() for x in sas_macro_variables]
    return sas_macro_variables


def _extract_macros(str_line: str):
    sas_macro_variables = []
    sas_macro_variables = sas_macro_variables + re.findall(r'[&]\S*[.]', str_line, re.MULTILINE)
    return sas_macro_variables


def _generate_ftl_name(sql_template_filename: str) -> str:
    basedir, filename = os.path.split(sql_template_filename)
    ftl_name = filename.replace('.txt', '.ftl')
    return root_dir() + '/py_sql_templates/' + ftl_name
