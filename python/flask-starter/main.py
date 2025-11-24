from flask import Flask, render_template

app: Flask = Flask(__name__)


@app.route("/")
def index():
    return render_template("page.jinja2", msg="herp derp")


@app.route("/favicon.ico")
def favicon():
    return app.send_static_file("favicon.png")


if __name__ == "__main__":
    app.run(debug=True)
