import sys
import logging

from io import StringIO
from mako.runtime import Context
from mako.template import Template
from mako import exceptions

# this function reads a SQL template and substitutes the values at runtime and
# creates list of SQL statements
def parse_sql_template(sql_template_filename:str, macro_variables:dict) -> list[str]:
    # Load template
    try:
        mytemplate = Template(filename=sql_template_filename, strict_undefined=True)
        result = mytemplate.render(**macro_variables)
        sql_commands = [x.strip() for x in result.split(';')]

        # filter out any empty spaces in the list
        sql_commands = list(filter(None, sql_commands))
        print(sql_commands)
    except FileNotFoundError as err:
        logging.error("Failed to load server config template. " + err.strerror)
        sys.exit(3)
    except NameError as err:
        # default error handling does not show you missing name var
        logging.error("Variable substition is missing :: " + exceptions.text_error_template().render())
        exit(3)
