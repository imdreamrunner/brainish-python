from webapp import app
import logging

__author__ = "imdreamrunner"
__email__ = "imdreamrunner@gmail.com"

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    app.run(host="0.0.0.0", debug=True)