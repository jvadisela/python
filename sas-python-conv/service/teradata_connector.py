# This class would read the data from Teradata
from mako.template import Template

def execute_sqls(filename):
    # Open and read the file as a single buffer
    fd = open(filename, 'r')
    sql_file = fd.read()
    fd.close()

    # all SQL commands (split on ';')
    sql_commands = [x.strip() for x in sql_file.split(';')]

    # filter out any empty spaces in the list
    sql_commands = list(filter(None, sql_commands))

    # Execute every command from the input file
    for sql in sql_commands:
        __execute_sql(sql)


# private function and not to be exposed outside of this class
# Celia code goes here to connect to Teradata and execute the SQL
def __execute_sql(sql):
    print("sql : ", sql)
