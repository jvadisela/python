# This is a sample Python script.
from pathlib import Path
import os
from service.teradata_connector import execute_sqls
from service.sql_template_reader import parse_sql_template
from service.py_ftl_generator import *
from core.utils import *

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.
# Sample

def run():
    file_path = root_dir() + '/sqls/file_1.sql'
    print(file_path)
    # execute_sqls(file_path)
    macro_variables = read_macros_from_yml()
    print(macro_variables)
    parse_sql_template(file_path, macro_variables)

    #test_regular_expr()
    sas_file_path = root_dir() + '/sas_sql_templates/03 Trxns.txt'
    convert_to_python_sql_ftl(sas_file_path)


def read_macros_from_yml():
    all_config = read_yaml("props/example_yaml.yml")
    #print(all_config)
    app_config = all_config['APP']
    #print(app_config)
    return app_config

def read_sql_template_with_dynamic_params(macro_variables):
    parse_sql_template(file_path, phonebook)

# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    run()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
