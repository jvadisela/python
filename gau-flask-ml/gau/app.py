from flask import Flask, jsonify, request, render_template, make_response
from util import json_utils
from flask_swagger_ui import get_swaggerui_blueprint
from flasgger import Swagger
from flasgger.utils import swag_from
from flasgger import LazyString, LazyJSONEncoder

import flask_monitoringdashboard as dashboard
import json
import logging

app = Flask(__name__)


app.config["SWAGGER"] = {"title": "GAU-ML-UI", "uiversion": 2}

swagger_config = {
    "headers": [],
    "specs": [
        {
            "endpoint": "apispec_1",
            "route": "/apispec_1.json",
            "rule_filter": lambda rule: True,  # all in
            "model_filter": lambda tag: True,  # all in
        }
    ],
    "static_url_path": "/flasgger_static",
    # "static_folder": "static",  # must be set by user
    "swagger_ui": True,
    "specs_route": "/swagger/"
}

template = dict(
    swaggerUiPrefix=LazyString(lambda: request.environ.get("HTTP_X_SCRIPT_NAME", ""))
)

app.json_encoder = LazyJSONEncoder
swagger = Swagger(app, config=swagger_config, template=template)


app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True
dashboard.bind(app)

logging.basicConfig(level=logging.DEBUG)

team = [
    {
        "name": "Jaya Shankar Vadisela",
        "bigdata_stack": ["Apache Spark", "Hive", "Kafka", "HBase"],
        "languages": ["Java", "Scala", "Python"]
    },
    {
        "name": "Venkat Sai Raghu",
        "bigdata_stack": ["Apache Spark", "Kafka", "MongoDB"],
        "languages": ["R", "Scala", "Python"]
    }
]


def add_2_numbers(num1, num2):
    output = {"sum_of_numbers": 0}
    sum_of_2_numbers = num1 + num2
    output["sum_of_numbers"] = sum_of_2_numbers
    return output


@app.route("/add_2_numbers", methods=["POST"])
@swag_from("static/swagger_config.yml")
def add_numbers():
    input_json = request.get_json()
    try:
        num1 = int(input_json["x1"])
        num2 = int(input_json["x2"])
        res = add_2_numbers(num1, num2)
    except:
        res = {"success": False, "message": "Unknown error"}

    return json.dumps(res)

@app.route("/is_valid", methods=['POST'])
def first_hello_world():
    movie = request.get_json()
    print(movie)
    return 'First One'


@app.route("/second")
def second_hello_world():
    return 'Second One'


@app.route("/")
def all_other():
    app.logger.info('Processing default request')
    json_data = json.loads('{"name": "jane doe", "rollnumber": 25, "marks": 72}')
    is_valid = json_utils.is_valid_input(json_data)
    if is_valid:
        print("Given JSON data is Valid")
    else:
        print("Given JSON data is InValid")

    print("Is valid input :: {}".format(is_valid))
    return jsonify(team)


@app.route('/welcome')
def welcome():
    return render_template('welcome.html')  # render a template


@app.errorhandler(400)
def not_found(error):
    """
    In case of 400, build the response and throw as JSON
    """
    return make_response(jsonify( { 'error-400': 'Bad request' } ), 400)


@app.errorhandler(404)
def not_found(error):
    """
    In case of 404, build the response and throw as JSON
    """
    return make_response(jsonify( { 'error-404': 'Not found' } ), 404)


if __name__ == '__main__':
    app.run(host='0.0.0.0')
    #app.run(host='localhost')


