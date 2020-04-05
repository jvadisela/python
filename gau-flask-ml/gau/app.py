from flask import Flask, jsonify, request, render_template, make_response
from util import json_utils

# import flask_monitoringdashboard as dashboard
import json
import logging

app = Flask(__name__)
app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True
# dashboard.bind(app)

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
    return make_response(jsonify( { 'error': 'Bad request' } ), 400)


@app.errorhandler(404)
def not_found(error):
    """
    In case of 404, build the response and throw as JSON
    """
    return make_response(jsonify( { 'error': 'Not found' } ), 404)


if __name__ == '__main__':
    app.run()
