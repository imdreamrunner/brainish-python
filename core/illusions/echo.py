__author__ = "imdreamrunner"
__email__ = "imdreamrunner@gmail.com"


def to_bash(janish):
    assert "input" in janish, "Echo must have input."
    assert "content" in janish["input"], "Echo must have content as input."
    return 'ECHO "' + janish["input"]["content"] + '"\n'
