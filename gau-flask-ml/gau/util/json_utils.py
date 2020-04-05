import json
import jsonschema
from jsonschema import validate

studentSchema = {
    "type": "object",
    "properties": {
        "name": {"type": "string"},
        "rollnumber": {"type": "number"},
        "marks": {"type": "number"},
    },
}


def is_valid_input(json_data):
    try:
        validate(instance=json_data, schema=studentSchema)
    except jsonschema.exceptions.ValidationError as err:
        return False
    return True
