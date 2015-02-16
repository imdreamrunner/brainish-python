from flask import Flask, render_template, request
import logging

__author__ = "imdreamrunner"
__email__ = "imdreamrunner@gmail.com"


app = Flask(__name__, static_url_path="")
log = logging.getLogger(__name__)


@app.route("/")
def index_page():
    return render_template("index.jinja2")


@app.route("/compile", methods=["POST"])
def compile_janish():
    janish = request.get_json()
    log.info("Requested janish: " + str(janish))
    from core import brainish
    bash = brainish.compile_janish(janish)
    log.info("Compiled bash: " + bash)
    return bash